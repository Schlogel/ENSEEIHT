clear;
close all;
clc;

% Parametres pour l'affichage des donnees :
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

load donnees_app;

% Donnees filtrees :
X = X_app_filtre;
Y = Y_app_filtre;

% Parametres d'affichage :
pas = 0.002;
marge = 0.005;
valeurs_carac_1 = min(min(X(:,1)))-marge:pas:max(max(X(:,1)))+marge;
valeurs_carac_2 = min(min(X(:,2)))-marge:pas:max(max(X(:,2)))+marge;
limites_affichage = [valeurs_carac_1(1) valeurs_carac_1(end) ...
                     valeurs_carac_2(1) valeurs_carac_2(end)];
nom_carac_1 = 'Compacite';
nom_carac_2 = 'Contraste';

% Estimation du SVM lineaire (formulation duale) :
[X_VS,w,c,code_retour] = SVM_2(X,Y);

% Si l'optimisation n'a pas converge :
if code_retour ~= 1
	return;
end

% Regle de decision du SVM :
nb_1 = length(valeurs_carac_1);
nb_2 = length(valeurs_carac_2);
SVM_predict = zeros(nb_2,nb_1);
for i = 1:nb_1
	for j = 1:nb_2
		x_ij = [valeurs_carac_1(i) ; valeurs_carac_2(j)];
		SVM_predict(j,i) = sign(w'*x_ij-c);
	end
end

% Affichage des classes predites par le SVM :
figure('Name','Classification par SVM','Position',[0.2*L,0.1*H,0.6*L,0.7*H]);
surface(valeurs_carac_1,valeurs_carac_2,SVM_predict,'EdgeColor','none');
carte_couleurs = [.65 .65 .85 ; .85 .65 .65];
colormap(carte_couleurs);
xlabel(nom_carac_1,'FontSize',30);
ylabel(nom_carac_2,'FontSize',30);
set(gca,'FontSize',20);
axis(limites_affichage);
hold on;
	
% Affichage des points de l'ensemble d'apprentissage :
nb_carac = size(X,2);
ind_moins_1 = (Y == -1);
ind_plus_1 = (Y == 1);
plot3(X(ind_moins_1,1),X(ind_moins_1,2),(nb_carac+1)*ones(sum(ind_moins_1),1),...
	  'bx','MarkerSize',10,'LineWidth',3);
plot3(X(ind_plus_1,1),X(ind_plus_1,2),(nb_carac+1)*ones(sum(ind_plus_1),1),...
	  'ro','MarkerSize',10,'LineWidth',3);

% Les vecteurs de support sont entoures en noir :
plot3(X_VS(:,1),X_VS(:,2),(nb_carac+1)*ones(size(X_VS,1)),'ko','MarkerSize',20,'LineWidth',3);
