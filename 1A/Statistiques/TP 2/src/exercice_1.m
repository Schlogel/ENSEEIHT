donnees;

% Nombre de tirages aleatoires pour la partie vraisemblance :
n_tirages = 100;

% Estimation de la droite de regression par le maximum de vraisemblance :
tirages_theta = fonctions_TP2_stat('tirages_aleatoires_uniformes',n_tirages,taille);
[a_DYX_1,b_DYX_1] = fonctions_TP2_stat('estimation_Dyx_MV',x_donnees_bruitees,y_donnees_bruitees,tirages_theta);

% Estimation de la droite de regression par les moindres carres :
[a_DYX_2,b_DYX_2] = fonctions_TP2_stat('estimation_Dyx_MC',x_donnees_bruitees,y_donnees_bruitees);

% Creation de la droite estimee par le maximum de vraisemblance :
if abs(a_DYX_1) < 1
	x_DYX_1 = [-taille taille];
	y_DYX_1 = a_DYX_1*x_DYX_1+b_DYX_1;
else
	y_DYX_1 = [-taille taille];
	x_DYX_1 = (y_DYX_1-b_DYX_1)/a_DYX_1;
end

% Creation de la droite estimee par les moindres carres :
if abs(a_DYX_2) < 1
	x_DYX_2 = [-taille taille];
	y_DYX_2 = a_DYX_2*x_DYX_2+b_DYX_2;
else
	y_DYX_2 = [-taille taille];
	x_DYX_2 = (y_DYX_2-b_DYX_2)/a_DYX_2;
end

% Affichage des droites :
plot(x_DYX_1,y_DYX_1,'b','LineWidth',3);
plot(x_DYX_2,y_DYX_2,'Color',[0 0.8 0],'LineWidth',3);
axis(bornes);
legend(' Droites_{VT} ', ...
       ' Donnees', ...
       ' Droite_{MV}', ...
       ' Droite_{MC}', ...
       'Location','Best');
axis equal;
xlim([-taille taille]);
ylim([-taille taille]);
set(gca,'FontSize',15);
hx = xlabel('$x$','FontSize',30);
set(hx,'Interpreter','Latex');
hy = ylabel('$y$','FontSize',30);
set(hy,'Interpreter','Latex');
grid on;
