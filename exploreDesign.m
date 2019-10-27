function C_map = exploreDesign(d,d_ind,C_map,c_max_step,c_ranges,O)
%exploreDesign adds node to configuration graph corresponding to this
%design d, with max step size away from the nearest neighbor of a random 
%sampled configuration. Updates the configuration map with an edge from the
%nearest neighbor to the new node. Checks all nodes in the path from the
%new configuration to the base for collisions. Deletes the subtree of any
%node in collision.
%
%   Input:
%   d          - current design
%   C_map      - map of indices (relating to D) to configuration struct
%   c_max_step - max design step size away from the nearest neighbor
%   c_ranges   - permissible values in the design space
%   O          - obstacles represented as ****
%
%   Output:
%   Updated C_map

% for each vertex q from q0 to qnew
%   if ~is_checked(d,q)
%     if is_collision(d,q,O)
%       delete subtree rooted at q
%     else
%       is_checked(d,q) = true

% choose a random d in the configuration space 
c_sample = randFromRange(c_ranges);
[c_near,c_near_index] = neighbor(c_sample,C_map(d_ind).mat);
c_new = step(c_near,c_sample,c_max_step);

% Add new node to configuration graph of this design
this_C = C_map(d_ind);
this_C.mat = [this_C.mat; c_new];
c_new_index = length(this_C.mat(:,1));
this_C.graph = addnode(this_C.graph,{int2str(c_near_index),int2str(c_new_index)}); %nodes have string names so they are notrenamed when a node is deleted
this_C.checked = [this_C.checked false];

this_C = collisionCheck(this_C,c_new_index,d,O);

C_map(d_ind) = this_C;
end

