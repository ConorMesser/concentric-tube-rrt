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
discreteNum = S.nsez; % number of discrete sections in curve
length = S.L; % total length of deformation in m
plotIter = 9;
sectionSize = (discreteNum - 1) / plotIter;

% Initialize plot
figure;

% For i iterations of the plot, plot the current position of the curve
for i = plotIter:-1:1
    
    % Split the number of discrete sections into i positions
    sectionIndices = floor((i-1)*sectionSize)+1:discreteNum;
    
    if strcmp(type,'Helix') || strcmp(type,'Sinu')
        angle = -2*pi*(1 - i/plotIter);
    else
        angle = 0;
    end
    
    section_position = calcKinematic(sectionIndices,this_g,angle);

    % Plots this section
    colors = colormap(jet);
    color = colors(ceil(length(colors)*i/plotIter),:);
    plot3(section_position(1,:),section_position(2,:),section_position(3,:),'Color',color)
    hold on;
    grid on;
    axis equal;
end