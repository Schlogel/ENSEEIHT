
% TP2 de Statistiques : fonctions a completer et rendre sur Moodle
% Nom : Schlögel
% Prénom : Benjamin
% Groupe : 1SN-B

function varargout = fonctions_TP2_stat(nom_fonction,varargin)

    switch nom_fonction
        case 'tirages_aleatoires_uniformes'
            [varargout{1},varargout{2}] = tirages_aleatoires_uniformes(varargin{:});
        case 'estimation_Dyx_MV'
            [varargout{1},varargout{2}] = estimation_Dyx_MV(varargin{:});
        case 'estimation_Dyx_MC'
            [varargout{1},varargout{2}] = estimation_Dyx_MC(varargin{:});
        case 'estimation_Dyx_MV_2droites'
            [varargout{1},varargout{2},varargout{3},varargout{4}] = estimation_Dyx_MV_2droites(varargin{:});
        case 'probabilites_classe'
            [varargout{1},varargout{2}] = probabilites_classe(varargin{:});
        case 'classification_points'
            [varargout{1},varargout{2},varargout{3},varargout{4}] = classification_points(varargin{:});
        case 'estimation_Dyx_MCP'
            [varargout{1},varargout{2}] = estimation_Dyx_MCP(varargin{:});
        case 'iteration_estimation_Dyx_EM'
            [varargout{1},varargout{2},varargout{3},varargout{4},varargout{5},varargout{6},varargout{7},varargout{8}] = ...
            iteration_estimation_Dyx_EM(varargin{:});
    end

end

% Fonction centrage_des_donnees (exercice_1.m) ----------------------------
function [x_G, y_G, x_donnees_bruitees_centrees, y_donnees_bruitees_centrees] = ...
                centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees)
    x_G = mean(x_donnees_bruitees);
    y_G = mean(y_donnees_bruitees);
    x_donnees_bruitees_centrees = x_donnees_bruitees -x_G;
    y_donnees_bruitees_centrees = y_donnees_bruitees -y_G; 
end

% Fonction tirages_aleatoires_uniformes (exercice_1.m) ------------------------
function [tirages_angles,tirages_G] = tirages_aleatoires_uniformes(n_tirages,taille)
    tirages_angles = -pi/2 + rand(n_tirages,1).*pi;


    % Tirages aleatoires de points pour se trouver sur la droite (sur
    % [-20,20])
    tirages_G = -20 + rand(n_tirages,2).*40;

end

% Fonction estimation_Dyx_MV (exercice_1.m) -------------------------------
function [a_Dyx,b_Dyx] = ...
           estimation_Dyx_MV(x_donnees_bruitees,y_donnees_bruitees,tirages_psi)
    [x_G, y_G, xprim, yprim] = centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees);

    n = length(tirages_psi); 
    xc=repmat(xprim,n,1);
    yc=repmat(yprim,n,1);

    argument = ((yc - tan(tirages_psi).*xc).^2);
    [~, indice_a] = min(sum(argument,2));

    a_Dyx = tan(tirages_psi(indice_a));
    b_Dyx = y_G - a_Dyx * x_G;
end

% Fonction estimation_Dyx_MC (exercice_1.m) -------------------------------
function [a_Dyx,b_Dyx] = ...
                   estimation_Dyx_MC(x_donnees_bruitees,y_donnees_bruitees)
    A=[x_donnees_bruitees;ones(1,size(x_donnees_bruitees,2))]';
    B=y_donnees_bruitees';
    X = A\B;
    a_Dyx = X(1);
    b_Dyx = X(2);
end

% Fonction estimation_Dyx_MV_2droites (exercice_2.m) -----------------------------------
function [a_Dyx_1,b_Dyx_1,a_Dyx_2,b_Dyx_2] = ... 
         estimation_Dyx_MV_2droites(x_donnees_bruitees,y_donnees_bruitees,sigma, ...
                                    tirages_G_1,tirages_psi_1,tirages_G_2,tirages_psi_2) 
   
