function visualize(map, particles, pose, estimatedPose, u, u_pf, angles, minNorm, du, pathInd)
    global mode TESTING;
    
    drawnow;
    clf;
    show(map);
    set(gcf,'Visible','on')
    xlim([-10, 108]);
    ylim([-10, 63]);
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
        line([pose(1), pose(1)+2*cos(pose(3))], [pose(2), pose(2)+2*sin(pose(3))], "Color", "green", "LineWidth", 1);
    
        for j = 1:size(angles,2)
            line([pose(1), pose(1)+u_pf(j)*cos(angles(j))], [pose(2), pose(2)+u_pf(j)*sin(angles(j))],'Color','green')
        end
    end
    
    % Draw estimated pose
    scatter(estimatedPose(1), estimatedPose(2), "red", "filled")
    line([estimatedPose(1), estimatedPose(1)+2*cos(estimatedPose(3))], [estimatedPose(2), estimatedPose(2)+2*sin(estimatedPose(3))], "Color", "red", ...
        "LineWidth", 1);
    
    % Draw stats
    particles(:, 3) = rad2deg(particles(:, 3));
    meanParticles = mean(particles);
    stdParticles = std(particles);
    du(3) = rad2deg(du(3));
    
    xL=xlim;
    yL=ylim;
    text(xL(1)+3, yL(2)-2, "Measurement = (" + join(string(round(u, 1)), ", ") + ")", 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top')
    text(xL(1)+3, yL(2)-6, "du = ("  + join(string(round(du, 1)), ", ") + ")", 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top')
    %text(xL(2)-3, yL(2)-6, "Mean = (" + join(string(round(meanParticles, 1)), ", ") + ")", 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top')
    text(xL(2)-3, yL(2)-2, "Std = (" + join(string(round(stdParticles, 1)), ", ") + ")", 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top')
    text(xL(2)-3, yL(2)-6, "Min Norm = " + minNorm, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top')
    
    
    
    drawnow;
end