function distance = getWallDistance(scanData, sensorAngle)
    % This function would extract the distance reading from your scan data at a given angle
    % You need to implement this based on how your scan data is structured

    % For example, let's say you have 180 degree LiDAR data in scanData
    numReadings = length(scanData);
    angleIncrement = pi / (numReadings - 1);
    
    % Find the index that corresponds to the sensor angle
    sensorIndex = round((sensorAngle + (pi/2)) / angleIncrement);
    
    % Get the distance at that index
    distance = scanData(sensorIndex);
end