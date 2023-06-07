function [X_VS,w,c,code_retour] = SVM_1(X,Y)
    H = eye(3,3);
    H(3,3) = 0;
    A = -Y.*[X -ones(size(X,1),1)];
    b = -ones(size(A,1),1);
    [w_tilde, ~, code_retour] = quadprog(H,zeros(3,1),A,b);
    w = [w_tilde(1);w_tilde(2)];
    c = w_tilde(3);
    VS = abs(X*w - c) <= -Y*(-1e-6 - 1);
    X_VS = X(VS,:);
end

