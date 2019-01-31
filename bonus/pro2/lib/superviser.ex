defmodule Superviser do
    use GenServer

    def passive_node_list_adder(pid, message) do
        GenServer.cast(pid, {:passive_node_list_adder, message})
    end

    def passive_node_list_getter(pid) do
        GenServer.call(pid, :passive_node_list_getter, :infinity)
    end

    def active_node_list_getter(pid, index, topology, total_nodes) do
        GenServer.call(pid, {:active_node_list_getter, index, topology, total_nodes}, :infinity)
    end

    def random_active_node_list(topology, total_nodes, index, msgs) do
        temp = Enum.filter(Enum.filter(Enum.filter(Topology.get_topology(topology, total_nodes, index), fn(x) -> x != index == true end), fn(x) -> x <= total_nodes == true end), fn x -> !Enum.member?(msgs, x) end)
        len = Kernel.length(temp)
            if len == 0 and topology == "line" do
         :timer.sleep 10
        Process.exit(:global.whereis_name(:project),:kill)
        end
        if(len == 0) do
            random_active_node_list(topology, total_nodes, index, msgs)
        else
            Enum.at(temp, :rand.uniform(Kernel.length(temp))-1)
        end
    end

    def init(msgs) do
        {:ok, msgs}
    end

    def handle_call(:passive_node_list_getter, _from, msgs) do
        {:reply, msgs, msgs}
    end

    def handle_cast({:passive_node_list_adder, msg}, msgs) do
              msgs = [msg | msgs]
    msgs = Enum.uniq(msgs)
    {:noreply, msgs}
    end

    def handle_call({:active_node_list_getter, index, topology, total_nodes}, _from, msgs) do
        {:reply, random_active_node_list(topology, total_nodes, index, msgs), msgs}
    end
end