donnees;

n_tirages = 100;

% Estimation de la droite de regression par le maximum de vraisemblance :
tirages_theta = fonctions_TP1_stat('tirages_aleatoires_uniformes',n_tirages);
[theta_Dorth_1,rho_Dorth_1] = fonctions_TP1_stat('estimation_Dorth_MV',x_donnees_bruitees,y_donnees_bruitees,tirages_theta);

% Affichage de la droite de regression estimee par le maximum de vraisemblance :
cos_theta_Dorth_1 = cos(theta_Dorth_1);
sin_theta_Dorth_1 = sin(theta_Dorth_1);
if abs(cos_theta_Dorth_1)<abs(sin_theta_Dorth_1)
	x_Dorth_1 = [-taille taille];
	y_Dorth_1 = (rho_Dorth_1-x_Dorth_1*cos_theta_Dorth_1)/sin_theta_Dorth_1;
else
	y_Dorth_1 = [-taille taille];
	x_Dorth_1 = (rho_Dorth_1-y_Dorth_1*sin_theta_Dorth_1)/cos_theta_Dorth_1;
end
plot(x_Dorth_1,y_Dorth_1,'b','LineWidth',3);
axis(bornes);
lg = legend('~Droite', ...
	        '~Donnees bruitees', ...
	        '~$D_\perp$ (maximum de vraisemblance)', ...
	        'Location','Best');
set(lg,'Interpreter','Latex');

% Calcul et affichage de l'ecart angulaire :
EA_Dorth_1 = abs((theta_Dorth_1-theta_0)/pi*180);
fprintf('D_perp (maximum de vraisemblance) : ecart angulaire = %.2f degres\n',EA_Dorth_1);
