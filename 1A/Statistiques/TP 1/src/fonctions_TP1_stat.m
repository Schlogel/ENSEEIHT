
% TP1 de Statistiques : fonctions a completer et rendre sur Moodle
% Nom :
% Prénom : 
% Groupe : 1SN-

function varargout = fonctions_TP1_stat(nom_fonction,varargin)

    switch nom_fonction
        case 'tirages_aleatoires_uniformes'
            varargout{1} = tirages_aleatoires_uniformes(varargin{:});
        case 'estimation_Dyx_MV'
            [varargout{1},varargout{2}] = estimation_Dyx_MV(varargin{:});
        case 'estimation_Dyx_MC'
            [varargout{1},varargout{2}] = estimation_Dyx_MC(varargin{:});
        case 'estimation_Dorth_MV'
            [varargout{1},varargout{2}] = estimation_Dorth_MV(varargin{:});
        case 'estimation_Dorth_MC'
            [varargout{1},varargout{2}] = estimation_Dorth_MC(varargin{:});
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

% Fonction tirages_aleatoires (exercice_1.m) ------------------------------
function tirages_angles = tirages_aleatoires_uniformes(n_tirages)
    tirages_angles = -pi/2 + rand(n_tirages,1).*pi;
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

% Fonction estimation_Dyx_MC (exercice_2.m) -------------------------------
function [a_Dyx,b_Dyx] = ...
                   estimation_Dyx_MC(x_donnees_bruitees,y_donnees_bruitees)
    [p, Size_x] = size(x_donnees_bruitees);
    A = ones(Size_x,2);
    A(1:Size_x,1) = x_donnees_bruitees';
    B = y_donnees_bruitees';
    X = A\B;
    a_Dyx = X(1);
    b_Dyx = X(2);
    
    
end

% Fonction estimation_Dorth_MV (exercice_3.m) -----------------------------
function [theta_Dorth,rho_Dorth] = ...
         estimation_Dorth_MV(x_donnees_bruitees,y_donnees_bruitees,tirages_theta)

    [x_G, y_G, xprim, yprim] = centrage_des_donnees(x_donnees_bruitees,y_donnees_bruitees);

    argument = xprim.*cos(tirages_theta) + yprim.*sin(tirages_theta);
    [~, indice_a] = min(sum(argument.^2,2));

    theta_Dorth = tirages_theta(indice_a);
    rho_Dorth = y_G*sin(theta_Dorth) + x_G*cos(theta_Dorth);


end

% Fonction estimation_Dorth_MC (exercice_4.m) -----------------------------
function [theta_Dorth,rho_Dorth] = ...
                 estimation_Dorth_MC(x_donnees_bruitees,y_donnees_bruitees)



end
