defmodule Topology do
    def line(index, total_nodes) do
        cond do
            index == 1 -> [index+1]
            index == total_nodes -> [index-1]
            true -> [index-1,index+1]
        end
    end

    def full(index, total_nodes) do
        for  i<- 1..total_nodes do i end -- [index]
    end

    def rand_gen(index, j, k, total_nodes) do
        rand_value = Enum.random(1..total_nodes)
        if(rand_value == index || rand_value == j || rand_value == k) do
            rand_gen(index,j,k,total_nodes)
        else
            rand_value
        end
    end

    def torus(index, total_nodes) do
        side = round(:math.sqrt(total_nodes))
        cond do
            index == 1 -> [index+1,index+side,side,total_nodes-side+1]
            index == side -> [index-1,index+side,1,total_nodes]
            index == total_nodes - side + 1 -> [index+1,index-side,1,total_nodes]
            index == total_nodes -> [index-1,index-side,total_nodes-side+1,side]
            index < side -> [index-1,index+1,index+side,index+total_nodes-side]
            index > total_nodes - side + 1 and index < total_nodes -> [index-1,index+1,index-side,index-total_nodes+side]
            rem((index-1),side) == 0 -> [index+1,index-side,index+side,index-1+side]
            rem(index,side) == 0 -> [index-1,index-side,index+side,index+1-side]
            true -> [index-1,index+1,index-side,index+side]
        end
    end

    def rand2d(index, total_nodes) do
        side = Kernel.trunc(round(:math.sqrt(total_nodes)))
        cond do
            index == 1 -> [rand_gen(index,0,0,total_nodes),rand_gen(index,index+1,0,total_nodes)]
            index == side -> [rand_gen(index,0,0,total_nodes),rand_gen(index,0,0,total_nodes)]
            index == total_nodes - side + 1 -> [rand_gen(index,0,0,total_nodes),rand_gen(index,0,0,total_nodes)]
            index == total_nodes -> [rand_gen(index,0,0,total_nodes),rand_gen(index,0,0,total_nodes)]
            index < side -> [rand_gen(index,0,0,total_nodes),rand_gen(index,0,0,total_nodes),rand_gen(index,0,0,total_nodes)]
            index > total_nodes - side + 1 and index < total_nodes -> [rand_gen(index,0,0,total_nodes),rand_gen(index,0,0,total_nodes),rand_gen(index,0,0,total_nodes)]
            rem(index-1,side) == 0 -> [rand_gen(index,0,0,total_nodes),rand_gen(index,0,0,total_nodes),rand_gen(index,0,0,total_nodes)]
            rem(index,side) == 0 -> [rand_gen(index,0,0,total_nodes),rand_gen(index,0,0,total_nodes),rand_gen(index,0,0,total_nodes)]
            true -> [rand_gen(index,0,0,total_nodes),rand_gen(index,0,0,total_nodes),rand_gen(index,0,0,total_nodes),rand_gen(index,0,0,total_nodes)]
        end
    end

    def threeD(index, total_nodes) do
        side = Kernel.trunc(round(:math.pow(total_nodes,(1/3))))
        k=:math.floor(index/(side*side))
        cond do
            index == 1 -> [index+1,index+side,index+side*side]
            index == side -> [index-1,index+side,index+side*side]
            index == side*side - side + 1 -> [index+1,index-side,index+side*side]
            index == side*side -> [index-1,index-side,index+side*side]
            index < side -> [index-1,index+1,index+side,index+side*side]
            index > side*side - side + 1 and index < side*side -> [index-1,index+1,index-side,index+side*side]
            index == side*side*(side-1) + 1 -> [index+1,index+side,index-side*side]
            index == side*side*(side-1) + side -> [index-1,index+side,index-side*side]
            index == side*side*side - side + 1 -> [index+1,index-side,index-side*side]
            index == side*side*side -> [index-1,index-side,index-side*side]
            index < side*side*(side-1) + side and index > side*side*(side-1) + 1 -> [index-1,index+1,index+side,index-side*side]
            index > side*side*side - side + 1 and index < side*side*side -> [index-1,index+1,index-side,index-side*side]
            index == k*side*side + 1 -> [index+1,index+side,index+side*side,index-side*side]
            index == k*side*side + side -> [index-1,index+side,index+side*side,index-side*side]
            index == k*side*side + side*side - side + 1 -> [index+1,index-side,index+side*side,index-side*side]
            index == k*side*side + side*side -> [index-1,index-side,index+side*side,index-side*side]
            index < k*side*side + side and   index > k*side*side + 1 -> [index-1,index+1,index+side,index+side*side,index-side*side]
            index > k*side*side + side*side - side + 1 and index < k*side*side -> [index-1,index+1,index-side,index+side*side,index-side*side]
            rem(index-1,side) == 0 and k==0 -> [index+1,index-side,index+side,index+side*side]
            rem(index-1,side) == 0 and k== side-1 -> [index+1,index-side,index+side,index-side*side]
            rem(index-1,side) == 0 -> [index+1,index-side,index+side ,index+side*side,index-side*side]
            rem(index,side) == 0 and k==0 -> [index-1,index-side,index+side,index+side*side]
            rem(index,side) == 0 and k== side-1 -> [index-1,index-side,index+side,index-side*side]
            rem(index,side) == 0 -> [index-1,index-side,index+side,index+side*side,index-side*side]
            k==0 -> [index-1,index+1,index+side,index-side,index+side*side]
            k==side-1 -> [index-1,index+1,index+side,index-side,index-side*side]
            true -> [index-1,index+1,index-side,index+side,index+side*side,index-side*side]
        end
    end

    def imperfect_line(index, total_nodes) do
        cond do
            index == 1 -> [index+1,rand_gen(index,index+1,0,total_nodes)]
            index == total_nodes -> [index-1,rand_gen(index,index-1,0,total_nodes)]
            true -> [index-1,index+1,rand_gen(index,index-1,index+1,total_nodes)]
        end
    end

    def get_topology(topology, total_nodes, index) do
        case topology do
            "line" -> line(index,total_nodes)
            "full" -> full(index,total_nodes)
            "imp_line" -> imperfect_line(index,total_nodes)
            "3D" -> threeD(index,total_nodes)
            "rand2D" -> rand2d(index,total_nodes)
            "torus" -> torus(index,total_nodes)
        end
    end
end