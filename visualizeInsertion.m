% Computes and displays the trajectory of a spatial curve with 
%  grow-from-the-base kinematics. Takes the curve as an input, stored as a
%  matrix of SE(3) frames, as well as the length of the curve and
%  discretization size between frames. Plots the insertion of this curve 
%  in 3D.
%
% Written by: Conor Messer
% Modified on: 10/13/2019

clear

% Parameters to run variable_driver code
% bend_param = [4 -4]';
% z_factor = 0.8;
% type = 'Helix';
% run('variable_driver.m');
S = load('.\LAST RUN\output.mat');    % Curve can be initialized by something else

% Initialize globals
this_g = S.g;
discreteNum = S.nsez;
plotIter = 9;
sectionSize = (discreteNum - 1) / plotIter;

% Initialize plot
figure;

% For i iterations of the plot, plot the current position of the curve
for i = plotIter:-1:1
    
    % Split the number of discrete sections into i positions
    sectionIndices = floor((i-1)*sectionSize)+1:discreteNum;
%     sectionIndices = sectionIndices*4; % gives only position columns
%     section_position = this_g(1:3,sectionIndices);

    positionIndices = sectionIndices*4; % gives only position columns
    sectionIndices = positionIndices - 3; %gives first column for each g

    % Translates the positions to be in terms of the first position
    %init_position = section_position(1:3);  
    %section_position = section_position - init_position';
    
    % Make all curves perpendicular to insertion point
    % Premultiply each g by the inverse first position g
    first_g = this_g(1:4,sectionIndices(1):sectionIndices(2)-1);    
    first_g_inv = TransInv(first_g);
    
%     this_sec_g = [4,length(sectionIndices)*4];
    
    for j = 1:length(sectionIndices)
        start = j*4 - 3;
        finish = j*4;
        g_current = this_g(1:4,sectionIndices(j):sectionIndices(j)+3);

        g_current = first_g_inv * g_current;
        
        this_first_g = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
        angle = -2*pi*(1 - i/plotIter);

        % If helix/sinu, rotate first g by 2*pi/plotIter radians
%         if strcmp(type,'Helix') || strcmp(type,'Sinu')
%             % Find vector between first and current g in y-z plane
%             y_dist = g_current(2,4) - this_first_g(2,4);
%             z_dist = g_current(3,4) - this_first_g(3,4);
%             % Project onto first y/z axes
%             % Define space screw [1 0 0 0 y z]
%             screw = [1 0 0 0 -z_dist y_dist]';
%             % premultiply current g by e^S*angle
%             g_current = MatrixExp6(VecTose3(screw*angle))*g_current;
%         end
        this_sec_g(1:4,start:finish) = g_current;
    end

    section_position = this_sec_g(1:3,4:4:length(this_sec_g));

    % Plots this section
    colors = colormap(jet);
    color = colors(ceil(length(colors)*i/plotIter),:);
    plot3(section_position(1,:),section_position(2,:),section_position(3,:),'Color',color)
    hold on;
    grid on;
    axis equal;
end