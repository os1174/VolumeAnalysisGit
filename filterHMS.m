function [finalFAM] = filterHMS(angleMatrix);
% function [finalFAM] = filterHMS(angleMatrix);
% This function applies a 51 point LPF to the angle calculated from the
% raw HMS voltages
% Note: FAM = filtered angle matrix
% angleMatrix: Nx2 matrix with timestamp and angle in radians
% filteredAngleMatrix: Nx2 matrix with timestamp and the angle in radians
%                      after being filtered by a LPF with a break frequency 
% %                    of 12hz.

% 51 point LPF.  If sampling rate was 102Hz, the Break freq 12hz
filterCoefficients = [-0.000367957739676402;-0.000992862025309093;-0.00125727023156783;
    -0.000855382793229740;0.000381291466321258;0.00213186348631758;	0.00341431457857708;
    0.00294008616327478;0;-0.00461244248435496;-0.00840667052242429;-0.00823385562658572;
    -0.00229960246872353;0.00794391777032297;0.0174286468477092;0.0194370738907819;
    0.00940155627982279;-0.0113043563648819;-0.0339165328651937;-0.0446647433776202;
    -0.0305694595914985;0.0137903275894935;0.0819371051970529;0.156185761049099;
    0.213666144414944;0.235294117647059;0.213666144414944;0.156185761049099;
    0.0819371051970529;0.0137903275894935;-0.0305694595914985;-0.0446647433776202;
    -0.0339165328651937;-0.0113043563648819;0.00940155627982279;0.0194370738907819;
    0.0174286468477092;0.00794391777032297;-0.00229960246872353;-0.00823385562658572;
    -0.00840667052242429;-0.00461244248435496;0;0.00294008616327478;
    0.00341431457857708;0.00213186348631758;0.000381291466321259;-0.000855382793229740;
    -0.00125727023156783;-0.000992862025309093;-0.000367957739676402];

[r,c] = size(angleMatrix);
%Prefill the 51 point angle buffer.  This will behave as though the handle
% was in the first measured position for the previous 50 samples
paddedAngleMatrix = zeros(r + 51 , c);
paddedAngleMatrix(1:51, 2) = angleMatrix(2,2);
paddedAngleMatrix(1:51, 1) = angleMatrix(2,1);
paddedAngleMatrix(52:r+51,:) = angleMatrix;

finalFAM = zeros(r,2);
finalFAM(:,1) = angleMatrix(:,1); % Get the time stamps for the unfiltered angles

% The filter works with 51 points to calculate the filtered value for 
% finalFAM(i).  The oldest point is located at i
i = 1;
while i < r
    angleSum = 0;
        for k = 51:-1:1
            angleSum = angleSum + paddedAngleMatrix(i+51-k, 2) * filterCoefficients(k);
        end
    finalFAM(i,2) = angleSum;
    i = i + 1;
end
plot(finalFAM(:,2));
end