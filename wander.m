function [du, action] = wander(u, ir)
    % Forward
    if (u(1) > 8) && (u(2) > 7) && (u(6) > 7) && (u(3) > 5) && (u(5) > 5)
        action = "forward";
        du = executeMovement(action);
    
    % Left 15: side sensor too close
    elseif (u(5) < 5)
        action = "rotate 15";
        du = executeMovement(action);
    
    % Right 15: side sensor too close
    elseif (u(3) < 5)
        action = "rotate -15";
        du = executeMovement(action);
    
    % Left 15: diag sensor too close
    elseif (u(6) < 5)
        action = "rotate 15";
        du = executeMovement(action);

    % Right 30: diag sensor too close
    elseif (u(2) < 5)
        action = "rotate -15";
        du = executeMovement(action);
    
    % Orientation is off
    elseif (u(2) >= u(6))
        action = "rotate 15";
        du = executeMovement(action);
        
    elseif (u(6) > u(2))
        action = "rotate -15";
        du = executeMovement(action);

    % 180 deg
    else
        action = "rotate 180";
        du = executeMovement(action);
    end
end