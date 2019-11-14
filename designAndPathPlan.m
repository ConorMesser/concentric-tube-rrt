% designAndPathPlan.m
%
% Main script to run the algorithm for finding optimal design and path plan
% for a non-constant curvature concentric tube. Takes a number of
% iterations, design vs. configuration space exploration weight, maximum
% step size for design and config space, and max number of iterations.
% Outputs the configuration for the best design and the path plan.
%
% Written by: Conor Messer
% Last Modified: 10/21/2019

HOME_DIR = pwd;

% User-specified maximum size steps for Design and Configuration spaces
d_max_step = 1;
c_max_step = 3;
n = 10000;
p_explore = 0.005;

tube_rad = 0.9; % in mm
obstacles.rad = 5;  % in mm
obstacles.pos = [110 0 20; 80 25 0; 55 20 20; 90 -15 0];

goal.rad = 5;
goal.pos = [120 -2 20];

% User-specified ranges to define Design and Config spaces
init_range = [0 3];  %[0 5]
delta_range = [-6 3];  %[-10 10]
factor_range = [-2 2];  %[-3 3]
insertion_range = [0 200];  % given in mm
rotation_range = [0 60]; % allows for scaling of nearest neighbor calls
                           %  must be mapped to -pi to pi

% Package range values for Design and Config space
design_ranges = [init_range;delta_range;factor_range];
config_ranges = [insertion_range;rotation_range];

% Defines base type names (linear, quadratic, sinusoidal, helix)
base_names = ["Helix","Sinu","Linear","Quad"];

for b = 1:4
    base = base_names(b);
    
    % Choose a random d in design space of this base
    % d includes bending coefficient, rate of change, and z factor
    % The d is the same for each, but for sinu, rate of change isn't used
    d_rand = randFromRanges(design_ranges);

    % Insert d into Design graph
    % **** Just stored as array for now - could speed up using kd-tree***
    D = d_rand;
    % Initialize configuration graph with initial config (0 insertion, 0 rotation)
    C_map = containers.Map('KeyType','uint32','ValueType','any');
    C_mat = [0 0];  % stores the configuration (insertion, rotation) w/ index referenced in graph
    C_graph = digraph;  %use tree implementation? http://tinevez.github.io/matlab-tree/
    C_checked = true;
    C_goal = false;
    C_goal_i = false;
    C_weight = 1;
    this_C.mat = C_mat;
    this_C.graph = C_graph;
    this_C.checked = C_checked;
    this_C.goal_ind = C_goal_i;
    this_C.goal = C_goal;
    this_C.weight = C_weight;
    C_map(1) = this_C;

    for i = 1:n
        disp(i)
        
        if rand < p_explore
            [D,C_map] = newDesign(D,C_map,d_max_step,design_ranges); % adds random design and associated entry to map
        else
            D_ind = randi(length(D(:,1)));
            
            while rand > C_map(D_ind).weight  % favors designs with fewer collisions
                D_ind = randi(length(D(:,1)));
            end
            C_map = exploreDesign(D(D_ind,:),D_ind,C_map,c_max_step,config_ranges,obstacles,goal,base,tube_rad,insertion_range(2)); % adds node to one graph in C_map
            % should there be a boolean on designs to see if there is a
            % valid solution yet?
        end
    end

    % Find best configuration for this base
    % Search through all designs, collect ones that have a solution
    % Compare the cost for the solutions of those designs, choose best
    
    D_success = [];
    for  s = 1:length(D(:,1))
        if C_map(s).goal
            D_success = [D_success s];
        end
    end
    
    workspace_filename = strcat(base,"8");
    cd(HOME_DIR)
    cd .\Tests
    save(workspace_filename);
    cd(HOME_DIR)
    
    
    overall_success.(base{1}) = D_success;
    
end

% Find best configuration out of all bases

% Output configuration and path plan