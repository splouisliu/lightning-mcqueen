function newParticles = resample(map, noiseStd, particles, weights, numParticles)
    newParticles = [];
    
    % Sample for indices corresponding to original particles, using weights as sampling probability
    sampledIndices = randsample(size(weights, 2), numParticles, true, weights);
    
    % Apply gaussian noise to each new sampled particle
    particles = particles(sampledIndices, :);
    particles = [randn(numParticles, 1) * noiseStd(1) + particles(:, 1), ...
                 randn(numParticles, 1) * noiseStd(2) + particles(:, 2), ...
                 randn(numParticles, 1) * noiseStd(3) + particles(:, 3)];
    
    % Filter out of bound particles
    for i=1:numParticles
        if ~checkOccupancy(map, [particles(i, 1) particles(i, 2)])
            newParticles(end+1, :) = particles(i, :);
        end
    end
end