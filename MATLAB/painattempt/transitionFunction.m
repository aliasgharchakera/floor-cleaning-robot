function [f, F_x, F_u] = transitionFunction(x, u, b)

    % Simplified state update calculations
    theta = x(3);
    f = [x(1) + (u(1) + u(2)) / 2 * cos(theta)
         x(2) + (u(1) + u(2)) / 2 * sin(theta)
         x(3) + (u(2) - u(1)) / b
        ];

    % Simplified Jacobian with respect to the state
    F_x = [1, 0, -(u(1) + u(2)) / 2 * sin(theta)
           0, 1,  (u(1) + u(2)) / 2 * cos(theta)
           0, 0,  1];

    % Simplified Jacobian with respect to the control inputs
    F_u = [cos(theta) / 2, cos(theta) / 2
           sin(theta) / 2, sin(theta) / 2
           -1 / b,         1 / b];

end
