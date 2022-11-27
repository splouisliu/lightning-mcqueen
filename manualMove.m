function du = manualMove()
    % Get keyboard input and execute movement
    m_m = input('enter move: ', 's');
    
    if strcmp(m_m, 'w')
        du = executeMovement("forward");
    
    elseif strcmp(m_m, 'd')
        du = executeMovement("rotate -90");
    
    elseif strcmp(m_m, 'a')
        du = executeMovement("rotate 90");

    elseif strcmp(m_m, 's')
        du = executeMovement("rotate 180");
        
    else
	    disp("error");
        du = [0, 0, 0];
    end
end