n1 = length(tirages_psi_1);
n2 = length(x_donnees_bruitees);
ra1b1 = ( repmat(y_donnees_bruitees,n1,1) - repmat(tirages_G_1(:,2),1,n2) ) - tan(repmat(tirages_psi_1,1,n2)) .* (repmat(x_donnees_bruitees,n1,1) - repmat(tirages_G_1(:,1),1,n2));
ra2b2 = ( repmat(y_donnees_bruitees,n1,1) - repmat(tirages_G_2(:,2),1,n2) ) - tan(repmat(tirages_psi_2,1,n2)) .* (repmat(x_donnees_bruitees,n1,1) - repmat(tirages_G_2(:,1),1,n2));

argument = log ( exp( - (ra1b1.^2)/(2 * sigma^2)) + exp( - (ra2b2.^2)/(2 * sigma^2)) );
[~, indice] = max(sum(argument,2));

a_Dyx_1 = tan(tirages_psi_1(indice));
b_Dyx_1 = tirages_G_1(indice,2) - a_Dyx_1 * tirages_G_1(indice,1);

a_Dyx_2 = tan(tirages_psi_2(indice));
b_Dyx_2 = tirages_G_2(indice,2) - a_Dyx_2 * tirages_G_2(indice,1);
end

% Fonction probabilites_classe (exercice_3.m) ------------------------------------------
function [probas_classe_1,probas_classe_2] = probabilites_classe(x_donnees_bruitees,y_donnees_bruitees,sigma,...
                                                                 a_1,b_1,proportion_1,a_2,b_2,proportion_2)
    ra1b1 = y_donnees_bruitees - a_1 * x_donnees_bruitees - b_1;
    ra2b2 = y_donnees_bruitees - a_2 * x_donnees_bruitees - b_2;
    
    probas_classe_1 = proportion_1 * exp(- (ra1b1.^2) / (2 * (sigma^2)));
    probas_classe_2 = proportion_2 * exp(- (ra2b2.^2) / (2 * (sigma^2)));

end

% Fonction classification_points (exercice_3.m) ----------------------------
function [x_classe_1,y_classe_1,x_classe_2,y_classe_2] = classification_points ...
              (x_donnees_bruitees,y_donnees_bruitees,probas_classe_1,probas_classe_2)
    
    Mat_booleene = probas_classe_1 > probas_classe_2;

    x_classe_1 = x_donnees_bruitees(Mat_booleene);
    y_classe_1 = y_donnees_bruitees(Mat_booleene);

    x_classe_2 = x_donnees_bruitees(~Mat_booleene);
    y_classe_2 = y_donnees_bruitees(~Mat_booleene);

end

% Fonction estimation_Dyx_MCP (exercice_4.m) -------------------------------
function [a_Dyx,b_Dyx] = estimation_Dyx_MCP(x_donnees_bruitees,y_donnees_bruitees,probas_classe)

    A=probas_classe'.*[x_donnees_bruitees;ones(1,size(x_donnees_bruitees,2))]';
    B=probas_classe'.*y_donnees_bruitees';
    X = A\B;
    a_Dyx = X(1);
    b_Dyx = X(2);
    
end

% Fonction iteration_estimation_Dyx_EM (exercice_4.m) ---------------------
function [probas_classe_1,proportion_1,a_1,b_1,probas_classe_2,proportion_2,a_2,b_2] =...
         iteration_estimation_Dyx_EM(x_donnees_bruitees,y_donnees_bruitees,sigma,...
         proportion_1,a_1,b_1,proportion_2,a_2,b_2)
        
    [P1, P2] = probabilites_classe(x_donnees_bruitees,y_donnees_bruitees,sigma,a_1,b_1,proportion_1,a_2,b_2,proportion_2);
    
    probas_classe_1 = P1 ./ (P1 + P2);
    probas_classe_2 = P2 ./ (P1 + P2);
    
    proportion_1 = mean(probas_classe_1);
    proportion_2 = mean(probas_classe_2);

    [a_1,b_1] = estimation_Dyx_MCP(x_donnees_bruitees,y_donnees_bruitees,probas_classe_1);
    [a_2,b_2] = estimation_Dyx_MCP(x_donnees_bruitees,y_donnees_bruitees,probas_classe_2);

end
