donnees;

n_tirages = 100;

% Estimation de la droite de regression par le maximum de vraisemblance :
tirages_psi = fonctions_TP1_stat('tirages_aleatoires_uniformes',n_tirages);
[a_DYX_1,b_DYX_1] = fonctions_TP1_stat('estimation_Dyx_MV',x_donnees_bruitees,y_donnees_bruitees,tirages_psi);

% Affichage de la droite de regression estimee par le maximum de vraisemblance :
if abs(a_DYX_1)<1
	x_DYX_1 = [-taille taille];
	y_DYX_1 = a_DYX_1*x_DYX_1+b_DYX_1;
else
	y_DYX_1 = [-taille taille];
	x_DYX_1 = (y_DYX_1-b_DYX_1)/a_DYX_1;
end
plot(x_DYX_1,y_DYX_1,'b','LineWidth',3);
axis(bornes);
lg = legend('~Droite', ...
	        '~Donnees bruitees', ...
	        '~$D_{YX}$ (maximum de vraisemblance)', ...
	        'Location','Best');
set(lg,'Interpreter','Latex');

% Calcul et affichage de l'ecart angulaire :
theta_DYX_1 = atan(-1/a_DYX_1);
EA_DYX_1 = abs((theta_DYX_1-theta_0)/pi*180);
fprintf('D_YX (maximum de vraisemblance) : ecart angulaire = %.2f degres\n',EA_DYX_1);
