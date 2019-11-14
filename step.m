function new = step(from,to,max)
%step takes in two vectors of the same size and interpolates between them
%linearly using the max value. If the euclidean distance is less than max,
%the near vector is returned.
%
%       Can be updated with new function for configuration step to allow
%       for wrap-around for rotations (-pi = pi)
%
%   Input:
%   to   - point representing destination (in R^n)
%   from - point representing origin (in R^n)
%   max  - maximum travel distance 
%
%   Output:
%   new  - interpolated point

% find vector from -> to
vec = to - from;

% if vector magnitude > max, multiply unit vector by max
vec_mag = norm(vec);
if vec_mag > max
    vec = vec/vec_mag;
    vec = vec*max;
end

new = vec + from;
end

