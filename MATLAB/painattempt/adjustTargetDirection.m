function [targetDirection, updatedCppPath] = adjustTargetDirection(cppPath, currentPose, gridSize)
    % cppPath: The planned coverage path
    % currentPose: Current pose of the robot [x, y, theta]
    % gridSize: Size of each grid cell

    % Find the closest point on the path to the robot's current position
    % Convert the robot's current position to grid coordinates
    currentGridPos = ceil(currentPose(1:2) ./ gridSize);
    distances = vecnorm(cppPath - currentGridPos, 2, 2);
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

    % Update the coverage path (remove visited points)
    updatedCppPath = cppPath(closestIndex:end, :);
end
