% User is asked for the number of steps to take.
% There are no limits for the x and y boundaries.

clc;    % Clear the command window.
clearvars;
close all;  % Close all figures (except those of imtool.)
workspace;  % Make sure the workspace panel is showing.
fontSize = 20;
format compact;

% Constants and Definitions
RANDOM_WALK = 1;
WALL_FOLLOW = 2;
COMPLETED_WALL_FOLLOW = 3;

% User is asked for the duration of the robot's operation in seconds.
defaultValue = '300';  % Default duration as a string for 300 seconds.
userPrompt = 'Enter the duration for the robot to move (in seconds): ';
durationInput = inputdlg(userPrompt, 'Duration Input', 1, {defaultValue});

% Check if the Cancel button was pressed or if there is no input
if isempty(durationInput)
    disp('User cancelled or entered no input. Using default duration.');
    durationSeconds = str2double(defaultValue);
else
    durationSeconds = str2double(durationInput{1});  % Convert input to double.
end

% Validate the user input.
if isnan(durationSeconds) || durationSeconds <= 0
    disp('Invalid input. Using default value of 300 seconds.');
    durationSeconds = str2double(defaultValue);  % Fallback to default value.
end

% Initialize the ROS.
rosinit("192.168.14.128", 11311);

% Create the subscribers and publishers.
laserSub = rossubscriber("/scan", "DataFormat", "struct");
[velPub, velMsg] = rospublisher("/cmd_vel", "geometry_msgs/Twist", "DataFormat", "struct");
odomSub = rossubscriber('/odom', 'nav_msgs/Odometry');

% Initialize state variables.
currentState = RANDOM_WALK;
wallFollowed = false;
currentPosition = [0, 0]; % You will get this from odometry data.
safetyDistance = 0.5; % Adjust as needed.
maxLinearSpeed = 0.2;  % Maximum linear speed for random walk
maxAngularSpeed = 0.2; % Maximum angular speed for random walk
searchTurnSpeed = 0.2; % Speed to turn at when searching for a wall

% Define control loop timing parameters.
timeStep = 1; % Duration of each control loop iteration in seconds
startTime = rostime('now');
endTime = startTime + rosduration(durationSeconds);

% Initialize positions for plotting
xPositions = [];
yPositions = [];

% Main control loop
while rostime('now') < endTime
    % Get the latest laser scan data
    scanData = readScan(receive(laserSub));

    switch currentState
        case RANDOM_WALK
            [linearVel, angularVel] = randomWalk(maxLinearSpeed, maxAngularSpeed);
            if isWallDetected(scanData, safetyDistance)
                currentState = WALL_FOLLOW;
                wallFollowed = false;  % Reset wall followed flag
            end
            
        case WALL_FOLLOW
            if ~wallFollowed
                [linearVel, angularVel, wallFollowed] = followWall(scanData, safetyDistance);
                if wallFollowed
                    % Transition back to random walk after following the wall
                    currentState = RANDOM_WALK;
                end
            end

        otherwise
            disp('Unknown state.');
            linearVel = 0;
            angularVel = 0;
    end

    % Set the velocities in the ROS message
    velMsg.Linear.X = linearVel;
    velMsg.Angular.Z = angularVel;
    send(velPub, velMsg);

    % Receive the latest odometry data and update the positions
    odomData = receive(odomSub, 1); % Timeout in seconds
    currentPosition = [odomData.Pose.Pose.Position.X, odomData.Pose.Pose.Position.Y];
    xPositions(end+1) = currentPosition(1);
    yPositions(end+1) = currentPosition(2);

    % Pause for the time step duration
    pause(timeStep);
end

% Shutdown ROS
rosshutdown();

% Plot the path taken by the robot
figure;
plot(xPositions, yPositions, 'bo-', 'LineWidth', 2);
grid on;
title('Path Taken by the Robot', 'FontSize', fontSize);
xlabel('X Position', 'FontSize', fontSize);
ylabel('Y Position', 'FontSize', fontSize);