function [v, H, R] = associateMeasurements(x, P, Z, R, M, g)
% ASSOCIATEMEASUREMENTS: Associates sensor measurements with map entries.
% Inputs:
%   x - State vector.
%   P - Covariance matrix of the state.
%   Z - Measurement matrix.
%   R - Measurement noise covariance matrix.
%   M - Map entries.
%   g - Threshold for Mahalanobis distance.
% Outputs:
%   v - Innovation vectors for the selected measurements.
%   H - Corresponding Jacobians.
%   R - Covariance matrices of selected measurements.

nMeasurements = size(Z, 2);
nMapEntries = size(M, 2);
v = [];
H = [];
R_selected = [];
measurementFound = false; % Flag to indicate if any measurement is found

for i = 1:nMeasurements
    min_d = inf;
    min_j = 0;
    for j = 1:nMapEntries
        [z_priori, H_ij] = measurementFunction(x, M(:, j));
        v_ij = Z(:, i) - z_priori;
        W = H_ij * P * H_ij' + R(:,:,i);
        d = v_ij' / W * v_ij;
        if d < min_d
            min_d = d;
            min_j = j;
            v_min = v_ij;
            H_min = H_ij;
        end
    end
    % Update arrays if a valid measurement is found
    if min_d < g^2
        measurementFound = true;
        v = [v, v_min];
        H = cat(3, H, H_min);
        R_selected = cat(3, R_selected, R(:, :, i));
    end
end

% Reshape v and H to match original function's output format
if measurementFound
    v = reshape(v, [2, numel(v) / 2]);
    H = reshape(H, [2, 3, size(H, 3)]);
else
    % No measurements found, return zero matrices
    v = zeros(2, 0);
    H = zeros(2, 3, 0);
end
R = R_selected;
end
