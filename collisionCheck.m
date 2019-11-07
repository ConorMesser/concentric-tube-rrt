function this_C = collisionCheck(this_C,index,design,O,type,tube_rad,L)
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

% if index is base or it has already been checked
if index == 1 || this_C.checked(index) == true
    return  %make sure variable has been properly updated
end
% Get parent index before deleting node
parent_index = predecessors(this_C.graph,int2str(index));

if collisionNode(type,this_C.mat(index,:),design,O,tube_rad,L)
    %if in collision, delete node and subtree
    [this_C.graph, this_C.mat] = deleteSubtree(this_C.graph,index,this_C.mat);
else 
    this_C.checked(index) = true;
end

% recur on parent
this_C = collisionCheck(this_C,str2num(parent_index{:}),design,O,type,tube_rad,L);
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
