function [likelihood, minNorm] = getLikelihood(map, angles, particles, measurement)
    % First raycasts each particle to receive their simulated measurements.
    % Then compare those against the real measurement using an L2 norm operation
    for i=1:size(particles, 1)
        errorNorm(i) = norm(rayCast(map, particles(i, :), angles) - measurement);
    end
    
    minNorm = min(errorNorm);
    
    % Apply noise to calculate likelihood
    D = size(measurement, 2);
    measurementNoise = eye(D);
    likelihood = 1/sqrt((2*pi).^D * det(measurementNoise)) * exp(-0.5 * errorNorm);
    
    % Normalize
    likelihood = likelihood / sum(likelihood);
end