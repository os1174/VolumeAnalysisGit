function[volumeComparisonXLVAA] = VolumeAlgorithmAnalysis(dataFile)


%GET TIMESTAMP OF PEAK AND ACTUAL POSITION WHEN IT HIT PEAKS

%PUT DIGILENT CHANNEL 1 ON Y AND CHANNEL 2 ON X

%Specify Excel file that contains the raw data
rawDataArray = readmatrix(dataFile);
%Specify the sampling rate used by the system.  For example 102 = 102Hz
desSampleRate = 102;

%Reading in txt file of protocol (x,y,angle)
% protocol2 = fscanf(fopen('BitnerPumpTest_3_Protocol.txt'),'%f \n');
% %Add time stamps to the protocol data
% % protocol2 = protocol2';
% [r,c] = size(protocol2);
% i = 1;
% protocol = zeros(r, 2);
% protocol(:, 2) = protocol2(:, 1);
% while i <= r
%     protocol(i,1) = (i-1)*(1/desSampleRate);         % 0.02 = (50Hz)^-1
%     i = i + 1;
% end


%%% When changing excel files, change lines 7 and 10 of main and line 88 of pumping


% Extract the X/Y voltages and populate a matrix
% [rawDataMatrix, rawSampleRate] = readRawData(rawDataFile);
% % % plot(rawDataArray(:,1),rawDataArray(:,2),rawDataArray(:,1),rawDataArray(:,3));
% % % title('Raw HMS data as sampled by Digilent');
% % % xlabel('time in sec');
% % % ylabel('volts');
% % % legend('x axis','y axis');

% Digilent sampled faster than our expected sampling rate of 102Hz
% downsample to create a data matrix which contains the voltages
% we would get in real time

sampledDataMatrix = sampleRawData(rawDataArray, desSampleRate);
% % % figure(2);
% % % plot(sampledDataMatrix(:,1),sampledDataMatrix(:,2),sampledDataMatrix(:,1),sampledDataMatrix(:,3));
% % % plotTitle = sprintf('Raw HMS data sampled at %d Hz',desSampleRate);
% % % title(plotTitle);
% % % xlabel('time in sec');
% % % ylabel('ATD Out');
% % % legend('x axis','yaxis');

% At this point we have the voltages measures by the HMS
% we now need to determine the measured angle of the handle.
angleMatrix = calcAngle(sampledDataMatrix);
% figure(3);
% plot(angleMatrix(:,1),angleMatrix(:,2));
% title('Unfiltered HMS angle');
% xlabel('time in sec');
% ylabel('Angle in degrees');

% We now have the unfiltered angle.  We need to apply a Low Pass Filter
% to clean up noise from shaky handle and collision with the stops
finalFAM = filterHMS(angleMatrix);


% We now have the handle angle processed as it would be as it is evaluated
% in real time by the system.
%
% We now need to look for the handle to begin moving and when it does, 
% analyze and report volume pumped.
% we will assume that the pump is already primed so that handle motion 
% indicates that water is starting to flow.
[numDatapoints,c] = size(finalFAM);
dataPointer = 1;

volumeComparisonXLVAA = 0;

while dataPointer < numDatapoints
    angleAtRest = finalFAM(dataPointer,2);  % Get the angle of the pump handle to measure against.  
                                            % This is our reference when looking for sufficient movement to say the handle is actually moving.  
                                            % the "moving" threshold is defined by handleMovementThreshold in IWPUtilities
    handleMovement = 0;              % Set the handle movement to 0 (handle is not moving)
	while handleMovement == 0 && dataPointer < numDatapoints
        [handleMovement] = HasTheHandleStartedMoving(angleAtRest, finalFAM(dataPointer,2));
   	    dataPointer = dataPointer + 1;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The handle has started pumping
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [upStrokeExtract, pumpSeconds, NumStrokes,dataPointer, volumeComparisonXL] = pumping(finalFAM,dataPointer);
    if isequal(size(volumeComparisonXL), [2,7])
        volumeComparisonXLVAA = volumeComparisonXL;
    end
    %debug disp(size(volumeComparisonXL));
end
end

