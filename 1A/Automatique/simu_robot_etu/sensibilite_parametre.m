% Remarque : On ne fait pas de sous programme car Simulink utilise
% l'environnement Matlab
%
clear all; close all;
%addpath('../../','./Ressources');

addpath('./Ressources');
% Pour une figure avec onglet
set(0,  'defaultaxesfontsize'   ,  12     , ...
   'DefaultTextVerticalAlignment'  , 'bottom', ...
   'DefaultTextHorizontalAlignment', 'left'  , ...
   'DefaultTextFontSize'           ,  12     , ...
   'DefaultFigureWindowStyle','docked');
%
% Initialisations
% ---------------
t0 = 0;             % temps initial
xe = [0 0 0 0]';    % (x_e, u_e) point de fonctionnement
ue = 0;             %

% Test
fich_simulink_etu = './robot_echant_etu';

x0 = [0 pi/10 0 0]'; % initial point
tf = 2;             % temps final
delta_t = 0.1;      % 0.1 prcq
algorithme = 'ode45';
RelTol = '1e-3';
K = [0.6700, 19.9053, 1.0747, 1.9614];         % calcul de K avec les vp


% Sensibilité aux paramètres
% -----

options_sim = simset('Solver',algorithme,'RelTol',RelTol);
x_ini = [0 0 0 0]';
v_x = [pi/10, pi/2, pi/5, pi, 2*pi];

figure;
figure('Name',' Sol')

for i = 1:1
    %x0 = x_ini + [0 v_x(i) 0 0]';
    affichage(t0, xe, ue, x0, tf, K, options_sim);x0(4)
    simOut = sim(fich_simulink_etu,[t0 tf],options_sim);
    
    graphiques(simOut.X,simOut.U,i)
end


% Fonctions
function affichage(t0, xe, ue, x0, tf, K, options_sim)
% 
% Attichage des données
    disp('[t0 xe ue]')
    disp([t0 xe(:)' ue(:)'])
    disp('[x0 tf K]=')
    disp([x0(:)' tf K])
    disp(['algorithme = ' options_sim.Solver]);
    disp(['RelTol = ' options_sim.RelTol]);
    disp(['pas = ' num2str(options_sim.FixedStep)]);
end

function graphiques(x,u,i)
    % delta_t =           % si nécessaire 
    % Réalise les graphiques des simulations issues de simulink
    %
    % parametres en entrée
    % --------------------
    % t : temps
    %     real (N,1)
    % x : état
    %     real (N,n)
    % u : contrôle
    %     real (N,m)
    
    subplot(2,i,1)
    plot(x.Time,x.Data)
    xlabel('t')
    ylabel('états');
    subplot(2,i,2)
    plot(u.Time,u.Data)
    xlabel('t')
    ylabel('contrôle')

end