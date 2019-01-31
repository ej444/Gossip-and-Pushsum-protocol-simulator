defmodule PushSumProtocol do
    use GenServer

    def start_link do
        GenServer.start_link(__MODULE__, [])
    end

    def add_message(pid, message, index, topology, total_nodes, s_reduced, w_reduced) do
        GenServer.cast(pid, {:add_message, message, index, topology, total_nodes, s_reduced, w_reduced})
    end

    def find_convergence(total_nodes, start_time, topology , check_state, lost_nodes) do
        temp=Superviser.passive_node_list_getter(:global.whereis_name(:supervisor_node))
        temp_length = Kernel.length(temp)
        convergence_limit = cond do
            topology == "line" -> 0.2
            topology == "imp_line" -> 0.7
            topology == "full" -> 0.8
            topology == "3D" -> 0.1
            topology == "rand2D"-> 0.7
            topology == "torus" -> 0.2
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
        if(temp_length/total_nodes >= convergence_limit) do
            IO.puts "Time = #{System.system_time(:millisecond)-start_time}"
            Process.exit(self(), :kill)
        end
        find_convergence(total_nodes, start_time, topology, check, lost_nodes)
    end

    def init(msgs) do
        {:ok, msgs}
    end

    def handle_cast({:add_message, msg, index, topology, total_nodes, s_reduced, w_reduced}, msgs) do
        {s_updated, w_updated} = {Enum.at(msgs, 0)+s_reduced, Enum.at(msgs, 1)+w_reduced}
        {convergence_ratio_old, convergence_ratio_new} = {Enum.at(msgs, 0)/Enum.at(msgs, 1), s_updated/w_updated}
        convergence_counter = if(convergence_ratio_old-convergence_ratio_new < :math.pow(10, -10)) do
            if(Enum.at(msgs, 2) == 2) do
                IO.puts("Node converged  : #{index}")
                Superviser.passive_node_list_adder(:global.whereis_name(:supervisor_node), index)
            end
            Enum.at(msgs, 2)+1
        else 
            0
        end

    curr_node = Superviser.active_node_list_getter(:global.whereis_name(:supervisor_node), index, topology, total_nodes)
    PushSumProtocol.add_message(:global.whereis_name(String.to_atom("node#{curr_node}")), msg, curr_node, topology, total_nodes, s_reduced, w_reduced)
    {:noreply, [0.5*s_updated, 0.5*w_updated, convergence_counter]}
  end
end