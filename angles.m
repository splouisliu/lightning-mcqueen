function closest_angle = angles(compass)
    anglese = [0,90,180,270,360];
    smallest_diff = 1000;
    closest_angle = 0;
    
    for angle = anglese
        diff = abs(angle-compass);
        if diff < smallest_diff 
            smallest_diff = diff;
            closest_angle = angle;
        end
    end
    if closest_angle == 360
        closest_angle = 0 ;
    end
end