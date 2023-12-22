function [targetDirection, updatedCppPath] = adjustTargetDirection(cppPath, currentPose, gridSize, uncertainty)
    % cppPath: The planned coverage path
    % currentPose: Current pose of the robot [x, y, theta]
    % gridSize: Size of each grid cell
    % uncertainty: Amount of uncertainty to introduce (in radians)

    % Find the closest point on the path to the robot's current position
    % Convert the robot's current position to grid coordinates
    currentGridPos = ceil(currentPose(1:2) ./ gridSize);
    % Calculate the differences between cppPath and currentGridPos
    differences = cppPath - currentGridPos';

    % Calculate the distances using element-wise vector norm
    distances = vecnorm(differences, 2, 2);
    [minDistance, closestIndex] = min(distances);

    % If the robot is close enough to the current target, move to the next point
    if minDistance < gridSize
        if closestIndex < size(cppPath, 1)
            closestIndex = closestIndex + 1; % Move to next point
        end
    end

    % Compute the target direction towards the next point
    nextPoint = cppPath(closestIndex, :) * gridSize;
    targetDirection = atan2(nextPoint(2) - currentPose(2), nextPoint(1) - currentPose(1));

    % Add random noise to the target direction
    targetDirection = targetDirection + uncertainty * randn();

    % Update the coverage path (remove visited points)
    updatedCppPath = cppPath(closestIndex:end, :);
end
