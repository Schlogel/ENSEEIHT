exercice_1;

% Estimation de la droite de regression par resolution du systeme AX = B :
[a_DYX_2,b_DYX_2] = fonctions_TP1_stat('estimation_Dyx_MC',x_donnees_bruitees,y_donnees_bruitees);

% Affichage de la droite de regression estimee par resolution du systeme AX = B :
if abs(a_DYX_2)<1
	x_DYX_2 = [-taille taille];
	y_DYX_2 = a_DYX_2*x_DYX_2+b_DYX_2;
else
	y_DYX_2 = [-taille taille];
	x_DYX_2 = (y_DYX_2-b_DYX_2)/a_DYX_2;
end
plot(x_DYX_2,y_DYX_2,'Color',[0 0.8 0],'LineWidth',3);
lg = legend('~Droite', ...
	        '~Donnees bruitees', ...
	        '~$D_{YX}$ (maximum de vraisemblance)', ...
	        '~$D_{YX}$ (moindres carres)', ...
	        'Location','Best');
set(lg,'Interpreter','Latex');

% Calcul et affichage de l'ecart angulaire :
theta_DYX_2 = atan(-1/a_DYX_2);
EA_DYX_2 = abs((theta_DYX_2-theta_0)/pi*180);
fprintf('D_YX (moindres carres) : ecart angulaire = %.2f degres\n',EA_DYX_2);
