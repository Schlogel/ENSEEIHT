clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

load donnees;

% Parametres de l'algorithme RANSAC :
n = length(rho);
S1 = 5;
S2 = 0.3;
k_max = floor(nchoosek(n,2)/n);
parametres = [S1 S2 k_max];

% Estimation du premier point de fuite :
tableau_indices_2points_choisies = fonctions_TP3_stat('choix_indices_points',k_max,n,2);
[rho_F_1,theta_F_1] = fonctions_TP3_stat('RANSAC_2',rho,theta,parametres,tableau_indices_2points_choisies);

% Coordonnees cartesiennes du premier point de fuite :
x_F_1 = rho_F_1*cos(theta_F_1);
y_F_1 = rho_F_1*sin(theta_F_1);

% Droites conformes au premier point de fuite :
conformes_1 = abs(rho-rho_F_1*cos(theta-theta_F_1))<=S1;
rho_conformes_1 = rho(conformes_1);
theta_conformes_1 = theta(conformes_1);

% Droites restantes :
theta = theta(~conformes_1);
rho = rho(~conformes_1);
n_restant = length(rho);

% Estimation du deuxieme point de fuite :
tableau_indices_2points_choisies = fonctions_TP3_stat('choix_indices_points',k_max,n_restant,2);
[rho_F_2,theta_F_2] = fonctions_TP3_stat('RANSAC_2',rho,theta,parametres,tableau_indices_2points_choisies);

% Coordonnees cartesiennes du deuxieme point de fuite :
x_F_2 = rho_F_2*cos(theta_F_2);
y_F_2 = rho_F_2*sin(theta_F_2);

% Droites conformes au deuxieme point de fuite :
conformes_2 = abs(rho-rho_F_2*cos(theta-theta_F_2))<=S1;
rho_conformes_2 = rho(conformes_2);
theta_conformes_2 = theta(conformes_2);


figure('Name','Estimation de la ligne de fuite','Position',[0.2*L,0.05*H,0.6*L,0.7*H]);

% Limites des affichages :
marge = round(min(nb_lignes,nb_colonnes)/10);
x_min = min(1,x_F_1);
x_min = min(x_min,x_F_2)-marge;
x_max = max(nb_colonnes,x_F_1);
x_max = max(x_max,x_F_2)+marge;
y_min = min(1,y_F_1);
y_min = min(y_min,y_F_2)-marge;
y_max = max(nb_lignes,y_F_1);
y_max = max(y_max,y_F_2)+marge;
limites_affichages = [x_min x_max y_min y_max];
axis(limites_affichages);


% Affichage de l'image :
subplot(2,2,1);
imagesc(I);
set(gca,'FontSize',20);
axis image off;
colormap gray;
hold on;
title('Image originale');
axis(limites_affichages);


% Affichage des points de coordonnees (rho,theta) :
subplot(2,2,2);
plot(theta,rho,'k+','MarkerSize',10,'LineWidth',2);
axis([-pi pi -1.2*max(rho_F_1,rho_F_2) 1.2*max(rho_F_1,rho_F_2)]);
set(gca,'FontSize',20);
hx = xlabel('$\theta$','FontSize',30);
set(hx,'Interpreter','Latex');
hy = ylabel('$\rho$','FontSize',30);
set(hy,'Interpreter','Latex');
grid;
hold on;

% Affichage de la sinusoide correspondant au premier point de fuite :
pas = 0.01;
theta_affichage = -pi:pas:pi;
rho_affichage_1 = rho_F_1*cos(theta_affichage-theta_F_1);
plot(theta_affichage,rho_affichage_1,'b-','LineWidth',3);

% Affichage des points conformes a la premiere sinusoide :
plot(theta_conformes_1,rho_conformes_1,'r+','MarkerSize',10,'LineWidth',2);

% Affichage de la deuxieme sinusoide :
rho_affichage_2 = rho_F_2*cos(theta_affichage-theta_F_2);
plot(theta_affichage,rho_affichage_2,'m-','LineWidth',3);

% Affichage des points conformes a la deuxieme sinusoide :
plot(theta_conformes_2,rho_conformes_2,'g+','MarkerSize',10,'LineWidth',2);
title('Paire de sinusoides estimees');


% Affichage de l'image :
subplot(2,2,3);
imagesc(I);
set(gca,'FontSize',20);
axis image off;
colormap gray;
hold on;

% Affichage d'une selection des droites formant le premier faisceau :
taille_selection_1 = min(length(rho_conformes_1),10);
longueurs_segments_au_carre_1 = (extremites(1,1,conformes_1)-extremites(1,2,conformes_1)).^2 ...
				+(extremites(2,1,conformes_1)-extremites(2,2,conformes_1)).^2;
[~,indices_tries_1] = sort(longueurs_segments_au_carre_1,'descend');
selection_1 = indices_tries_1(1:taille_selection_1);
affichage_faisceau(rho_conformes_1(selection_1),theta_conformes_1(selection_1),limites_affichages,'r');

% Affichage du premier point de fuite :
plot(x_F_1,y_F_1,'bx','MarkerSize',20,'LineWidth',5);

% Affichage d'une selection des droites formant le deuxieme faisceau :
taille_selection_2 = min(length(rho_conformes_2),10);
longueurs_segments_au_carre_2 = (extremites(1,1,conformes_2)-extremites(1,2,conformes_2)).^2 ...
				+(extremites(2,1,conformes_2)-extremites(2,2,conformes_2)).^2;
[~,indices_tries_2] = sort(longueurs_segments_au_carre_2,'descend');
selection_2 = indices_tries_2(1:taille_selection_2);
affichage_faisceau(rho_conformes_2(selection_2),theta_conformes_2(selection_2),limites_affichages,'g');

% Affichage du deuxieme point de fuite :
plot(x_F_2,y_F_2,'mx','MarkerSize',20,'LineWidth',5);
title('Paire de points de fuite');


subplot(2,2,4);
% Affichage de l'image :
imagesc(I);
set(gca,'FontSize',20);
axis image off;
colormap gray;
hold on;
axis(limites_affichages);

% Affichage du premier point de fuite :
plot(x_F_1,y_F_1,'bx','MarkerSize',20,'LineWidth',5);

% Affichage du deuxieme point de fuite :
plot(x_F_2,y_F_2,'mx','MarkerSize',20,'LineWidth',5);

% Affichage de la ligne de fuite :
line([x_F_1 x_F_2],[y_F_1 y_F_2],'Color','c','LineWidth',2);
title('Ligne de fuite');

