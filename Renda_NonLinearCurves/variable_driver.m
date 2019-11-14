%close all
format long
clc

global gv

tic

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%disp('Pre-processing')

%-------------------------------------------------------------------------
% beginning of input section

% Geometrical input del braccio siliconico
R        =0.9;                         % [mm]
if (~exist('L','var'))
    L        =200;                        % [mm] Lunghezza del braccio
end
if (~exist('nsez','var'))
    nsez        =200;                        % [mm] Lunghezza del braccio
end
%nsez     =floor(L*2e2+1);                % una sezione per mezzo centimetro floor(L*2e2+1)
X        =linspace(0,L,nsez);            % [m] curvilinear abscissa
dX       =L/(nsez-1);                    % delta X
xci_bias =[0 0 0 1 0 0]';                % bias screw ([w v])

% User input parameters
if (~exist('bend_param','var'))
    bend_param  =[2 5.4]';                % 1) controls initial/constant bending in y, 2) controls the change from beginning to end of tube
end
if (~exist('z_factor','var'))
    z_factor    =-.5;                     % Controls the z-bending in relation to the y (multiplied by param(2) to give the z bending)
end  
if (~exist('type','var'))
    type        ='Linear';               %'Linear','Quad','Helix','Sinu'
end
                       
% Normalize bending parameters to the tube length
bend_param = [1/L 0; 0 1/L^2]*bend_param;

% global variable
gv.L     =L;
gv.X     =X;
gv.R     =R;
gv.nsez  =nsez;
gv.dX    =dX;

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
% solution initialization 
% sol=g

%disp('Time-advancing')

g        =zeros(4,4*nsez);
xci      =zeros(6,nsez);
C1       =1/2-sqrt(3)/6;                 % Gauss quadrature coefficient
C2       =1/2+sqrt(3)/6;                 % Gauss quadrature coefficient

%-------------------------------------------------------------------------
% condizioni iniziali spaziali

if isequal(type,'Linear')
    y           =[1 0; 0 1; 0 0; 0 0; 0 0; 0 0; 0 0];
    z           =[0 0; 0 z_factor; 0 0; 0 0; 0 0; 0 0; 0 0]; % *** Should I have 0 or 1 (or something else) for constant z???
elseif isequal(type,'Quad') 
    y           =[1 0; 0 0; 0 1; 0 0; 0 0; 0 0; 0 0];
    z           =[0 0; 0 0; 0 z_factor; 0 0; 0 0; 0 0; 0 0];
    
    bend_param = [1 0; 0 1/L]*bend_param;  % compensate for quadratic on the changing value
elseif isequal(type,'Helix')  % allows for simple helix or changing amplitude helix (if param(2)!=0, amplitude changes)
    y           =[0 0; 0 0; 0 0; 1 0; 0 0; 0 1; 0 0];
    z           =[0 0; 0 0; 0 0; 0 0; z_factor 0; 0 0; 0 1];
elseif isequal(type,'Sinu') % phase shift between y and z, controlled by z_factor
    y           =[0 0; 0 0; 0 0; z_factor 0; 1 0; 0 0; 0 0];  % constant amplitude (no param(2) weight)
    z           =[0 0; 0 0; 0 0; 1 0; z_factor 0; 0 0; 0 0];
end

g_prec      =eye(4);
options     =[1 X(1) X(1)^2 sin(X(1)) cos(X(1)) sin(X(1))*X(1) cos(X(1))*X(1)];
Bq_o        =[0 0;options*y;options*z;0 0;0 0;0 0];
xci_o       =Bq_o*bend_param+xci_bias;
g(:,1:4)    =g_prec;
xci(:,1)    =xci_o;
            
options_iter  = @(delta) [1 delta delta^2 sin((2*pi*delta)/L) cos((2*pi*delta)/L) sin((2*pi*delta)/L)*delta cos((2*pi*delta)/L)*delta];
% integrate
for ii=2:nsez
    
    Bq_here       =[0 0;options_iter(X(ii))*y;options_iter(X(ii))*z;0 0;0 0;0 0]; 
    Bq_here1      =[0 0;options_iter(X(ii-1)+C1*dX)*y;options_iter(X(ii-1)+C1*dX)*z;0 0;0 0;0 0]; 
    Bq_here2      =[0 0;options_iter(X(ii-1)+C2*dX)*y;options_iter(X(ii-1)+C2*dX)*z;0 0;0 0;0 0]; 
    xci_here      =Bq_here*bend_param+xci_bias;
    xci_here1     =Bq_here1*bend_param+xci_bias;
    xci_here2     =Bq_here2*bend_param+xci_bias;
    xcihat_here1  =dinamico_hat(xci_here1);
    xcihat_here2  =dinamico_hat(xci_here2);
    Gammahat_here =(dX/2)*(xcihat_here1+xcihat_here2)+...
                  ((sqrt(3)*dX^2)/12)*(xcihat_here2*xcihat_here1-xcihat_here1*xcihat_here2);
    k_here        =[-Gammahat_here(2,3) Gammahat_here(1,3) -Gammahat_here(1,2)]';
    theta_here    =norm(k_here);
    gn_here       =variable_expmap(theta_here,Gammahat_here);
    g_here        =g_prec*gn_here;
    g_prec        =g_here;
    g(:,4*(ii-1)+1:4*(ii-1)+4)...
                  =g_prec;
    xci(:,ii)     =xci_here;
end

gv.g     =g;

%toc
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
% postproc

%disp('Post-processing')

%variable_postproc(xci)   % saving last run data and plotting not needed

%toc

% end