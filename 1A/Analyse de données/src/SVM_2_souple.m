function [X_VS,w,c,code_retour] = SVM_2_souple(X,Y,lambda)

    n = length(Y);
    f = -ones(n,1);
    lb = zeros(n,1);
    beq = 0;
    Aeq = Y';
    H = zeros(n,n);
    A = eye(n,n);
    b = ones(n,1)*lambda;
    for i = 1 :n
        for j = 1 : n
            H(i,j) = Y(i)*X(i,:)*X(j,:)'*Y(j);
        end
    end
    ub = inf(n,1);

    [alpha, ~, code_retour] = quadprog(H,f,A,b,Aeq,beq,lb,ub);
    
    
    
    cond = alpha > 1e-6;
    X_VS = X(cond,:);
    Y_VS = Y(cond);
    alpha_VS = alpha(cond);
    
    w = sum(repmat(alpha_VS, 1,2) .* repmat(Y_VS, 1 ,2) .* X_VS)';

    index = 1;
    maxIt = length(alpha_VS);
    while (alpha_VS(index) >= lambda || alpha_VS(index) < 0) && index <= maxIt
        index = index +1;
    end

    c = X_VS(index,:)*w - 1 ./ Y_VS(index);
end

