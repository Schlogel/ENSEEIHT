function [X_VS,Y_VS,alpha_VS,c,code_retour] = SVM_3_souple(X,Y,sigma,lambda)
    n = size(X,1);
    G = zeros(n,n);
    f = -ones(n,1);
    lb = zeros(n,1);
    beq = 0;
    Aeq = Y';
    A = eye(n,n);
    b = ones(n,1)*lambda;
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
    [alpha, ~, code_retour] = quadprog(H,f,A,b,Aeq,beq,lb,ub);
    
    cond = alpha > 1e-6;
    X_VS = X(cond,:);
    Y_VS = Y(cond);
    alpha_VS = alpha(cond);
    
    index = 1;
    maxIt = length(alpha_VS);
    while (alpha_VS(index) >= lambda || alpha_VS(index) < 0) && index <= maxIt
        index = index +1;
    end

    c = sum(alpha_VS.*Y_VS.*G(cond,index)) - Y_VS(index);
end

