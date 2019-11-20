function this_C = collisionCheck(this_C,index,design,O,goal,type,tube_rad,L,rot_max)
%collisionCheck recurs over tree, starting at node specified by index,
%checking for collisions at each node. If there is a collision, the subtree
%from that node is deleted from the graph. Recursion stops when either a
%node has already been checked or the base node is reached.
%   
%   Input:
%   this_C   - configuration struct for the current design
%   index    - index (in graph and row of matrix) of the node to be checked
%   design   - current design configuration
%   O        - obstacles struct with list of center points and sphere rad
%   type     - base type
%   tube_rad - given tube radius
%   length   - given max tube length
%
%   Output:
%   this_C - updates the configuration struct


min_weight = 0.1;
weight_mult = 0.95;

% if index is base or it has already been checked
if index == 1 || this_C.checked(index) == true
    return  %make sure variable has been properly updated
end
% Get parent index before deleting node
parent_index = predecessors(this_C.graph,int2str(index));

rotation_mapped = this_C.mat(index,2)*2*pi/rot_max - pi; % maps to [-pi pi]
this_config = [this_C.mat(index,1),rotation_mapped];

[collision_bool,goal_bool] = collisionNode(type,this_config,design,O,goal,tube_rad,L);
if collision_bool
    %if in collision, delete node and subtree
    [this_C.graph, this_C.mat] = deleteSubtree(this_C.graph,index,this_C.mat);
    this_C.weight = min_weight + weight_mult * (this_C.weight - min_weight); % decrease weight for this design
else 
    this_C.checked(index) = true;
    this_C.weight = 1 + weight_mult * (this_C.weight - 1); % increase weight for this design
    if goal_bool
        this_C.goal_ind(index) = true;
        this_C.goal = true;
    end
end

% recur on parent  
%--- when I delete subtree, I should erase the subtree goal indices too---*
this_C = collisionCheck(this_C,str2num(parent_index{:}),design,O,goal,type,tube_rad,L,rot_max);
end


function [new_graph, new_mat] = deleteSubtree(graph,index,mat)
% base case for leaves
if outdegree(graph,int2str(index)) == 0
    new_graph = rmnode(graph,int2str(index));
    mat(index,1:2) = [-50 -50]; % effectively removing this node from the matrix - won't be a nearest neighbor
    new_mat = mat;
else
    children = successors(graph,int2str(index));
    % for each child, deleteSubtree and pass the graph on to the next
    interm_g = rmnode(graph,int2str(index));
    mat(index,1:2) = [-50 -50];
    interm_mat = mat;  % do you need an intermediate variable???
    for i = 1:length(children)
        [interm_g, interm_mat] = deleteSubtree(interm_g,str2num(children{i}),interm_mat);
    end
    new_graph = interm_g;
    new_mat = interm_mat;
end

end
