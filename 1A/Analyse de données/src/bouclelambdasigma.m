clear;
close all;
clc;



load donnees_app;

% Donnees non filtrees :
X = X_app;
Y = Y_app;



% Estimation du SVM avec noyau gaussien :
sigma = 0.001 : 0.001 : 0.018;				% Ecart-type du noyau gaussien
lambda = 100 : 80 : 1500;
pourcentage = [];
for l = lambda
    for s = sigma
        [X_VS,Y_VS,Alpha_VS,c,code_retour] = SVM_3_souple(X,Y,s,l);
        
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
	        prediction = sign(exp(-sum((X_VS-x_i).^2,2)/(2*s^2))'*diag(Y_VS)*Alpha_VS-c);
	        if prediction==Y_test(i)
		        nb_classif_OK = nb_classif_OK+1;
	        end
        end
        pourcentage = [pourcentage double(nb_classif_OK/nb_donnees_test*100)];
    end
end
pourcentage = reshape(pourcentage,length(sigma),[]);
% plot3(sigma,lambda,pourcentage);
surf(sigma,lambda,pourcentage);
xlabel('sigma');
ylabel('lambda');
zlabel('pourcentage');
grid on;