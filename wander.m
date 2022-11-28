function [du, action] = wander(u, ir)
    % Forward
    %if (u(1) > 8) && (u(2) > 7) && (u(6) > 7) && (u(3) > 5.2) && (u(5) > 5.2) && (ir > 250)
       % action = "rotate -60" ; 
       % du = executeMovement(action);
       % "60"

    if (u(1) > 8) && (u(2) > 7) && (u(6) > 7) && (u(3) > 5.2) && (u(5) > 5.2) && (ir < 250)
        action = "forward";
        du = executeMovement(action);
    
    % 180
    elseif (u(1) < 8) && (u(2) <= 7) && (u(6) <= 7) && (u(3) <= 5.2) && (u(5) <= 5.2)
        action = "rotate 180";
        du = executeMovement(action);
        "180"
    
    % Left 15: side sensor too close
    elseif (u(5) < 5.2)
        action = "rotate 15";
        du = executeMovement(action);
        "right side too close"
    
    % Right 15: side sensor too close
    elseif (u(3) < 5.2)
        action = "rotate -15";
        du = executeMovement(action);
        "left side too close"
    
    % Left 15: diag sensor too close
    elseif (u(6) < 7)
        action = "rotate 15";
        du = executeMovement(action);
        "right diag too close"

    % Right 30: diag sensor too close
    elseif (u(2) < 7)
        action = "rotate -15";
        du = executeMovement(action);
        "left diag too close"

    % Orientation is off
    elseif (u(2) >= u(6))
        action = "rotate 15";
        du = executeMovement(action);
        "adjust orientation"
        
    elseif (u(6) > u(2))
        action = "rotate -15";
        du = executeMovement(action);
        "adjust orientation"
    else
        disp("no wander cases!");
    end
end