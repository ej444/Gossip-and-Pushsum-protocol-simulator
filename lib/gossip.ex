defmodule GossipProtocol do
    use GenServer

    def start_link do
        GenServer.start_link(__MODULE__, [])
    end

    def add_message(pid, message, index, topology, total_nodes) do
        GenServer.cast(pid, {:add_message, message, index, topology, total_nodes})
    end

    def find_convergence(total_nodes, start_time, topology) do
        convergence_limit = cond do 
            topology == "line" -> 0.2
            topology == "imp_line" -> 0.4
            topology == "full" -> 0.7
            topology == "3D" -> 0.1
            topology == "rand2D"-> 0.4
            topology == "torus" -> 0.1
        end
        if(Kernel.length(Superviser.passive_node_list_getter(:global.whereis_name(:supervisor_node)))/total_nodes >= convergence_limit) do
            IO.puts("Time = #{System.system_time(:millisecond)-start_time}")
            Process.exit(self(), :kill)
        end
        find_convergence(total_nodes, start_time, topology)
    end

    def init(msgs) do
        {:ok, msgs}
    end

    def handle_cast({:add_message, msg, index, topology, total_nodes}, msgs) do
        if(msgs == 10) do
            Process.sleep(10)
            IO.puts(index)
            Superviser.passive_node_list_adder(:global.whereis_name(:supervisor_node), index)
        end
        curr_node = Superviser.active_node_list_getter(:global.whereis_name(:supervisor_node), index, topology, total_nodes)
        GossipProtocol.add_message(:global.whereis_name(String.to_atom("node#{curr_node}")), msg, curr_node, topology, total_nodes)
        {:noreply, msgs+1}
    end
end