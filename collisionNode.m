function boolean = collisionNode(type,c,d,O,tube_rad,length)
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

% define cylindrical tube size
cylinder_rad = 20;

bend_param = d(1,1:2);
z_factor = d(1,3);
type = type;
L = length;

run('variable_driver.m')

% use g - position is every fourth column
load('\Renda_NonLinearCurves\LAST RUN\output.mat',{'nsez','g','L'});
disc_step = ceil(c(1)*nsez/length);
sectionIndices = (nsez-disc_step):nsez;

% prepare obstacles
obs_num = length(O.pos(1,:));
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
        boolean = true;
        return
    end
    
    % compare to list of obstacles
    % for every obstacle
    for j = 1:obs_num
        this_obs = O.pos(j,:);
        dist = norm(this_obs - this_pos);
        if dist < min_dist
            boolean = true;
            return
            % delete sub tree???
        end
    end
end

boolean = false;
end

