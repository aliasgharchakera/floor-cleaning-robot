function [linearVel, angularVel, wallFollowed] = followWall(scanData, targetDistance)
    persistent cumulativeDistanceFollowed;
    if isempty(cumulativeDistanceFollowed)
        cumulativeDistanceFollowed = 0; % Initialize if not already set
    end
    
    % Initialize outputs
    linearVel = 0;
    angularVel = 0;
    wallFollowed = false;

    % Define control parameters
    Kp_distance = 0.5; % Proportional control gain for distance to the wall
    Kp_angle = 1.0; % Proportional control gain for angle to the wall
    minFollowingDistance = 0.1; % Minimum distance to follow wall before considering that the wall has been followed

    % Extract the distance at which the wall is detected and its angle
    [wallDistance, wallAngle] = min(scanData);

    % Check if we are close enough to follow a wall
    if wallDistance < targetDistance * 1.5
        % Calculate errors
        distanceError = targetDistance - wallDistance;
        angleError = -wallAngle; % Assuming 0 angle means facing the wall directly

        % Adjust velocities based on errors
        angularVel = Kp_distance * distanceError + Kp_angle * angleError; % Combine P-controllers for wall following
        linearVel = 0.2; % Set a constant forward velocity

        % Accumulate the distance followed
        cumulativeDistanceFollowed = cumulativeDistanceFollowed + linearVel;

        % Check if the wall has been followed for a certain distance
        if cumulativeDistanceFollowed > minFollowingDistance
            wallFollowed = true;
            cumulativeDistanceFollowed = 0; % Reset for the next wall follow
        end
    else
        % No wall detected within the target distance, search for a wall
        linearVel = 0;
        angularVel = -0.5; % Turn to find a wall
    end
end