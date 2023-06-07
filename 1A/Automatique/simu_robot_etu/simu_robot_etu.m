% ~gergaud/ENS/Automatique/TP19-20/TP_Etudiants/simu_robot/simu_rotot_etu.m
%
%
% Auteur : Gergaud Joseph
% Date : october 2019
% Institution : Université de Toulouse, INP-ENSEEIHT
%               Département Sciences du Numérique
%               Informatique, Mathématiques appliquées, Réseaux et Télécommunications
%               Computer Science department
%
%-----------------------------------------------------------------------------------------
%
% Code Matlab de test pour la simulation du pendule inversé contrôlé. 
%
%-----------------------------------------------------------------------------------------


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

% Cas 1
% -----

fich_simulink_etu = './robot_etu'

%% Cas 1.1   modèle simple

fich = 'cas1_1';
x0 = [0 0 0 0]';
tf = 2;             % temps final
K = [0 0 0 0];
algorithme = 'ode45';
RelTol = '1e-3';

simu_robot          % dim:ok; res:ok


%% Cas 1.2   modèle pendule inv K

fich = 'cas1_2';

tf = 2;             % temps final

x0 = [0 pi/10 0 0]'; % initial point
K = [0.6700, 19.9055, 1.0747, 1.9614];         % calcul de K avec les vp
algorithme = 'ode45';
RelTol = '1e-3';

simu_robot          % dim:ok; res:ok


%% cas 1.3 modèle echant

fich = 'cas1_3';

delta_t = 0.1;
tf = 2;
options_sim = simset('Solver',algorithme,'RelTol',RelTol);

% % à décommenter pour lancer
% % affichages
% disp(fich)
% disp('[t0 xe ue]')
% disp([t0 xe(:)' ue(:)'])
% disp('[x0 tf K]=')
% disp([x0(:)' tf K])
% disp(['algorithme = ' algorithme]);
% disp(['RelTol = ' RelTol]);
% disp('pas = ');
% 
% % lancement des simulations
% for i = 1:4
%     delta_t = i/1000;
%     simOut_echant = sim("robot_echant_etu.slx",[t0 tf],options_sim);
%     graphiques(simOut_echant.X,simOut_echant.U,i)
%     disp(['figure(' num2str(i) '):' ' delta_t = ' num2str(delta_t)]);
% end
% 
% % fonction pour les graphiques
% function graphiques(x,u,i)
%     % Réalise les graphiques des simulations issues de simulink
%     % 
%     % parametres en entrée
%     % --------------------
%     % t : temps
%     %     real (N,1)
%     % x : état
%     %     real (N,n)
%     % u : contrôle
%     % real (N,m)
%     figure(10+i)
%     subplot(2,1,1)
%     plot(x.Time,x.Data)
%     xlabel('t')
%     ylabel('états');
%     subplot(2,1,2)
%     plot(u.Time,u.Data)
%     xlabel('t')
%     ylabel('contrôle')
% end