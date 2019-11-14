function [collision_bool, goal_bool] = collisionNode(type,c,d,O,goal,tube_rad,L)
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

%
% To start, I can just use a straight cylindrical tube as my bounds. Then
% compare the perpendicular plane to the origin position. I can use the
% tube radius, or even more precisely, can calculate the edge position
% using the orientation of the tube at that point. (Don't spend too much
% time - will implement differently in C++)


goal_bool = false;

% define cylindrical tube size
cylinder_rad = 25;

bend_param = d(1,1:2)';
z_factor = d(1,3);
type = type;


run('variable_driver.m')  % implement varialbe_driver as function??


% use g - position is every fourth column
%myVars = {'nsez','g','L'};
%load('output.mat',myVars{:});
disc_step = round(1+c(1)*(nsez-1)/L);  % number of steps out of nsez
sectionIndices = (nsez-disc_step+1):nsez;

% prepare obstacles
obs_num = length(O.pos(:,1));
min_dist = O.rad + tube_rad;

% find positions based on current configuration
angle = c(2);
section_position = calcKinematic(sectionIndices,g,angle);

% for every position
for i = 1:length(section_position(1,:))
    this_pos = section_position(:,i)';
    
    % ensure inside cylindrical bounds
    planar_dist = norm(this_pos(2:3)); % distance in y-z plane
    if planar_dist > tube_rad + cylinder_rad
        collision_bool = true;
        return
    end
    
    % compare to list of obstacles
    % for every obstacle
    for j = 1:obs_num
        this_obs = O.pos(j,:);
        dist = norm(this_obs - this_pos);
        if dist < min_dist
            collision_bool = true;
            return
        end
    end
    
    if i == length(section_position(1,:))
        dist = norm(goal.pos(:)' - this_pos);
        if dist < goal.rad
            goal_bool = true;
        end
    end
end


collision_bool = false;
end

