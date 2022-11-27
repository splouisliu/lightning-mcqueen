function gripper(pickupLocation) 
    global s_bt;

    s = s_bt;

    if pickupLocation == 2
        entry = "north";
    elseif pickupLocation == 9
        entry = "south";
    end

    blockfound = 0;
    
    counter = 0;
    
    forward_counter = 0;
    
    fwrite(s, 'h');
    
    if (blockfound==0);
        
    while ((blockfound==0) && (forward_counter < 2));
    
        fwrite(s, 's');
        readings = fscanf(s);
        readings = split(readings,",");
    
        for i = 1:7
            u(i) = str2num(char(readings(i))); 
        end
        
       
        ir = str2num(char(readings(8)));
        
         a = "top"
         disp(u(4))
         a = "bottom"
         disp(u(1))
    %     disp(u(3))
    %     disp(u(2))
    %     disp(ir)
    
        ir_cm = round((ir*(-0.08568980291)+19.28020566)*2.54);
        a = "ir"
        disp(ir)
       
        if ((u(4)-u(1)) > 13) ||  ir> 250 %% ((u(4)-ir_cm)> 30 && (u(4)-ir_cm)<40)
            if (u(1)<10) || ir > 200
                if (u(1) < 6) || ir > 400
                    fwrite(s, '9');
                    pause(0.5)
                    fwrite(s, 'u');
                    pause(5);
                    fwrite(s, 'o');
                    pause(2);
                    fwrite(s, 'i');
    
                    blockfound = 1
                elseif (u(4) > 8 ) && (u(3) > 3) && (u(2) > 3) 
                    fwrite(s, 'm');
                    readings = fscanf(s);
    
                    forward_counter = forward_counter + 0.34;
                end
            else
                if (u(4) > 12 ) && (u(3) > 7) && (u(2) > 7)
                    fwrite(s, 'f');
                    readings = fscanf(s);
    
                    forward_counter = forward_counter + 1;
                end
            end
        
    end 
    
    
    
    
    end 
    
    if (entry == "east");
    if ((blockfound==0) && (counter < 15));
    
    while ((blockfound==0) && (counter < 15));
    
        fwrite(s, 's');
        readings = fscanf(s);
        readings = split(readings,",");
    
        for i = 1:7
            u(i) = str2num(char(readings(i))); 
        end
        
       
        ir = str2num(char(readings(8)));
        
         a = "top"
         disp(u(4))
         a = "bottom"
         disp(u(1))
    %     disp(u(3))
    %     disp(u(2))
    %     disp(ir)
    
        ir_cm = round((ir*(-0.08568980291)+19.28020566)*2.54);
        a = "ir"
        disp(ir)
       
        if ((u(4)-u(1)) > 13) ||  ir> 250 %% ((u(4)-ir_cm)> 30 && (u(4)-ir_cm)<40)
            if (u(1)<10) || ir > 200
                if (u(1) < 6) || ir > 400
                    fwrite(s, '9');
                    pause(0.5)
                    fwrite(s, 'u');
                    pause(5);
                    fwrite(s, 'o');
                    pause(2);
                    fwrite(s, 'i');
    
                    blockfound = 1
                elseif (u(4) > 8 ) && (u(3) > 3) && (u(2) > 3) 
                    fwrite(s, 'm');
                    readings = fscanf(s);
                end
            else
                if (u(4) > 12 ) && (u(3) > 7) && (u(2) > 7)
                    fwrite(s, 'f');
                    readings = fscanf(s);
                end
            end
        else
            fwrite(s, '#');
            readings = fscanf(s);
            
            counter = counter + 1;
    
        end
        
    end 
    else
            fwrite(s, '#');
            readings = fscanf(s);
    
            pause(0.5)
            fwrite(s, 'm');
            readings = fscanf(s);
            pause(0.5)
            fwrite(s, 'm');
            readings = fscanf(s);
            pause(0.5)
            fwrite(s, 'm');
            readings = fscanf(s);
    
            counter = 0;
    
    end
    
    else if (entry == "south");
    
    if ((blockfound==0) && (counter < 15));
    
    while ((blockfound==0) && (counter < 15));
    
        fwrite(s, 's');
        readings = fscanf(s);
        readings = split(readings,",");
    
        for i = 1:7
            u(i) = str2num(char(readings(i))); 
        end
        
       
        ir = str2num(char(readings(8)));
        
         a = "top"
         disp(u(4))
         a = "bottom"
         disp(u(1))
    %     disp(u(3))
    %     disp(u(2))
    %     disp(ir)
    
        ir_cm = round((ir*(-0.08568980291)+19.28020566)*2.54);
        a = "ir"
        disp(ir)
       
        if ((u(4)-u(1)) > 13) ||  ir> 250 %% ((u(4)-ir_cm)> 30 && (u(4)-ir_cm)<40)
            if (u(1)<10) || ir > 200
                if (u(1) < 6) || ir > 400
                    fwrite(s, '9');
                    pause(0.5)
                    fwrite(s, 'u');
                    pause(5);
                    fwrite(s, 'o');
                    pause(2);
                    fwrite(s, 'i');
    
                    blockfound = 1
                elseif (u(4) > 8 ) && (u(3) > 3) && (u(2) > 3) 
                    fwrite(s, 'm');
                    readings = fscanf(s);
                end
            else
                if (u(4) > 12 ) && (u(3) > 7) && (u(2) > 7)
                    fwrite(s, 'f');
                    readings = fscanf(s);
                end
            end
        else
            fwrite(s, '@');
            readings = fscanf(s);
            
            counter = counter + 1;
    
        end
        
    end 
    else
            fwrite(s, '@');
            readings = fscanf(s);
    
            pause(0.5)
            fwrite(s, 'm');
            readings = fscanf(s);
            pause(0.5)
            fwrite(s, 'm');
            readings = fscanf(s);
            pause(0.5)
            fwrite(s, 'm');
            readings = fscanf(s);
    
            counter = 0;
    
    end
    
    end
    
    end
    
    end
end
