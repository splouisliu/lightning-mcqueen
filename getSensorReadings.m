function [u, u_pf, ir] = getSensorReadings(map, scanAngles)
    global mode TESTING SIM BLUETOOTH;
    global true_pose s_cmd s_rply s_bt;
    
    if mode == TESTING
        u = rayCast(map, true_pose, scanAngles);
        %u = ([temp(1), temp(6), temp(2), 0, temp(5), temp(4), temp(3)] - 4.2465)*2.54;
        u_pf = [u(1), u(3), u(4), u(5)];
        ir = 10;

    elseif mode == SIM
        for ct = 1:size(scanAngles, 2)
           cmdstring = [strcat('u', num2str(ct)) newline];
           u(ct) = tcpclient_write(cmdstring, s_cmd, s_rply);
        end
        %u = ([temp(1), temp(6), temp(2), 0, temp(5), temp(4), temp(3)] - 4.2465)*2.54;
        u_pf = [u(1), u(3), u(4), u(5)];
        ir = 10;

    elseif mode == BLUETOOTH
        fwrite(s_bt, 's');
        readings = fscanf(s_bt);
        while strtrim(readings) == "Done"
            readings = fscanf(s_bt);
        end

        readings = split(readings,",");
        for i = 1:7
            t(i) = str2num(char(readings(i)));      % in CM, from outer sensors
        end

        u = [t(1), t(3), t(7), t(6), t(5), t(2)]/2.54 + 4.2465;
        u_pf = [u(1), u(3), u(4), u(5)];
        ir = str2num(char(readings(8)));
    end
end