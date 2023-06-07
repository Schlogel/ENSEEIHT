function [X_VS,w,c,code_retour] = SVM_1_3d(X,Y)
    H = eye(4,4);
    H(4,4) = 0;
    A = -Y.*[X -ones(size(X,1),1)];
    b = -ones(size(A,1),1);
    [w_tilde, ~, code_retour] = quadprog(H,zeros(4,1),A,b);
    w = [w_tilde(1);w_tilde(2);w_tilde(3)];
    c = w_tilde(4);
    VS = abs(X*w - c) <= -Y*(-1e-6 - 1);
    X_VS = X(VS,:);
end

