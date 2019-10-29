function boolean = collisionNode(config,design,O)
%collisionNode calculates the trajectory of the tube based on the given
%configuration and design and checks for collisions with any of the
%obstacles.
%   
%   Input:
%   config  - vector specifying configuration values
%   design  - vector specifying design values
%   O       - obstacles represented as spheres with centers defined in
%               cartesian space in .centers and constant radius in .rad
%
%   Output:
%   boolean - true if there is a collision

% Calculate tube strain using NonLinearCurves - save q

% For every step (define size)
% Check the distance between tube backbone and list of obstacle centers
% If distance is less than sphere rad + tube rad, there is collision

% Must define tube rad in main
%   Maybe add a little to this tube rad, based on step size (there should
%   be no false negatives
% How to speed up?
end

