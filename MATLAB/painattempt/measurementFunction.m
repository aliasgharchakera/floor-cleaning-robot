function [h, H_x] = measurementFunction(x, m)

h = [
    m(1) - x(3)
    m(2) - (x(1)*cos(m(1)) + x(2)*sin(m(1)))
    ];

H_x = [
    0,          0,          -1
    -cos(m(1)), -sin(m(1)),  0
    ];

[h(1), h(2), isRNegated] = normalizeLineParameters(h(1), h(2));

if isRNegated 
    H_x(2, :) = - H_x(2, :);
end
