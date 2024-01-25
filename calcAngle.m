function [angleMatrix] = calcAngle(rawDataMatrix)
% function [angleMatrix] = calcAngle(rawDataMatrix)
% This function will convert the x-y sensor voltages into a handle angle in
% degrees
% rawDataMatrix: Nx3 matrix with C1-time, C2-y, C3-x
% angleMatrix: Nx2 matrix with the time and angle in degrees

[r,c] = size(rawDataMatrix);
angleMatrix = zeros(r,2);
angleMatrix(:,1) = rawDataMatrix(:,1); % copy over the time stamps
angleMatrix(:,2) = atan2(rawDataMatrix(:,2),rawDataMatrix(:,3)); % angle in radians

% Need to make this in degrees
angleMatrix(:,2) = angleMatrix(:,2) * 57.29579143313326; %180/pi

end