function plotPath(xPositions, yPositions)
    figure;
    plot(xPositions, yPositions, 'bo-', 'LineWidth', 2);
    grid on;
    title('Path Taken by the Robot', 'FontSize', fontSize);
    xlabel('X Position', 'FontSize', fontSize);
    ylabel('Y Position', 'FontSize', fontSize);
end