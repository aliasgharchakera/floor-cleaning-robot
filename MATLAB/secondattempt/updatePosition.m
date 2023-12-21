function updatePosition(odomSub, currentPosition)
    % Receive the latest odometry data
    odomData = receive(odomSub,1); % timeout in seconds
    currentPosition(1) = odomData.Pose.Pose.Position.X;
    currentPosition(2) = odomData.Pose.Pose.Position.Y;
end
