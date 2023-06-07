donnees_aberrantes;

n_tests = 500;

% Parametres de l'algorithme RANSAC :
n = length(x_donnees_bruitees);
S1 = 2;
S2 = 0.5;
k_max = floor(nchoosek(n,3)/n);
parametres = [S1 S2 k_max n_tests];

% Estimation du rayon et de la position du centre :
tableau_indices_3points_choisis = fonctions_TP3_stat('choix_indices_points',k_max,n,3);
[C_estime,R_estime] = fonctions_TP3_stat('RANSAC_3',x_donnees_bruitees,y_donnees_bruitees,...
                                                    parametres,tableau_indices_3points_choisis);

% Affichage du cercle estime :
x_cercle_estime = C_estime(1) + R_estime*cos(theta_cercle);
y_cercle_estime = C_estime(2) + R_estime*sin(theta_cercle);
plot(x_cercle_estime([1:end 1]),y_cercle_estime([1:end 1]),'b','LineWidth',3);

% Affichage des points conformes au modele :
conformes = (abs(sqrt((x_donnees_bruitees-C_estime(1)).^2 + ...
			 (y_donnees_bruitees-C_estime(2)).^2)-R_estime)<=S1);
plot(x_donnees_bruitees(conformes), ...
	 y_donnees_bruitees(conformes),...
     'b+','MarkerSize',10,'LineWidth',2);
lg = legend(' Cercle initial', ...
		    ' Donnees (bruitees + aberrantes)', ...
		    ' Cercle estime', ...
		    ' Donnees conformes', ...
		    'Location','Best');
