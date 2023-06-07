function [X_VS,Y_VS,Alpha_VS,c,code_retour] = SVM_3(X,Y,sigma)
    n = size(X,1);
    G = zeros(n,n);
    f = -ones(n,1);
    lb = zeros(n,1);
    beq = 0;
    Aeq = Y';
    for i = 1: n
        for j = 1:n
            G(i,j) = exp(-norm(X(i,:) - X(j,:),2).^2 / (2*sigma.^2));
        end
    end
    H = zeros(n,n);
    for i = 1 :n
        for j = 1 : n
            H(i,j) = Y(i)*G(i,j)*Y(j);
        end
    end

    ub = inf(n,1);
    [alpha, ~, code_retour] = quadprog(H,f,[],[],Aeq,beq,lb,ub);
    
    cond = alpha > 1e-6;
    X_VS = X(cond,:);
    Y_VS = Y(cond);
    Alpha_VS = alpha(cond);

    c = sum(Alpha_VS.*Y_VS.*G(cond,1)) - Y_VS(1);
end

