donnees;
close all;

% Tirages aleatoires pour les 2 droites :
n_tirages = 5000;
[tirages_psi_1,tirages_G_1] = fonctions_TP2_stat('tirages_aleatoires_uniformes',n_tirages,taille);
[tirages_psi_2,tirages_G_2] = fonctions_TP2_stat('tirages_aleatoires_uniformes',n_tirages,taille);

% Estimation des 2 droites par le maximum de vraisemblance :
[a_DYX_1MV,b_DYX_1MV,a_DYX_2MV,b_DYX_2MV] = ...
fonctions_TP2_stat('estimation_Dyx_MV_2droites',x_donnees_bruitees,y_donnees_bruitees,sigma, ...
                                                tirages_G_1,tirages_psi_1,tirages_G_2,tirages_psi_2);

% Calcul de l'ecart angulaire cumule des 2 droites :
theta_DYX_1MV = atan(-1/a_DYX_1MV);
theta_DYX_2MV = atan(-1/a_DYX_2MV);
EA_DYX_1MV_1VT = 180/pi*min(abs((theta_DYX_1MV+[-pi,0,pi]-theta_1)));
EA_DYX_1MV_2VT = 180/pi*min(abs((theta_DYX_1MV+[-pi,0,pi]-theta_2)));
EA_DYX_2MV_1VT = 180/pi*min(abs((theta_DYX_2MV+[-pi,0,pi]-theta_1)));
EA_DYX_2MV_2VT = 180/pi*min(abs((theta_DYX_2MV+[-pi,0,pi]-theta_2)));
EA_cumule_MV = min(EA_DYX_1MV_1VT+EA_DYX_2MV_2VT, EA_DYX_1MV_2VT+EA_DYX_2MV_1VT);
                                                
% Creation de la droite de regression 1 estimee par le maximum de vraisemblance :
if abs(a_DYX_1MV)<1
	x_DYX_1MV = [-taille taille];
	y_DYX_1MV = a_DYX_1MV*x_DYX_1MV+b_DYX_1MV;
else
	y_DYX_1MV = [-taille taille];
	x_DYX_1MV = (y_DYX_1MV-b_DYX_1MV)/a_DYX_1MV;
end

% Creation de la droite de regression 2 estimee par le maximum de vraisemblance :
if abs(a_DYX_2MV)<1
	x_DYX_2MV = [-taille taille];
	y_DYX_2MV = a_DYX_2MV*x_DYX_2MV+b_DYX_2MV;
else
	y_DYX_2MV = [-taille taille];
	x_DYX_2MV = (y_DYX_2MV-b_DYX_2MV)/a_DYX_2MV;
end    

% Affichage des droites : 
figure('Name','Estimations MV','Position',[0.04*L,0.1*H,0.3*L,0.7*H]);
    hold on;
    plot(x_droite_1,y_droite_1,'Color',[1,0,0],'LineWidth',3);
    plot(x_droite_2,y_droite_2,'Color',[0.6 0 0],'LineWidth',3,'HandleVisibility','off');
    plot(x_donnees_bruitees,y_donnees_bruitees,'k+','MarkerSize',7,'LineWidth',1.5);
    plot(x_DYX_1MV,y_DYX_1MV,'Color',[0 0 1],'LineWidth',3);
    plot(x_DYX_2MV,y_DYX_2MV,'Color',[0 0 0.6],'LineWidth',3,'HandleVisibility','off');
    axis(bornes);
    legend(' Droites_{VT} ', ...
           ' Donnees', ...
           ' Droites_{MV}',...
           'Location','northwest');
    axis equal;
    xlim([-taille taille]);
    ylim([-taille taille]);
    set(gca,'FontSize',15);
    hx = xlabel('$x$','FontSize',30);
    set(hx,'Interpreter','Latex');
    hy = ylabel('$y$','FontSize',30);
    set(hy,'Interpreter','Latex');
    grid on;
    title(['Ecart angulaire MV = ' num2str(EA_cumule_MV,'%.2f') ' degres'])
    