function updatedCoverageMap = updateCoverageMap(coverageMap, currentPose, gridSize)
    % coverageMap: Grid-based map of the environment
    % currentPose: Current pose of the robot [x, y, theta]
    % gridSize: Size of each grid cell

    % Convert the robot's position to grid coordinates
    currentGridPos = round(currentPose(1:2) ./ gridSize);

    % Ensure the indices are within the bounds of the coverageMap
    currentGridPos(1) = max(1, min(size(coverageMap, 1), currentGridPos(1)));
    currentGridPos(2) = max(1, min(size(coverageMap, 2), currentGridPos(2)));

    % Mark the current cell as covered
    coverageMap(currentGridPos(1), currentGridPos(2)) = 1;

    updatedCoverageMap = coverageMap;
end
