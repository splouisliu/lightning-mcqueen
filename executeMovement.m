function du = executeMovement(action)
    global mode TESTING SIM BLUETOOTH;
    global true_pose s_cmd s_rply s_bt;
    
    % Settings (does not apply to Bluetooth mode - depends on Arduino)
    movementStep = 3;
    
    if action == "forward"
        if mode == TESTING
            true_pose(1) = true_pose(1) + movementStep * cos(true_pose(3));
            true_pose(2) = true_pose(2) + movementStep * sin(true_pose(3));
            du = [movementStep, 0, 0];
        elseif mode == SIM
            cmdstring = [strcat('d1-',num2str(movementStep)) newline];
    	    tcpclient_write(cmdstring, s_cmd, s_rply);
            du = [movementStep, 0, 0];
        elseif mode == BLUETOOTH
            fwrite(s_bt,'f');
            response = fscanf(s_bt);
            du = calcOdometry(response);
        end

    elseif action == "rotate 15"
        if mode == TESTING
            true_pose(3) = wrapTo2Pi(true_pose(3)+deg2rad(15));
            du = [0, 0, deg2rad(15)];
        elseif mode == SIM
            cmdstring = [strcat('r1-',num2str(15)) newline];
		    tcpclient_write(cmdstring, s_cmd, s_rply);
            du = [0, 0, deg2rad(15)];
        elseif mode == BLUETOOTH
            fwrite(s_bt,'g');
            response = fscanf(s_bt);
            du = calcOdometry(response);
        end
        
    elseif action == "rotate -15"
        if mode == TESTING
            true_pose(3) = wrapTo2Pi(true_pose(3)-deg2rad(15));
            du = [0, 0, -deg2rad(15)];
        elseif mode == SIM
            cmdstring = [strcat('r1-',num2str(-15)) newline];
		    tcpclient_write(cmdstring, s_cmd, s_rply);
            du = [0, 0, -deg2rad(15)];
        elseif mode == BLUETOOTH
            fwrite(s_bt,'d');
            response = fscanf(s_bt);
            du = calcOdometry(response);
        end
        
    elseif action == "rotate 30"
        if mode == TESTING
            true_pose(3) = wrapTo2Pi(true_pose(3)+deg2rad(15));     % CORRECT
            du = [0, 0, deg2rad(15)];
        elseif mode == SIM
            cmdstring = [strcat('r1-',num2str(30)) newline];
		    tcpclient_write(cmdstring, s_cmd, s_rply);
            du = [0, 0, deg2rad(30)];
        elseif mode == BLUETOOTH
            fwrite(s_bt,'l');
            response = fscanf(s_bt);
            du = calcOdometry(response);
        end
        
    elseif action == "rotate -30"
        if mode == TESTING
            true_pose(3) = wrapTo2Pi(true_pose(3)-deg2rad(15));     % CORRECT
            du = [0, 0, -deg2rad(15)];
        elseif mode == SIM
            cmdstring = [strcat('r1-',num2str(-30)) newline];
		    tcpclient_write(cmdstring, s_cmd, s_rply);
            du = [0, 0, -deg2rad(30)];
        elseif mode == BLUETOOTH
            fwrite(s_bt,'r');
            response = fscanf(s_bt);
            du = calcOdometry(response);
        end
    
    elseif action == "rotate 60"
        if mode == TESTING
            true_pose(3) = wrapTo2Pi(true_pose(3)+deg2rad(60));
            du = [0, 0, deg2rad(60)];
        elseif mode == SIM
            cmdstring = [strcat('r1-',num2str(60)) newline];
		    tcpclient_write(cmdstring, s_cmd, s_rply);
            du = [0, 0, deg2rad(60)];
        elseif mode == BLUETOOTH
            fwrite(s_bt,'2');
            response = fscanf(s_bt);
            du = calcOdometry(response);
        end
    
    elseif action == "rotate -60"       
        if mode == TESTING
            true_pose(3) = wrapTo2Pi(true_pose(3)-deg2rad(60));
            du = [0, 0, -deg2rad(60)];
        elseif mode == SIM
            cmdstring = [strcat('r1-',num2str(-60)) newline];
		    tcpclient_write(cmdstring, s_cmd, s_rply);
            du = [0, 0, -deg2rad(60)];
        elseif mode == BLUETOOTH
            fwrite(s_bt,'1');
            response = fscanf(s_bt);
            du = calcOdometry(response);
        end
    
    elseif action == "rotate 90"
        if mode == TESTING
            true_pose(3) = wrapTo2Pi(true_pose(3)+deg2rad(90));
            du = [0, 0, deg2rad(90)];
        elseif mode == SIM
            cmdstring = [strcat('r1-',num2str(90)) newline];
		    tcpclient_write(cmdstring, s_cmd, s_rply);
            du = [0, 0, deg2rad(90)];
        elseif mode == BLUETOOTH
            fwrite(s_bt,'c');
            response = fscanf(s_bt);
            du = calcOdometry(response);
        end
    
    elseif action == "rotate -90"
        if mode == TESTING
            true_pose(3) = wrapTo2Pi(true_pose(3)-deg2rad(90));
            du = [0, 0, -deg2rad(90)];
        elseif mode == SIM
            cmdstring = [strcat('r1-',num2str(-90)) newline];
		    tcpclient_write(cmdstring, s_cmd, s_rply);
            du = [0, 0, -deg2rad(90)];
        elseif mode == BLUETOOTH
            fwrite(s_bt,'n');
            response = fscanf(s_bt);
            du = calcOdometry(response);
        end

    elseif action == "rotate 180"
        if mode == TESTING
            true_pose(3) = wrapTo2Pi(true_pose(3)+deg2rad(180));
            du = [0, 0, deg2rad(180)];
        elseif mode == SIM
            cmdstring = [strcat('r1-',num2str(180)) newline];
		    tcpclient_write(cmdstring, s_cmd, s_rply);
            du = [0, 0, deg2rad(180)];
        elseif mode == BLUETOOTH
            fwrite(s_bt,'e');
            response = fscanf(s_bt);
            du = calcOdometry(response);
        end
    end
end