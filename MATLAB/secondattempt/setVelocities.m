function setVelocities(velPub, velMsg, linearVel, angularVel)
    % Set the velocities in the ROS message
    velMsg.Linear.X = linearVel;
    velMsg.Angular.Z = angularVel;
    
    % Send the velocity command to the robot
    send(velPub, velMsg);
end
