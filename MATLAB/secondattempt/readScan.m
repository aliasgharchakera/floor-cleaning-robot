function scanData = readScan(scanMsg)
    % Convert ROS laser scan message to MATLAB array of distances.
    scanData = scanMsg.Ranges;
end