
% TP3 de Statistiques : fonctions a completer et rendre sur Moodle
% Nom :
% Prenom : 
% Groupe : 1SN-

function varargout = fonctions_TP3_stat(nom_fonction,varargin)

    switch nom_fonction
        case 'estimation_F'
            [varargout{1},varargout{2},varargout{3}] = estimation_F(varargin{:});
        case 'choix_indices_points'
            [varargout{1}] = choix_indices_points(varargin{:});
        case 'RANSAC_2'
            [varargout{1},varargout{2}] = RANSAC_2(varargin{:});
        case 'G_et_R_moyen'
            [varargout{1},varargout{2},varargout{3}] = G_et_R_moyen(varargin{:});
        case 'estimation_C_et_R'
            [varargout{1},varargout{2},varargout{3}] = estimation_C_et_R(varargin{:});
        case 'RANSAC_3'
            [varargout{1},varargout{2}] = RANSAC_3(varargin{:});
    end

end

% Fonction estimation_F (exercice_1.m) ------------------------------------
function [rho_F,theta_F,ecart_moyen] = estimation_F(rho,theta)
A = [cos(theta) sin(theta)];
B = rho;
X = A\B;

x_f = X(1);
y_f = X(2);

rho_F = sqrt(x_f.^2 + y_f.^2);
theta_F = atan2(y_f,x_f);
Mat = abs(rho - rho_F * cos(theta - theta_F));
ecart_moyen = mean(Mat);

end

% Fonction choix_indice_elements (exercice_2.m) ---------------------------
function tableau_indices_points_choisis = choix_indices_points(k_max,n,n_indices)

tableau_indices_points_choisis = zeros(k_max,n_indices);
    for i = 1:k_max
        tableau_indices_points_choisis(i,:) = randperm(n,n_indices);
    end
end

% Fonction RANSAC_2 (exercice_2.m) ----------------------------------------
function [rho_F_estime,theta_F_estime] = RANSAC_2(rho,theta,parametres,tableau_indices_2droites_choisies)

S1 = parametres(1);
S2 = parametres(2);
k_max = parametres(3);

ecart_temp = inf;

for i = 1:k_max
    
 indices = tableau_indices_2droites_choisies(i,:);
 [rho_temp,theta_temp,~] = estimation_F(rho(indices),theta(indices));
 mat_bool = abs(rho - rho_temp * cos(theta - theta_temp)) < S1;
    if sum(mat_bool)/length(rho) > S2
        [rho_F,theta_F,ecart_moyen] = estimation_F(rho(mat_bool),theta(mat_bool));
        if ecart_moyen < ecart_temp
            ecart_temp = ecart_moyen;
            rho_F_estime = rho_F;
            theta_F_estime = theta_F;
        end
    end
end

end

% Fonction G_et_R_moyen (exercice_3.m, bonus, fonction du TP1) ------------
function [G, R_moyen, distances] = ...
         G_et_R_moyen(x_donnees_bruitees,y_donnees_bruitees)

G = [mean(x_donnees_bruitees), mean(y_donnees_bruitees)];
R_moyen = mean(sqrt((mean(y_donnees_bruitees)-y_donnees_bruitees).^2 +  (mean(x_donnees_bruitees)-x_donnees_bruitees).^2));
distances = G - R_moyen;

end

% Fonction tirages_aleatoires (exercice_3.m, bonus, fonction du TP1) ----------------
function [tirages_C,tirages_R] = tirages_aleatoires_uniformes(n_tirages,G,R_moyen)
    
    tirages_C = G-R_moyen + rand(n_tirages,2).*(2*R_moyen);
    tirages_R = R_moyen/2 + rand(n_tirages,1).*(R_moyen);

end

% Fonction estimation_C_et_R (exercice_3.m, bonus, fonction du TP1) -------
function [C_estime, R_estime, critere] = ...
         estimation_C_et_R(x_donnees_bruitees,y_donnees_bruitees,tirages_C,tirages_R)

    Xdb=repmat(x_donnees_bruitees,length(tirages_C),1);
    Ydb=repmat(y_donnees_bruitees,length(tirages_C),1);
    Cx=repmat(tirages_C(:,1),1,length(x_donnees_bruitees));
    Cy=repmat(tirages_C(:,2),1,length(x_donnees_bruitees));
    distance= (sqrt((Xdb-Cx).^2+(Ydb-Cy).^2) - tirages_R).^2 ;
    [~, ind] = min(sum(distance,2));
    C_estime = tirages_C(ind, 1:2);
    R_estime = tirages_R(ind,1);

end

% Fonction RANSAC_3 (exercice_3, bonus) -----------------------------------
function [C_estime,R_estime] = ...
         RANSAC_3(x_donnees_bruitees,y_donnees_bruitees,parametres,tableau_indices_3points_choisis)
     


end
