function coverageMap = initializeCoverageMap(roomDimensions, gridSize)
    % roomDimensions: [length, width] of the room
    % gridSize: Size of each grid cell
    
    % Calculate the number of cells in each dimension
    numCellsX = ceil(roomDimensions(1) / gridSize);
    numCellsY = ceil(roomDimensions(2) / gridSize);
    
    % Initialize the coverage map (0 = uncovered, 1 = covered)
    coverageMap = zeros(numCellsX, numCellsY);
end
