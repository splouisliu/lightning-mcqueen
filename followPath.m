function [du, newPathIndex, newMoveIndex] = followPath(path, u, pathIndex, moveIndex, ir)
    
    command = path(pathIndex);
%     path
%     pathIndex
%     moveIndex

    if command == "forward"
        [du, action] = wander(u, ir);
        if action == "forward"
            moveIndex = moveIndex + 1;
        end

    elseif command == "rotate 90" && size(path, 2) == 2
        %du = executeMovement("rotate hard 90");                  %CHANGED
        du = executeMovement("rotate 60");
        pathIndex = pathIndex + 1;
        moveIndex = 1;
    
    elseif command == "rotate -90" && size(path, 2) == 2
        %du = executeMovement("rotate hard -90");                 %CHANGED
        du = executeMovement("rotate -60");
        pathIndex = pathIndex + 1;
        moveIndex = 1;
       
    elseif command == "rotate 180"
        du = executeMovement("rotate 180");
        pathIndex = pathIndex + 1;
        moveIndex = 1;

    elseif (command == "rotate 90")
        du = executeMovement("rotate 60");
        pathIndex = pathIndex + 1;
        moveIndex = 1;

    elseif (command == "rotate -90")
        du = executeMovement("rotate -60");
        pathIndex = pathIndex + 1;
        moveIndex = 1;

    else
        disp("invalid command");
    end

    if moveIndex > 5                % Changed
        pathIndex = pathIndex + 1;
        moveIndex = 1;
    end

    newPathIndex = pathIndex;
    newMoveIndex = moveIndex;
end