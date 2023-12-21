function [x_posteriori, P_posteriori, Xpri] = filterStep(x, P, u, Q, Z, R, M, g, b)
% [x_posteriori, P_posteriori, Xpri] = filterStep(x, P, u, Z, R, M, g, b)
% returns an a posteriori estimate of the state and its covariance

[Xpri, F_x, F_u] = transitionFunction(x, u, b);
PPri = F_x * P * F_x' + F_u * Q * F_u';

if isempty(Z)
    x_posteriori = Xpri;
    P_posteriori = PPri;
    return;
end

[v, H, R_update] = associateMeasurements(Xpri, PPri, Z, R, M, g);

y = reshape(v, [], 1);
H_reshaped = reshape(permute(H, [1,3,2]), [], 3);

% block diagonal matrix
nRows = size(R_update,1);
nCols = size(R_update,2);
nBlocks = size(R_update,3);
R_block = zeros(nBlocks*nRows, nBlocks*nCols);
for i = 0 : nBlocks-1
    R_block(i*nRows+1 : (i+1)*nRows, i*nCols+1 : (i+1)*nCols) = R_update(:,:,i+1);
end

S = H_reshaped * PPri * H_reshaped' + R_block;
K = PPri * (H_reshaped' / S);

% Manually create an identity matrix
n = size(PPri, 1);
I = zeros(n);
for i = 1:n
    I(i, i) = 1;
end

% Update state and covariance estimates
P_posteriori = (I - K * H_reshaped) * PPri;
x_posteriori = Xpri + K * y;
end
