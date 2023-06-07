clear;
close all;
clc

taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

% Fenetre d'affichage :
figure('Name','Points situes au voisinage d''une droite', ...
	'Position',[0.3*L,0.1*H,0.4*L,0.7*H]);
axis equal;
hold on;
set(gca,'FontSize',20);
hx = xlabel('$x$','FontSize',30);
set(hx,'Interpreter','Latex');
hy = ylabel('$y$','FontSize',30);
set(hy,'Interpreter','Latex');

% Bornes d'affichage des donnees centrees en (0,0) :
taille = 20;
bornes = [-taille taille -taille taille];

% Creation de la droite et des donnees bruitees : 
n = 100;
sigma = 2;
[x_droite,y_droite,x_donnees_bruitees,y_donnees_bruitees, theta_0, rho_0] ...
			         = creation_droite_et_donnees_bruitees(taille,n,sigma);

% Affichage de la droite :
plot(x_droite,y_droite,'r-','LineWidth',3);

% Affichage des donnees bruitees :
plot(x_donnees_bruitees,y_donnees_bruitees,'k+','MarkerSize',10,'LineWidth',2);
axis(bornes);
lg = legend(' Droite', ...
	' Donnees bruitees', ...
	'Location','Best');
grid on;
