exercice_3;

figure('Name','Estimations EM','Position',[0.66*L,0.1*H,0.3*L,0.7*H]);

% Initialisation de l'algorithme EM :
seuil = 0.01;
dif_EA_cumule = 1;
a_DYX_1MCP = a_DYX_1MV;
b_DYX_1MCP = b_DYX_1MV;
a_DYX_2MCP = a_DYX_2MV;
b_DYX_2MCP = b_DYX_2MV;
EA_cumule = EA_cumule_MV;
n_iter = 0;
tic

while (abs(dif_EA_cumule) > seuil) && (toc < 5)

    n_iter = n_iter + 1;

    % Iteration de l'algorithme EM
    [probas_classe_1,proportion_1,a_DYX_1MCP,b_DYX_1MCP,probas_classe_2,proportion_2,a_DYX_2MCP,b_DYX_2MCP] = ...
    fonctions_TP2_stat('iteration_estimation_Dyx_EM',x_donnees_bruitees,y_donnees_bruitees,sigma,...
    proportion_1,a_DYX_1MCP,b_DYX_1MCP,proportion_2,a_DYX_2MCP,b_DYX_2MCP);

    % Classification des donnees (simplement pour les couleurs des points lors de l'affichage ici)
	[x_classe_1,y_classe_1,x_classe_2,y_classe_2] = ...
    fonctions_TP2_stat('classification_points',x_donnees_bruitees,y_donnees_bruitees,...
                                               probas_classe_1,probas_classe_2);

    % Calcul de l'ecart angulaire cumule des 2 droites :
    theta_DYX_1MCP = atan(-1/a_DYX_1MCP);
    theta_DYX_2MCP = atan(-1/a_DYX_2MCP);
    EA_DYX_1MCP_1VT = 180/pi*min(abs((theta_DYX_1MCP+[-pi,0,pi]-theta_1)));
    EA_DYX_1MCP_2VT = 180/pi*min(abs((theta_DYX_1MCP+[-pi,0,pi]-theta_2)));
    EA_DYX_2MCP_1VT = 180/pi*min(abs((theta_DYX_2MCP+[-pi,0,pi]-theta_1)));
    EA_DYX_2MCP_2VT = 180/pi*min(abs((theta_DYX_2MCP+[-pi,0,pi]-theta_2)));
    nouveau_EA_cumule = min(EA_DYX_1MCP_1VT+EA_DYX_2MCP_2VT, EA_DYX_1MCP_2VT+EA_DYX_2MCP_1VT);
    dif_EA_cumule = nouveau_EA_cumule - EA_cumule;
    EA_cumule = nouveau_EA_cumule;

    % Affichage de la droite de regression 1 estimee par les moindres carres ponderes :
    if abs(a_DYX_1MCP)<1
	    x_DYX_1MCP = [-taille taille];
	    y_DYX_1MCP = a_DYX_1MCP*x_DYX_1MCP+b_DYX_1MCP;
    else
	    y_DYX_1MCP = [-taille taille];
	    x_DYX_1MCP = (y_DYX_1MCP-b_DYX_1MCP)/a_DYX_1MCP;
    end
    
    % Affichage de la droite de regression 2 estimee par les moindres carres ponderes :
    if abs(a_DYX_2MCP)<1
	    x_DYX_2MCP = [-taille taille];
	    y_DYX_2MCP = a_DYX_2MCP*x_DYX_2MCP+b_DYX_2MCP;
    else
	    y_DYX_2MCP = [-taille taille];
	    x_DYX_2MCP = (y_DYX_2MCP-b_DYX_2MCP)/a_DYX_2MCP;
    end
  
    % Affichage des droites :
    figure(3)
	hold off;
    plot(x_droite_1,y_droite_1,'Color',[1,0,0],'LineWidth',3);
    hold on;
    plot(x_droite_2,y_droite_2,'Color',[0.6 0 0],'LineWidth',3,'HandleVisibility','off');
	plot(x_classe_1,y_classe_1,'Color',[1 0.8 0],'LineStyle','none','Marker','+','MarkerSize',7,'LineWidth',1.5);
    plot(x_classe_2,y_classe_2,'Color',[1 0.5 0],'LineStyle','none','Marker','+','MarkerSize',7,'LineWidth',1.5,'HandleVisibility','off');
    plot(x_DYX_1MCP,y_DYX_1MCP,'Color',[1 0.8 0],'LineWidth',3);
    plot(x_DYX_2MCP,y_DYX_2MCP,'Color',[1 0.5 0],'LineWidth',3,'HandleVisibility','off');
    axis(bornes);
    legend(' Droites_{VT} ', ...
           ' Classes_{EM}', ...
           ' Droites_{EM}',...
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
    title({['Iteration ' num2str(n_iter) ' :'] ['Ecart angulaire EM = ' num2str(EA_cumule,'%.2f') ' degres']})
    drawnow;

    pause(0.5);

end

