<h3>Gossip Simulator</h3>

<b>Distributed Operating Systems - COP5615</b>

<b>Group Members</b>
```
Ratna Prakirana (UFID 3663-9969)
Eesh Kant Joshi (UFID 1010-1069)
```
<b>Path to the running file</b>
```
project2/lib/project2.ex
```
Kindly re-run the program with the same value if it encounters an issue (infinite run) , since it may not get to a node which is working due to removal of its neighboring nodes
So the max numbers of nodes is also  not  very large
<b>Execution command</b>
```
Command 1: mix escript.build
Command 2: escript project2 total_nodes topology protocol

eg: escript project2 5000 rand2D gossip
```

<b>Working</b>
```
Convergence of Gossip Algorithm for all topologies - line , imp_line , rand2D , 3D ,full ,torus
Convergence of Push sum Algorithm for all topologies - line , imp_line , rand2D , 3D ,full ,torus
```

<b>Largest Network</b>
```
Gossip Algorithm

Line Topology - 50 Nodes (actors)
Random 2D grid Topology - 20,000 Nodes
Imperfect line Topology - 4200 Nodes
Full network Topology - 2400 Nodes
Torus Topology - 1050 Nodes
3D grid Topology - 700 Nodes


Push sum Algorithm

Line Topology - 50 Nodes (actors)
Random 2D grid - 22,000 Nodes
Imperfect line Topology - 4400 Nodes
Full network Topology - 2500 Nodes
Torus Topology - 1100 Nodes
3D grid Topology - 700 Nodes
```