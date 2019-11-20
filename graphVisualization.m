function [] = graphVisualization(this_C,d,type,O,goal,cylinder_rad,start_ind,L,nsez,rot_max)
% Allows visualization of a sequence of tube configurations with certain
% obstacles. Sequence given as a graph with the index name to start with.
% Curves will be plotted starting at that index and iterating over the
% parents until the root node.
%
%   Input:
%   this_C       - Configuration struct with config mat, graph, and checked
%   d            - design parameters
%   type         - deformation base type
%   O            - Obstacles struct with center points and sphere radius
%   cylinder_rad - radius of bounding cylinder, along x-axis
%   start_ind    - index of the graph to begin with
%   L            - Length of tube in mm
%   nsez         - number of discrete sections for curve deformation
%
%   Output:
%

%traverse graph from start_ind to root
c_indices = start_ind;
i = 1;
while c_indices(end) ~= 1
    new_ind = predecessors(this_C.graph,int2str(c_indices(i)));
    c_indices = [c_indices str2num(new_ind{1,1})];
    i = i+1;
end

%prepare section start indices and angles vector
sectionStartInd = zeros(1,length(c_indices));
angles = zeros(1,length(c_indices));

for j = 1:length(c_indices)
    insert_val = this_C.mat(c_indices(j),1); % check order TODO
    disc_step = round(1+insert_val*(nsez-1)/L);  % number of steps out of nsez
    sectionStartInd(j) = nsez-disc_step+1;
    angles(j) = this_C.mat(c_indices(j),2)*2*pi/rot_max - pi; % maps to [-pi pi]
end

%compute deformation curve using d and type
bend_param = d(1:2)';
z_factor = d(3);
type = type;
run('variable_driver.m');

%call visualizeInsertion
this_g = g;
discreteNum = nsez;
run('visualizeInsertion.m');

% plot cylinder boundary
hold on
circleYZ(0,0,0,cylinder_rad)

%plot obstacles on graph
[x_s,y_s,z_s] = sphere;
for o = 1:length(O.pos(:,1))
    hold on
    x_o = O.pos(o,1);
    y_o = O.pos(o,2);
    z_o = O.pos(o,3);
    surf(x_s*O.rad+x_o,y_s*O.rad+y_o,z_s*O.rad+z_o,'FaceColor','red')
end

%plot goal on graph
hold on
x_g = goal.pos(1,1);
y_g = goal.pos(1,2);
z_g = goal.pos(1,3);
surf(x_s*goal.rad+x_g,y_s*goal.rad+y_g,z_s*goal.rad+z_g,'FaceColor','blue')
end

function h = circleYZ(x,y,z,r)
hold on
th = 0:pi/50:2*pi;
zunit = r * cos(th) + z;
yunit = r * sin(th) + y;
xunit = zeros(1,length(th)) + x;
h = plot3(xunit,yunit,zunit);
hold off
end
