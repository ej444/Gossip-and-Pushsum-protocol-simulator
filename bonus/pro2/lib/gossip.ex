defmodule GossipProtocol do
    use GenServer

    def start_link do
        GenServer.start_link(__MODULE__, [])
    end

    def add_message(pid, message, index, topology, total_nodes) do
        GenServer.cast(pid, {:add_message, message, index, topology, total_nodes})
    end

    def find_convergence(total_nodes, start_time, topology , check_state, lost_nodes) do
       temp= Superviser.passive_node_list_getter(:global.whereis_name(:supervisor_node))
       temp_length=Kernel.length(temp)
        convergence_limit = cond do 
            topology == "line" -> 0.2
            topology == "imp_line" -> 0.1
            topology == "full" -> 0.1
            topology == "3D" -> 0.1
            topology == "rand2D"-> 0.4
            topology == "torus" -> 0.3
        end
        check =
           if (temp_length/total_nodes >= 0.5*convergence_limit and check_state == false) do
      # randomly break connection for specific percentage of nodes
                true
      Enum.map(1..lost_nodes, fn(_) -> new_passive_node = :rand.uniform(total_nodes) 
        Superviser.passive_node_list_adder(:global.whereis_name(:supervisor_node), new_passive_node)
      end)
    else 
      false
    end
        if(Kernel.length(Superviser.passive_node_list_getter(:global.whereis_name(:supervisor_node)))/total_nodes >= convergence_limit) do
            IO.puts("Time = #{System.system_time(:millisecond)-start_time}")
            Process.exit(self(), :kill)
        end
        find_convergence(total_nodes, start_time, topology ,  check, lost_nodes)
    end

    def init(msgs) do
        {:ok, msgs}
    end

    def handle_cast({:add_message, msg, index, topology, total_nodes}, msgs) do
        if(msgs == 10) do
            IO.puts("Node converged: #{index}")
            Superviser.passive_node_list_adder(:global.whereis_name(:supervisor_node), index)
        end
        curr_node = Superviser.active_node_list_getter(:global.whereis_name(:supervisor_node), index, topology, total_nodes)
        GossipProtocol.add_message(:global.whereis_name(String.to_atom("node#{curr_node}")), msg, curr_node, topology, total_nodes)
        {:noreply, msgs+1}
    end
end