function [X_VS,w,c,code_retour] = SVM_2(X,Y)
    n = length(Y);
    f = -ones(n,1);
    lb = zeros(n,1);
    beq = 0;
    Aeq = Y';
    H = zeros(n,n);
    for i = 1 :n
        for j = 1 : n
            H(i,j) = Y(i)*X(i,:)*X(j,:)'*Y(j);
        end
    end
    ub = inf(n,1);
    [alpha, ~, code_retour] = quadprog(H,f,[],[],Aeq,beq,lb,ub);
    
    w = sum(repmat(alpha, 1,2) .* repmat(Y, 1 ,2) .* X)';
    X_VS = X(alpha > 1e-6,:);
    
    c = mean(X_VS*w - 1 ./ Y(alpha > 1e-6));
end

