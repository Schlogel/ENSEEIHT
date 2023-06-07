clear;
%close all;
clc;

% Parametres d'affichage :
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

load donnees_app;

% Donnees filtrees :
X = X_app_filtre;
Y = Y_app_filtre;

% Donnees non filtrees :
X = X_app;
Y = Y_app;

% Parametres d'affichage :
marge = 0.005;
limites_affichage = [min(min(X(:,1)))-marge max(max(X(:,1)))+marge...
			min(min(X(:,2)))-marge max(max(X(:,2)))+marge];
nom_carac_1 = 'Compacite';
nom_carac_2 = 'Contraste';

% Affichage des donnees :
figure('Name','Representation des images par des points 2D','Position',[0.2*L,0.1*H,0.6*L,0.7*H]);
plot(X(Y==-1,1),X(Y==-1,2),'bx','MarkerSize',10,'LineWidth',3);
hold on;
plot(X(Y==1,1),X(Y==1,2),'ro','MarkerSize',10,'LineWidth',3);
set(gca,'FontSize',20);
xlabel(nom_carac_1,'FontSize',30);
ylabel(nom_carac_2,'FontSize',30);
axis(limites_affichage);
legend('Dermatofibromes','Melanomes','FontSize',20);
