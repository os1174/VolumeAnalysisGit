function [rawDataMatrix, rawSampleRate] = readRawData(rawDataFile)
% this function reads data from an excel spreadsheet created by Digilent
% and outputs a matrix with timestamps and X/Y voltage readings
%
% inputs
%   rawDataFile = the name of the excel file with the raw pumping information
% output
%   rawDataMatrix = an N x 3 matrix in the following format
%       c1 = timestamp
%       c2 = xVoltage
%       c3 = yVoltage

rawSampleRate = 1600;  % Test Stub
A = readmatrix(rawDataFile);
disp(A);
rawDataMatrix = num;

end