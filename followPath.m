function [du, newPathIndex, newMoveIndex] = followPath(path, u, pathIndex, moveIndex, ir)
    % Return if path is empty
    if path == ""
        du = [0, 0, 0];
        newPathIndex = pathIndex;
        newMoveIndex = moveIndex;
        return
    end
    
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
        du = executeMovement("rotate 60");
        pathIndex = pathIndex + 1;
        moveIndex = 1;
    
    elseif command == "rotate -90" && size(path, 2) == 2
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

    if moveIndex > 5
        pathIndex = pathIndex + 1;
        moveIndex = 1;
    end

    newPathIndex = pathIndex;
    newMoveIndex = moveIndex;
end