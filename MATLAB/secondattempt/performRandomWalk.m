function [linearVel, angularVel] = performRandomWalk(maxLinearSpeed, maxAngularSpeed)
    linearVel = rand * maxLinearSpeed; 
    angularVel = (rand * 2 - 1) * maxAngularSpeed;
end