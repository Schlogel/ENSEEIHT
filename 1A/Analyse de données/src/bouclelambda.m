clear;
close all;
clc;



load donnees_app;

% Donnees filtrees :
X = X_app_filtre;
Y = Y_app_filtre;


lambda = 100 : 80 : 1500;
pourcentage = [];

for l = lambda
    % Estimation du SVM lineaire (formulation duale) :
    [X_VS,w,c,code_retour] = SVM_2_souple(X,Y,l);
    
    % Si l'optimisation n'a pas converge :
    if code_retour ~= 1
	    return;
    end
    
    % Pourcentage de bonnes classifications des donnees de test :
    load donnees_test;
    nb_donnees_test = size(X_test,1);
    nb_classif_OK = 0;
    for i = 1:nb_donnees_test
	    x_i = X_test(i,:);
	    prediction = sign(1/(x_i*w - c));
	    if prediction==Y_test(i)
		    nb_classif_OK = nb_classif_OK+1;
	    end
    end
    pourcentage = [pourcentage double(nb_classif_OK/nb_donnees_test*100)];

end
plot(lambda,pourcentage);
xlabel('\lambda');
ylabel('Pourcentage');