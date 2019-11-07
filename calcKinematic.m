function [section_position] = calcKinematic(sectionIndices,this_g,angle)
%calcKinematic calculates the kinematics of the given deformation section
%with a given rotation.
%
%   Input:
%   sectionIndices - indices for consideration in given g deformation
%   this_g         - deformation curve as 4xn matrix of SE(3) frames
%   angle          - angle to rotate curve by
%
%   Output:
%   section_position - subset of this_g specified by sectionIndices,
%   with positions relative to the origin and rotated by angle


positionIndices = sectionIndices*4; % gives only position columns
sectionIndices = positionIndices - 3; %gives first column for each g

% Make all curves perpendicular to insertion point
% Premultiply each g by the inverse first position g
first_g = this_g(1:4,sectionIndices(1):sectionIndices(1)+3);    
first_g_inv = TransInv(first_g);

for j = 1:length(sectionIndices)
    start = j*4 - 3;
    finish = j*4;
    g_current = this_g(1:4,sectionIndices(j):sectionIndices(j)+3);

    g_current = first_g_inv * g_current;

    % Rotate current g by specified angle
    % Define space screw [1 0 0 0 0 0] - rotation in positive x-axis
    screw = [1 0 0 0 0 0]';
    % premultiply current g by e^S*angle
    g_current = MatrixExp6(VecTose3(screw*angle))*g_current;
        
    this_sec_g(1:4,start:finish) = g_current;
end

section_position = this_sec_g(1:3,4:4:length(this_sec_g));
end

