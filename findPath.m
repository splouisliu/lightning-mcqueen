function [pathf, pathincdices] = findPath(pose, final_destination)
    poseRC = [50-pose(2)+1, pose(1)];
    indRC = floor((poseRC-2)/12 + 1);
    x = indRC(1);
    y = indRC(2);
    localized_heading = rad2deg(wrapTo2Pi(pose(3)));


    M=8;N=4; %grid dimensions
    simple_maze = reshape(1:M*N,M,N)' ;
    A = ones(M,N) ;
    A(5,1) = 0;
    A(7,1) = 0;
    A(3,2) = 0;
    A(2,3) = 0;
    A(4,3) = 0;
    A(5,3) = 0;
    A(7,3) = 0;
    A(7,4) = 0;
    
    Maze = A'.*simple_maze;
    loca_index = Maze(x,y);
    
    load("G_pathfind.mat");

    path = shortestpath(G,loca_index,final_destination);
    
    if length(path) == 1
        pathf = "";
        pathincdices = [];
    else
        pathincdices = [];
        for i = 1:length(path)
            [x_index,y_index]=find(Maze==path(i));
            pathincdices = [pathincdices; [x_index y_index]] ;
        end
        
        heading_path = [];
        for step_path = 1 : length(pathincdices)-1
            res1 =  pathincdices(step_path,1) - pathincdices(step_path+1,1);
            res2 = -pathincdices(step_path,2) + pathincdices(step_path+1,2);
            heading_path = [heading_path atan2d(res1,res2)];
        end
        
        for i = 1 : length(heading_path)
            if heading_path(i) == -90
                heading_path(i) = 270;
            elseif heading_path(i) == -180
                heading_path(i) = 180;
            end
        end 
        
        % align heading with intial path
        localized_heading = angles(localized_heading);
        diff = heading_path(1) - localized_heading ;
        pathf = [];
        if diff == 0
            %forward only
        elseif diff == -90 || diff == 270 
            pathf = [pathf,"rotate -90"];
        elseif diff == 90 || diff == -270
            pathf = [pathf,"rotate 90"];
        elseif diff == 180 || diff == -180
            pathf = [pathf,"rotate 180"];
        end
        pathf = [pathf,"forward"];
    
        % get directions for rest of path
        diff = heading_path(1) ;
        for i = 2:length(heading_path)
            diff = heading_path(i) - diff ;
            if diff == 0
                %forward only
            elseif diff == -90 || diff == 270 
                pathf = [pathf,"rotate -90"];
            elseif diff == 90 || diff == -270
                pathf = [pathf,"rotate 90"];
            elseif diff == 180 || diff == -180
                pathf = [pathf,"rotate 180"];
            end
            pathf = [pathf,"forward"];
        
            diff = heading_path(i);  
        end
    end
end 