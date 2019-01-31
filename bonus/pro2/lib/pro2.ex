defmodule Pro2 do
  def main(args) do
    :global.register_name(:project, self())
    {t_nodes, topology, algorithm , lost_nodes } = {String.to_integer(Enum.at(args, 0)), Enum.at(args, 1), Enum.at(args, 2) , String.to_integer(Enum.at(args,3))}
    
    if t_nodes <= lost_nodes do
      IO.puts "Error - Lost nodes greater than total nodes"
      Process.exit(:global.whereis_name(:project),:kill)
    end
    total_nodes= case topology do
        "3D" -> Kernel.trunc(:math.pow(Float.floor(:math.pow(t_nodes, 1/3)), 3))
        "rand2D" -> Kernel.trunc(:math.pow(Float.floor(:math.sqrt(t_nodes)), 2))
        "torus" -> Kernel.trunc(:math.pow(Float.floor(:math.sqrt(t_nodes)), 2))
        "line" -> t_nodes
        "imp_line" -> t_nodes
        "full" -> t_nodes
    end

    start_time = System.system_time(:millisecond)
    if(algorithm == "gossip") do
        for(i <- 1..total_nodes) do
            {:ok, pid} = GenServer.start_link(GossipProtocol, 1, name: String.to_atom("node#{i}"))
            :global.register_name(String.to_atom("node#{i}"), pid)
	    end
        {:ok, new_pid} = GenServer.start_link(Superviser, [], name: :supervisor_node)
        :global.register_name(:supervisor_node, new_pid)
        :global.sync()
        GossipProtocol.add_message(:global.whereis_name(:start_node), "Eesh Joshi", :rand.uniform(total_nodes), topology, total_nodes)
        GossipProtocol.find_convergence(total_nodes, start_time, topology , false,lost_nodes)
    end

    if(algorithm == "push-sum") do
        for(i <- 1..total_nodes) do
            {:ok, pid} = GenServer.start_link(PushSumProtocol, [i, 1, 0], name: String.to_atom("node#{i}"))
            :global.register_name(String.to_atom("node#{i}"), pid)
        end
      {:ok, new_pid} = GenServer.start_link(Superviser, [], name: :supervisor_node)
      :global.register_name(:supervisor_node, new_pid)
      :global.sync()
      PushSumProtocol.add_message(:global.whereis_name(:start_node), "Ratna Prakirana", :rand.uniform(total_nodes), topology, total_nodes, 0, 1)
      PushSumProtocol.find_convergence(total_nodes, start_time, topology,false ,lost_nodes)
    end
  end
end