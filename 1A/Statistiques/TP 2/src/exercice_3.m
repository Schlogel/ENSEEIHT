exercice_2;

% Proportions de depart :
proportion_1 = 0.5;
proportion_2 = 1 - proportion_1;

% Calcul des probablites d'appartenance aux 2 classes : 
[probas_classe_1,probas_classe_2] = ...
fonctions_TP2_stat('probabilites_classe',x_donnees_bruitees,y_donnees_bruitees,sigma,...
                                         a_DYX_1MV,b_DYX_1MV,proportion_1,...
                                         a_DYX_2MV,b_DYX_2MV,proportion_2);

% Classification des donnees :
[x_classe_1,y_classe_1,x_classe_2,y_classe_2] = ...
fonctions_TP2_stat('classification_points',x_donnees_bruitees,y_donnees_bruitees,...
                                           probas_classe_1,probas_classe_2);

% Estimation des 2 droites par les moindres carres pour chaque classe :
[a_DYX_1MC,b_DYX_1MC] = fonctions_TP2_stat('estimation_Dyx_MC',x_classe_1,y_classe_1);
[a_DYX_2MC,b_DYX_2MC] = fonctions_TP2_stat('estimation_Dyx_MC',x_classe_2,y_classe_2);

% Calcul de l'ecart angulaire cumule des 2 droites :
theta_DYX_1MC = atan(-1/a_DYX_1MC);
theta_DYX_2MC = atan(-1/a_DYX_2MC);
EA_DYX_1MC_1VT = 180/pi*min(abs((theta_DYX_1MC+[-pi,0,pi]-theta_1)));
EA_DYX_1MC_2VT = 180/pi*min(abs((theta_DYX_1MC+[-pi,0,pi]-theta_2)));
EA_DYX_2MC_1VT = 180/pi*min(abs((theta_DYX_2MC+[-pi,0,pi]-theta_1)));
EA_DYX_2MC_2VT = 180/pi*min(abs((theta_DYX_2MC+[-pi,0,pi]-theta_2)));
EA_cumule_MC = min(EA_DYX_1MC_1VT+EA_DYX_2MC_2VT, EA_DYX_1MC_2VT+EA_DYX_2MC_1VT);

% Creation de la droite de regression 1 estimee par les moindres carres :
if abs(a_DYX_1MC) < 1
	x_DYX_1MC = [-taille taille];
	y_DYX_1MC = a_DYX_1MC*x_DYX_1MC+b_DYX_1MC;
else
	y_DYX_1MC = [-taille taille];
	x_DYX_1MC = (y_DYX_1MC-b_DYX_1MC)/a_DYX_1MC;
end

% Creation de la droite de regression 2 estimee par les moindres carres :
if abs(a_DYX_2MC) < 1
	x_DYX_2MC = [-taille taille];
	y_DYX_2MC = a_DYX_2MC*x_DYX_2MC+b_DYX_2MC;
else
	y_DYX_2MC = [-taille taille];
	x_DYX_2MC = (y_DYX_2MC-b_DYX_2MC)/a_DYX_2MC;
end 

% Affichage des droites :
figure('Name','Estimations MC','Position',[0.35*L,0.1*H,0.3*L,0.7*H]);
    hold on;
    plot(x_droite_1,y_droite_1,'Color',[1,0,0],'LineWidth',3);
    plot(x_droite_2,y_droite_2,'Color',[0.6 0 0],'LineWidth',3,'HandleVisibility','off');
    plot(x_classe_1,y_classe_1,'Color',[0 1 0],'LineStyle','none','Marker','+','MarkerSize',7,'LineWidth',1.5);
    plot(x_classe_2,y_classe_2,'Color',[0 0.6 0],'LineStyle','none','Marker','+','MarkerSize',7,'LineWidth',1.5,'HandleVisibility','off');
    plot(x_DYX_1MC,y_DYX_1MC,'Color',[0 1 0],'LineWidth',3);
    plot(x_DYX_2MC,y_DYX_2MC,'Color',[0 0.6 0],'LineWidth',3,'HandleVisibility','off');
    axis(bornes);
    legend(' Droites_{VT} ', ...
           ' Classes_{MV}', ...
           ' Droites_{MC}',...
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
    title(['Ecart angulaire MC = ' num2str(EA_cumule_MC,'%.2f') ' degres'])
