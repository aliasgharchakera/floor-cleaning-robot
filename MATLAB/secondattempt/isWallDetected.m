function isDetected = isWallDetected(scanData, safetyDistance)
    % Parameters
    minWallLength = 5; % Number of consecutive points that must be within safetyDistance to be considered a wall
    wallCount = 0;

    % Iterate through scan data points
    for distance = scanData
        if distance < safetyDistance
            wallCount = wallCount + 1;
            if wallCount >= minWallLength
                isDetected = true;
                return;
            end
        else
            wallCount = 0;
        end
    end

    % No wall detected
    isDetected = false;
end
