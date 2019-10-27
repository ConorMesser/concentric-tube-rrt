function this_C = collisionCheck(this_C,index,design,O)
%collisionCheck recurs over tree, starting at node specified by index,
%checking for collisions at each node. If there is a collision, the subtree
%from that node is deleted from the graph. Recursion stops when either a
%node has already been checked or the base node is reached.
%   
%   Input:
%   this_C - configuration struct for the current design
%   index  - index (in graph and row of matrix) of the node to be checked
%
%   Output:
%   this_C - updates the configuration struct

% if index is base or it has already been checked
if index == 1 || this_C.is_checked(index) == true
    return  %make sure variable has been properly updated
elseif collisionNode(this_C.mat(index,:),design,O)
    %if in collision, delete node and subtree
    this_C = deleteSubtree(this_C,index);
    % recur on parent??
end 
 %else recur on parent
    this_C.is_checked(index) = true;
    parent_index = predecessors(this_C.graph,index); %what is format of predecessors output?
    this_C = collisionCheck(this_C,parent_index,design);


end



function this_C = deleteSubtree(this_C,index)
    % Delete node at this index and all its children
    % Only needs to be updated in the graph, not the matrix
    new_graph = deleteNode(this_C.graph,index);
    
    % Refactor this_C
    this_C.graph = new_graph;
end

function new_graph = deleteNode(graph,index)
    if outdegree(G,int2str(index)) == 0
        new_graph = rmnode(graph,int2str(index));
    else
        child = successors(graph,int2str(index));
        interm_g = rmnode(graph,int2str(index));
        new_graph = deleteNode(interm_g,int2str(child));
    end
end
