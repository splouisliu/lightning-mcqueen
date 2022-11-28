function visualize(map, particles, pose, estimatedPose, u, u_pf, angles, minNorm, du, pathInd)
    global mode TESTING;
    
    drawnow;
    clf;
    show(map);
    set(gcf, 'Visible', 'on', "Position", [200, 150, 1000, 500]);
    xlim([-10, 160]);
    ylim([-10, 70]);
    axis equal;
    xlabel("X [inches]")
    ylabel("Y [inches]")
    hold on;

    angles = wrapTo2Pi(angles + pose(3));
    
    % Draw path
    if size(pathInd, 1) >= 1
        pathInd = [pathInd(:,2), 4-pathInd(:,1)+1];
        
        for i = 1:size(pathInd, 1)-1
            rectangle("Position", [(pathInd(i, 1)-1)*12+1, (pathInd(i, 2)-1)*12+1, 12, 12], ...
                'FaceColor', [1 0.9 1], 'EdgeColor', [1 0.9 1]);
        end
        rectangle("Position", [(pathInd(size(pathInd, 1), 1)-1)*12+1, (pathInd(size(pathInd, 1), 2)-1)*12+1, 12, 12], ...
                'FaceColor', [1 0.7 1], 'EdgeColor', [1 0.7 1]);
    end
    
    % Draw particles
    scatter(particles(:,1), particles(:,2), 2, "filled", "MarkerFaceColor", [0 0.4470 0.7410]);
    
    % Draw ground truth pose alongside measurements (only when testing, not simulating or live)
    if mode == TESTING
        scatter(pose(1), pose(2), "green", "filled");
        line([pose(1), pose(1)+2*cos(pose(3))], [pose(2), pose(2)+2*sin(pose(3))], "Color", "green", "LineWidth", 2);
    
        for j = 1:size(angles,2)
            line([pose(1), pose(1)+u_pf(j)*cos(angles(j))], [pose(2), pose(2)+u_pf(j)*sin(angles(j))],'Color','green')
        end
    end
    
    % Draw estimated pose
    scatter(estimatedPose(1), estimatedPose(2), "red", "filled")
    line([estimatedPose(1), estimatedPose(1)+2*cos(estimatedPose(3))], [estimatedPose(2), estimatedPose(2)+2*sin(estimatedPose(3))], "Color", "red", ...
        "LineWidth", 2);

    % Draw robot measurements
    
    
    rectangle('Position', [[130 25]-10 2*10 2*10], 'Curvature',[1 1]);
    
    line([130, 130+12*cos(pi/2)], [25, 25+12*sin(pi/2)], "Color", "red", ...
            "LineWidth", 2);
    line([130, 130+12*cos(3*pi/4)], [25, 25+12*sin(3*pi/4)], "Color", "red", ...
            "LineWidth", 2);
    line([130, 130+12*cos(pi)], [25, 25+12*sin(pi)], "Color", "red", ...
            "LineWidth", 2);
    line([130, 130+12*cos(3*pi/2)], [25, 25+12*sin(3*pi/2)], "Color", "red", ...
            "LineWidth", 2);
    line([130, 130+12*cos(0)], [25, 25+12*sin(0)], "Color", "red", ...
            "LineWidth", 2);
    line([130, 130+12*cos(pi/4)], [25, 25+12*sin(pi/4)], "Color", "red", ...
            "LineWidth", 2);
    
    text(130+12*cos(pi/2) - 2, 25+12*sin(pi/2) + 7, string(round(u(1), 1)));
    text(130+12*cos(3*pi/4) - 6, 25+12*sin(3*pi/4) + 5, string(round(u(2), 1)));
    text(130+12*cos(pi) - 9, 25+12*sin(pi), string(round(u(3), 1)));
    text(130+12*cos(3*pi/2) - 2, 25+12*sin(3*pi/2) - 4, string(round(u(4), 1)));
    text(130+12*cos(0) + 5, 25+12*sin(0), string(round(u(5), 1)));
    text(130+12*cos(pi/4) + 2, 25+12*sin(pi/4) + 5, string(round(u(6), 1)));
    
    % Draw stats
    particles(:, 3) = rad2deg(particles(:, 3));
    meanParticles = mean(particles);
    stdParticles = std(particles);
    du(3) = rad2deg(du(3));
    
    xL=xlim;
    yL=ylim;
    text(xL(1)+3, yL(2)-2, "Position = (" + join(string(round(estimatedPose, 0)), ", ") + ")", 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top')
    text(xL(1)+3, yL(2)-6, "du = ("  + join(string(round(du, 1)), ", ") + ")", 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top')
    text(xL(2)-3, yL(2)-2, "Std = (" + join(string(round(stdParticles, 1)), ", ") + ")", 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top')
    text(xL(2)-3, yL(2)-6, "Min Norm = " + minNorm, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top')
    
    drawnow;
end