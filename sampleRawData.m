function [sampledDataMatrix] = sampleRawData(rawDataArray,desSampleRate)
% function [sampledDataMatrix] = sampleRawData(desDataMatrix)
%This function samples the raw data which was collected at a variable
%sample rate at the rate specified by desSampleRate (102Hz)
% rawDataMatrix: an Nx3 matrix with the X/Y voltages as collected by
%                Digilent
% desSampleRate:  the sampling rate used by system for live sampling
% sampledDataMatrix: an Nx3 matrix with the X/Y voltages spaced as close to 
%                    the desired sampling rate as possible given the 
%                    sampling rate used to gather the raw data

atdStepSize = 3.3/1024;     %Voltage we are working with divided by 2^10
deltaTime = 1/desSampleRate;
nxtSampleTime = rawDataArray(1,1);  % this is an initial value              %%%%%%%%%%
rawDataArray(:,1) = rawDataArray(:,1) - nxtSampleTime; %fixing time skew from waveforms scope
[r,c] = size(rawDataArray);
i = 1;
k = 1;
while i < r
    if rawDataArray(i,1) >= nxtSampleTime
        sampledDataMatrix(k,1)=rawDataArray(i,1);
        sampledDataMatrix(k,2)= floor(rawDataArray(i,2)/atdStepSize);
        sampledDataMatrix(k,3)= floor(rawDataArray(i,3)/atdStepSize);
        k = k+1;
        nxtSampleTime = nxtSampleTime + deltaTime;
    end
    i = i+1;
end
        
end