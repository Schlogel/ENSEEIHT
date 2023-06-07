clear;
close all;
clc;


load donnees_app;

% Donnees non filtrees :
X = X_app;
Y = Y_app;
load donnees_test;
nb_donnees_test = size(X_test,1);
% Estimation du SVM avec noyau gaussien :
sigma = 0.001 : 0.0005 : 0.019;
pourcentage = [];

for s = sigma % Ecart-type du noyau gaussien
    [X_VS,Y_VS,Alpha_VS,c,code_retour] = SVM_3(X,Y,s);
    
    % Si l'optimisation n'a pas converge :
    if code_retour ~= 1
	    return;
    end
    
    
    % Pourcentage de bonnes classifications des donnees de test :
    
    nb_classif_OK = 0;
    for i = 1:nb_donnees_test
	    x_i = X_test(i,:);
	    prediction = sign(exp(-sum((X_VS-x_i).^2,2)/(2*s^2))'*diag(Y_VS)*Alpha_VS-c);
	    if prediction==Y_test(i)
		    nb_classif_OK = nb_classif_OK+1;
	    end
    end
    pourcentage = [pourcentage double(nb_classif_OK/nb_donnees_test*100)];

end

plot(sigma,pourcentage);
xlabel('\sigma');
ylabel('Pourcentage');