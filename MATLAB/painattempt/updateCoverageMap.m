function updatedCoverageMap = updateCoverageMap(coverageMap, currentPose, gridSize)
    % coverageMap: Grid-based map of the environment
    % currentPose: Current pose of the robot [x, y, theta]
    % gridSize: Size of each grid cell

    % Convert the robot's position to grid coordinates
    gridPos = ceil(currentPose(1:2) / gridSize);

    % Mark the current cell as covered
    coverageMap(gridPos(1), gridPos(2)) = 1;

    updatedCoverageMap = coverageMap;
end
