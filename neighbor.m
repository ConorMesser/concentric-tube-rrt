function [neighbor,n_index] = neighbor(sample,mat)
%neighbor finds the point in the matrix nearest to sample, by euclidean
%distance.
%   
%   Implemented first as an exhaustive search. Could be sped up using a
%   KD-tree, which would give average O(log(m)) time instead of O(m) time.
%   Additional modification may include weighting positive distances, at
%   least for insertion (retraction shouldn't be allowed). Also maybe allow
%   wrap around for rotations.
%   
%   Input:
%   sample - the given point (R^n)
%   mat    - matrix of m points (m x n)
%
%   Output:
%   neighbor  - the point in mat nearest to the sample
%   n_index   - the index of the neighbor in mat

s = length(mat(:,1));
best_dist = 1e5;

for i = 1:s
    this_dist = norm(mat(i,:)-sample);
    
    if this_dist < best_dist
        best_dist = this_dist;
        n_index = i;
    end    
end

neighbor = mat(n_index,:);

