function [D,C_map] = newDesign(D,C_map,d_max_step,d_ranges)
%newDesign adds design to D, with max step size away from the nearest
%neighbor of a random sampled design. Updates the configuration map with a
%new struct corresponding to this design with the graph pre-populated with
%the nearest neighbor's graph.
%
%   Input:
%   D          - matrix containing current designs
%   C_map      - map of indices (relating to D) to configuration struct
%   d_max_step - max design step size away from the nearest neighbor
%   d_ranges   - permissible values in the design space
%
%   Output:
%   Updated D and C_map

% choose a random d in the design space 
d_sample = randFromRanges(d_ranges);
[d_near,d_near_index] = neighbor(d_sample,D);
d_new = step(d_near,d_sample,d_max_step);

% Update design array
D = [D;d_new];

% Define new configuration struct with inherited graph - lazy heuristic
C_mat = C_map(d_near_index).mat;  % insertion, rotation
C_graph = C_map(d_near_index).graph;
C_checked = false(1,length(C_mat(:,1))); % no configurations checked for collisions in new design
C_checked(1) = true;
this_C.mat = C_mat;
this_C.graph = C_graph;
this_C.checked = C_checked;

C_map(length(D(:,1))) = this_C;
end

