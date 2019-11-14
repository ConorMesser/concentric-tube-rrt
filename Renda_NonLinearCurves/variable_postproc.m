function variable_postproc(xci)
global gv

% global variable
L       =gv.L;
R       =gv.R;
X       =gv.X;
nsez    =gv.nsez;
g       =gv.g;

%-------------------------------------------------------------------------
% pre-processing
%cd 'C:\Users\Conor\Documents\MATLAB\Fulbright Research\Renda_NonLinearCurves';
currentFolder = pwd;
if ~contains(currentFolder,'Renda_NonLinearCurves')
    cd .\Renda_NonLinearCurves
end
%mkdir('.\LAST RUN\');

%-------------------------------------------------------------------------
% save results

save('.\LAST RUN\output','g','nsez','L')

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
% plots

%deformations

figure
plot(X,xci(2,:))
grid on
title('curvature on y')
xlabel('X [m]')
ylabel('k_y [1/m]')
auxstr  ='.\LAST RUN\curvature_on_y.png';
print('-dpng',auxstr)

figure
plot(X,xci(3,:))
grid on
title('curvature on z')
xlabel('X [m]')
ylabel('k_z [1/m]')
auxstr  ='.\LAST RUN\curvature_on_z.png';
print('-dpng',auxstr)

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
% Conigurazione

figure

% figure invariants
ang               =linspace(0,2*pi,180);
 
% set the graph options
set(gca,'CameraPosition',[0 -3*L 0],...
    'CameraTarget',[0 0 0],...
    'CameraUpVector',[0 0 1])
axis equal
grid on
hold on
xlabel('E1 [m]')
ylabel('E2 [m]')
zlabel('E3 [m]')       

% disegno la sezione
sez     =[zeros(1,180) 0;R*sin(ang) 0;R*cos(ang) 0;ones(1,180) 1];

for ii=1:nsez
    sez_qui  =g(:,4*(ii-1)+1:4*(ii-1)+4)*sez;
    plot3(sez_qui(1,:),sez_qui(2,:),sez_qui(3,:),'Color','r')
end

% force drawing
drawnow
auxstr  ='.\LAST RUN\configuration.png';
print('-dpng',auxstr)

% eof