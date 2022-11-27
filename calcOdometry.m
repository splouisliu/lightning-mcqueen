function du = calcOdometry(response)
    global odomModel;
    
    % Calculate odometry
    encoderMeasurements = double(split(strtrim(convertCharsToStrings(response)), ","));
    encoderMeasurements = [-encoderMeasurements(2), encoderMeasurements(1)];
    
    du = odomModel(encoderMeasurements);
    release(odomModel);
    odomModel.InitialPose = [0, 0 , 0];
end