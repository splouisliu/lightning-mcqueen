function [map, thiccMap] = initializeMap()
    map = binaryOccupancyMap(98, 50, 1);

    for i=1:98
        setOccupancy(map, [[i 1]], 1);
        setOccupancy(map, [[i 50]], 1);
    end
    for i=1:50
        setOccupancy(map, [[1 i]], 1);
        setOccupancy(map, [[98 i]], 1);
    end
    
    occupiedAreas = 1 + [13, 13, 24, 24;...
                         25, 25, 36, 36;...
                         37, 13, 60, 24;...
                         49, 37, 60, 48;...
                         73, 1, 84, 24;... 
                         73, 37, 84, 48];
    
    for i=1:size(occupiedAreas, 1)
        for j=occupiedAreas(i,1):occupiedAreas(i,3)
            for k=occupiedAreas(i,2):occupiedAreas(i,4)
                setOccupancy(map, [[j k]], 1);
            end
        end
    end

    thiccMap = binaryOccupancyMap(map);
    inflate(thiccMap, 4);
end