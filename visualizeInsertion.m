% Computes and displays the trajectory of a spatial curve with 
%  grow-from-the-base kinematics. Takes the curve as an input, stored as a
%  matrix of SE(3) frames, as well as the length of the curve and
%  discretization size between frames. Plots the insertion of this curve 
%  in 3D. 
%
%   Can be called by another script with this_g, section start indices, and
%   angle vector defined.
%
% Written by: Conor Messer
% Modified on: 10/13/2019

%clear

if ~exist('this_g','var')
    % Parameters to run variable_driver code
    bend_param = [2 -1]';
    z_factor = 0;
    type = 'Helix';
    run('variable_driver.m');
    %S = load('.\LAST RUN\output.mat');    % Curve can be initialized by something else

    % Initialize globals
    this_g = g;
    discreteNum = nsez; % number of discrete sections in curve
    lng = L; % total length of deformation in m
    plotIter = 9;
    sectionSize = (discreteNum - 1) / plotIter;
    sectionStartInd = zeros(plotIter);
    angles = zeros(plotIter);

    for j = plotIter:-1:1
        sectionStartInd(j) = floor((j-1)*sectionSize)+1;

        if strcmp(type,'Helix') || strcmp(type,'Sinu')
            this_angle = -2*pi*(1 - j/plotIter);
        else
            this_angle = 0;
        end

        angles(j) = this_angle;
    end
end

% Initialize plot
figure;

num = length(sectionStartInd);
% For i iterations of the plot, plot the current position of the curve
for i = 1:num
    
    % Split the number of discrete sections into i positions
    sectionIndices = sectionStartInd(i):discreteNum;
    
    section_position = calcKinematic(sectionIndices,this_g,angles(i));

    % Plots this section
    colors = colormap(jet);
    color = colors(ceil(length(colors)*i/num),:);
    plot3(section_position(1,:),section_position(2,:),section_position(3,:),'Color',color)
    hold on;
    grid on;
    axis equal;
end