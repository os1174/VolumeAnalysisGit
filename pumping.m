function [upStrokeExtract, pumpSeconds, NumStrokes, dataPointer, volumeComparisonXLpumping] = pumping(finalFAM, startDatapointer)
% function [upStrokeExtract, pumpSeconds, NumStrokes, dataPointer] = pumping(finalFAM,startDatapointer)
% Accumulates the downward movement of the handle and the timestamps of the
% movement. This function recreates the calculation of the number of
% strokes. Lines 325-385 of main.c. We already have the angles at 102 Hz to
% replicate the rate that we gather the angle.

pumpStartTime = finalFAM(startDatapointer,1);
pumpEndTime = 0;
[numDatapoints,c] = size(finalFAM);


%%% Variable Definitions
i = startDatapointer;
pumpSeconds = 0;

dispensing = 1;     %We assume we are dispensing when we get here and assume there is water here
anglePrevious = finalFAM(startDatapointer,2);
angleCurrent = finalFAM(startDatapointer,2);
angleDelta = 0;             %Stores the difference between the current and previous angles
upStrokeExtract = 0;
StrokeupStrokeExtract = 0; % This is the value using the stroke start and stop

angleThresholdSmall = 0.3;  %number close to 0 to see if the handle is moving and ignoring accelerometer noise
stopped_pumping_index = 0;  
max_pause_while_pumping = 102;      %This is 1 second at our sampling rate

StrokeStarting = 0;         %Binary indicating that a new pumping stroke has begun
strokeStartingAngle = angleCurrent;
NumStrokes = 0;             %The number of pumping strokes dispensing water
StrokeOver = 0;             %Binary indicating that the latest pumping stroke has ended
MinStrokeRange = 10;        %degrees, roughly moving handle through 10"

MaxUp = angleCurrent;       %Top of the latest pumping stroke
MaxDown = angleCurrent;     %Bottom of the latest pumping stroke

%%%%% Script
while dispensing && i < numDatapoints   %we assume water is there
    i = i + 1;
    angleCurrent = finalFAM(i,2);
    angleDelta = angleCurrent - anglePrevious;  % determines the amount of handle movement from last reading
    anglePrevious = angleCurrent;               %Prepares anglePrevious for the next loop

    % Has the handle stopped moving?
    if((angleDelta > (-1*angleThresholdSmall)) && (angleDelta < angleThresholdSmall))   %Determines if the handle is at rest
        stopped_pumping_index = stopped_pumping_index + 1; %we want to stop if the user stops pumping
        if((stopped_pumping_index) > max_pause_while_pumping)  % They quit trying for at least 1 second
            dispensing = 0; %No longer moving the handle
            if(StrokeStarting == 1)
                NumStrokes = NumStrokes + 1;   %They stopped on a pumping stroke
            end
        end
    else
        stopped_pumping_index=0;   %they are still trying
    end
    if(angleDelta < 0)      %Determines direction of handle movement
        upStrokeExtract = upStrokeExtract + (-1) * angleDelta;       %If the valve is moving downward, the movement is added to upstrokeExtract
        if(angleCurrent < MaxUp-MinStrokeRange )    %A new stroke may be starting
            if(StrokeStarting==0)               %Yes this is the start of a new stroke
                StrokeStarting = 1;
                strokeStartingAngle = MaxUp;
                StrokeOver = 0;
                MaxDown = angleCurrent;
            end
        end
        if(angleCurrent < MaxDown)
            MaxDown = angleCurrent;     %Still lifting water
        end
    else %The handle is not lifting water
        if(angleCurrent > MaxDown + MinStrokeRange)   %Pumping stroke may be finished
            if(StrokeOver == 0)     %Yes the pumping stroke is complete
                StrokeOver = 1;
                if(StrokeStarting == 1)
                    NumStrokes = NumStrokes + 1;
                    StrokeDelta = abs(strokeStartingAngle - angleCurrent);
                    StrokeupStrokeExtract = StrokeupStrokeExtract + StrokeDelta;
                    message = sprintf('Stroke Number %0.d Start Angle = %0.2f, stop angle = %0.2f, delta angle = %0.2f \n', NumStrokes, strokeStartingAngle, MaxDown, StrokeDelta);
                    % for debug disp(message);
                    StrokeStarting = 0;
                end
                MaxUp = angleCurrent;
            end
            if(angleCurrent > MaxUp)
                MaxUp = angleCurrent;
            end
        end
    end    
end
%Pumping has stopped
pumpSeconds = (finalFAM(i, 1) - pumpStartTime) - 1;  % We wait 1 sec before we say we have stopped pumping
dataPointer = i;  % this is where in the recorded data this pumping event ended

volumeEvent = 0;
volumeEventStroke = 0;

[volumeEvent] = CalculateVolume(upStrokeExtract,pumpSeconds); % Find volume lifted based on increment movement
[volumeEventStroke] = CalculateVolume(StrokeupStrokeExtract,pumpSeconds); % Find volume lifted
volumeComparisonXLpumping = 0;

if NumStrokes > 1
    %trialExcelTable = {'Number of Strokes', 'Extract Angle', 'Volume Pumped', 'Start Time', 'End Time'; NumStrokes,upStrokeExtract, volumeEvent, pumpStartTime,pumpSeconds};
    %writecell(trialExcelTable,'SimulatedTrialComparison_WC2_102.xls','Sheet','BPT_Reg_1','Range','B2');
    
    volumeComparisonXLpumping = {'Number of Strokes', 'Increment Extract Angle', 'Volume Pumped Increment', 'Stroke Extract Angle', 'Volume Pumped Stroke', 'Start Time', 'End Time'; NumStrokes,upStrokeExtract, volumeEvent, StrokeupStrokeExtract, volumeEventStroke, pumpStartTime,pumpSeconds};
    message = sprintf(' SIM:\n Num Strokes = %0.d \n ExtractAngle = %0.2f degrees \n Stroke Extract Angle = %0.2f degrees \n Volume Pumped = %0.2f L \n Started Pumping at %0.2f for %0.2f sec \n',NumStrokes,upStrokeExtract, StrokeupStrokeExtract, volumeEvent, pumpStartTime,pumpSeconds);
    %disp(message);
    %disp(size(volumeComparisonXLpumping));
    if isequal(size(volumeComparisonXLpumping), [2,7])
        volumeComparisonXL = volumeComparisonXLpumping;
    end
else
    volumeComparisonXL = {0;0};
end
end