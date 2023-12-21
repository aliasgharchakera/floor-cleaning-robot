function [linearVel, angularVel] = randomWalk(maxLinearSpeed, maxAngularSpeed)
    % Logic for random walking with maximum speed constraints.
    % For simplicity, just setting to fixed values, but you can use maxLinearSpeed and maxAngularSpeed to set limits.
    linearVel = rand * maxLinearSpeed; % Random linear velocity within the limit.
    angularVel = (rand * 2 - 1) * maxAngularSpeed; % Random angular velocity within the limit.
end
