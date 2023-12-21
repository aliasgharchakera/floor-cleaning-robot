function [linearVel, angularVel, wallFollowed, integral, previousError] = wallFollowPID(scanData, targetDistance, kp, ki, kd, integral, previousError, dt, maxLinearSpeed, maxAngularSpeed)
    % Angle range for the right side of the robot to the wall
    angleRange = -pi/4:scanData.AngleIncrement:pi/4; % Modify as per your sensor orientation
    
    % Find the distance and angle of the closest wall within the angle range
    rightSideDistances = scanData.Ranges(scanData.AngleMin >= min(angleRange) & scanData.AngleMax <= max(angleRange));
    [minDistance, minIndex] = min(rightSideDistances);
    wallAngle = angleRange(minIndex);
    
    % Ensure we have a valid reading
    if isempty(minDistance)
        linearVel = 0;
        angularVel = 0;
        wallFollowed = false;
        return;
    end
    
    % Error is the difference between the desired distance and the measured distance
    error = minDistance - targetDistance;
    
    % Update integral and derivative terms
    integral = integral + error * dt;
    derivative = (error - previousError) / dt;
    
    % Calculate PID output
    output = kp * error + ki * integral + kd * derivative;
    
    % Saturate the output to max/min angular velocity
    angularOutput = max(min(output, maxAngularSpeed), -maxAngularSpeed);
    
    % If the wall is on the right, we need to turn left (negative angular velocity)
    if wallAngle > 0
        angularVel = -angularOutput;
    else % If the wall is on the left, turn right (positive angular velocity)
        angularVel = angularOutput;
    end
    
    % Update linear velocity based on how well we are following the wall
    linearVel = maxLinearSpeed * (1 - abs(error) / targetDistance);
    linearVel = max(min(linearVel, maxLinearSpeed), 0.1); % Maintain a minimum speed
    
    % Determine if the wall is being followed
    wallFollowed = abs(error) < 0.05; % Adjust tolerance as needed
    
    % Update previous error for the next cycle
    previousError = error;
end