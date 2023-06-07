exercice_3;

% Estimation de la droite de regression par resolution du systeme CY = 0 :
[theta_Dorth_2,rho_Dorth_2] = fonctions_TP1_stat('estimation_Dorth_MC',x_donnees_bruitees,y_donnees_bruitees);

% Affichage de la droite de regression estimee par resolution du systeme lineaire CY = 0 :
cos_theta_Dorth_2 = cos(theta_Dorth_2);
sin_theta_Dorth_2 = sin(theta_Dorth_2);
if abs(cos_theta_Dorth_2)<abs(sin_theta_Dorth_2)
	x_Dorth_2 = x_droite;
	y_Dorth_2 = (rho_Dorth_2-x_Dorth_2*cos_theta_Dorth_2)/sin_theta_Dorth_2;
else
	y_Dorth_2 = y_droite;
	x_Dorth_2 = (rho_Dorth_2-y_Dorth_2*sin_theta_Dorth_2)/cos_theta_Dorth_2;
end
plot(x_Dorth_2,y_Dorth_2,'Color',[0 0.8 0],'LineWidth',3);
lg = legend('~Droite', ...
	        '~Donnees bruitees', ...
	        '~$D_\perp$ (maximum de vraisemblance)', ...
	        '~$D_\perp$ (moindres carres)', ...
	        'Location','Best');
set(lg,'Interpreter','Latex');

% Calcul et affichage de l'ecart angulaire :
EA_Dorth_2 = abs((theta_Dorth_2-theta_0)/pi*180);
fprintf('D_perp (moindres carres) : ecart angulaire = %.2f degres\n',EA_Dorth_2);
