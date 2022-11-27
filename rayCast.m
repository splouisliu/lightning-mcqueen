function ranges = rayCast(map, pose, angles)
    % Outputs the sensor measurements (6 rays) for a given pose
    
    intersectionPoints = rayIntersection(map, pose, angles, 108);

    for i=1:size(intersectionPoints, 1)
        ranges(i) = norm(intersectionPoints(i,1:2) - pose(1:2));
    end
end