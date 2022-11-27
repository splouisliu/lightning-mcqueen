function particles = initializeParticles(map, numParticles)
    temp_x = 1 + rand(numParticles, 1) * (map.XWorldLimits(2)-2);
    temp_y = 1 + rand(numParticles, 1) * (map.YWorldLimits(2)-2);
    temp_r = rand(numParticles, 1) * 2*pi;
    particles = [];
    
    for i=1:numParticles
        if ~checkOccupancy(map, [temp_x(i) temp_y(i)])
            particles(end+1, :) = [temp_x(i), temp_y(i), temp_r(i)];
        end
    end
end