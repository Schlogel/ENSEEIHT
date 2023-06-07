clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

load donnees;

% Estimation du point de fuite :
[rho_F,theta_F] = fonctions_TP3_stat('estimation_F',rho,theta);

% Coordonnees cartesiennes du point de fuite :
x_F = rho_F*cos(theta_F);
y_F = rho_F*sin(theta_F);


figure('Name','Estimation du point de fuite','Position',[0.3*L,0.05*H,0.4*L,0.7*H]);

% Affichage des points de coordonnees (rho,theta) :
subplot(2,1,1);
plot(theta,rho,'k+','MarkerSize',10,'LineWidth',2);
axis([-pi pi -1.2*rho_F 1.2*rho_F]);
set(gca,'FontSize',20);
hx = xlabel('$\theta$','FontSize',30);
set(hx,'Interpreter','Latex');
hy = ylabel('$\rho$','FontSize',30);
set(hy,'Interpreter','Latex');
grid;
hold on;

% Affichage de la sinusoide correspondant au point de fuite :
pas = 0.01;
theta_affichage = -pi:pas:pi;
rho_affichage = rho_F*cos(theta_affichage-theta_F);
plot(theta_affichage,rho_affichage,'b-','LineWidth',3);

% Affichage des points de coordonnees (rho,theta) :
plot(theta,rho,'r+','MarkerSize',10,'LineWidth',2);
title('Sinusoide estimee');

% Affichage de l'image :
subplot(2,1,2);
imagesc(I);
set(gca,'FontSize',20);
axis image off;
colormap gray;
hold on;

% Limites des affichages :
marge = round(min(nb_lignes,nb_colonnes)/10);
x_min = min(1,x_F)-marge;
x_max = max(nb_colonnes,x_F)+marge;
y_min = min(1,y_F)-marge;
y_max = max(nb_lignes,y_F)+marge;
limites_affichages = [x_min x_max y_min y_max];
axis(limites_affichages);

% Affichage d'une selection des droites formant le premier faisceau :
taille_selection = min(length(rho),10);
longueurs_segments_au_carre = (extremites(1,1,:)-extremites(1,2,:)).^2 ...
				+(extremites(2,1,:)-extremites(2,2,:)).^2;
[~,indices_tries] = sort(longueurs_segments_au_carre,'descend');
selection = indices_tries(1:taille_selection);
affichage_faisceau(rho(selection),theta(selection),limites_affichages,'r');

% Affichage du point de fuite :
plot(x_F,y_F,'bx','MarkerSize',20,'LineWidth',5);
title('Point de fuite');
