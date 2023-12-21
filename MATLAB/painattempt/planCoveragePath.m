function cppPath = planCoveragePath(coverageMap)
    % Initialize path as an empty array
    cppPath = [];
    
    % Get the dimensions of the coverage map
    [numCellsX, numCellsY] = size(coverageMap);

    % Generate a simple back-and-forth path
    for x = 1:numCellsX
        if mod(x, 2) == 1  % Odd rows go right
            yPath = 1:numCellsY;
        else  % Even rows go left
            yPath = numCellsY:-1:1;
        end
        
        % Append the path for the current row
        for y = yPath
            cppPath = [cppPath; [x, y]];
        end
    end
end
