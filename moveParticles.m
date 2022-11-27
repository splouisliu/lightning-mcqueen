function newParticles = moveParticles(map, noiseStd, particles, du)
    % Follows the odometry noise model here: 
    % https://www.eecs.yorku.ca/course_archive/2017-18/W/4421/lectures/Odometry%20motion%20model.pdf
    
    N = size(particles, 1);
    
    measured_rot1 = atan2(du(2), du(1)) - particles(:, 3);
    measured_rot2 = du(3) - measured_rot1;
    measured_trans = zeros(N, 1) + sqrt(du(1)^2 + du(2)^2);
    
    noisy_rot1 = measured_rot1 - randn(N, 1) * noiseStd(1);
    noisy_rot2 = measured_rot2 - randn(N, 1) * noiseStd(2);
    noisy_trans = measured_trans - rand(N, 1) * noiseStd(3);
    
    new_x = particles(:, 1) + noisy_trans .* cos(particles(:, 3) + noisy_rot1);
    new_y = particles(:, 2) + noisy_trans .* sin(particles(:, 3) + noisy_rot1);
    new_r = particles(:, 3) + noisy_rot1 + noisy_rot2;
    
    % Rotate
    dx = (new_x - particles(:,1));
    dy = (new_y - particles(:,2));
    new_x = dx .* cos(particles(:,3)) - dy .* sin(particles(:,3)) + particles(:,1);
    new_y = dx .* sin(particles(:,3)) + dy .* cos(particles(:,3)) + particles(:,2);
    
    % Filter out of bound particles
    newParticles = [];
    
    for i=1:N
        if ~checkOccupancy(map, [new_x(i) new_y(i)])
            newParticles(end+1, :) = [new_x(i), new_y(i), new_r(i)];
        end
    end
end