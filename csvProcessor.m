clear all
close all
clc

%% Zambia Data
folder = 'C:\Users\opeas\OneDrive - Messiah University\000 ENGR415 Collab\300 Fall23\Volume Changes\Volume Field Data\';
testNum = {'day19_trial1',...        %fileVec is a cell
    'day19_trial3',...
    'day19_trial4',...
    'day19_trial5',...
    'day19_trial6',...
    'day19_trial7',...
    'day19_trial8'};

%% Bitner Data
% folder = 'C:\Users\opeas\OneDrive - Messiah University\000 ENGR415 Collab\300 Fall23\Volume Changes\VolumeAnalysisGit\BitnerPumpTests102\';
% testSampRate = 'BitnerPumpTest_102_';
% testNum = {'1_Fast',...        %fileVec is a cell
%     '1_JP',...
%     '1',...
%     '1_Slow',...
%     '2_Fast',...
%     '2_JP',...
%     '2',...
%     '2_Slow',...
%     '3_Fast',...
%     '3_JP',...
%     '3',...
%     '3_Slow',...
%     '4'};
% scope = '_Scope.csv';
%protocol = '_Protocol.txt';

[r,c] = size(testNum);

for i=1:c
    % Working with Zambia data
    name = [folder,testNum{i}];  %folder, testSampleRate, Number and speed, scope or protocol
    display(testNum{i});

    % Working with bitner data:
    % name = [folder,testSampRate,testNum{i},scope];  %folder, testSampleRate, Number and speed, scope or protocol
    % display(testNum_Speed{i});
    
    %Run scope data through program
    [volumeComparisonXL] = VolumeAlgorithmAnalysis(name);
    %debug disp(size(volumeComparisonXL));

    if isequal(size(volumeComparisonXL), [2,7])
        writecell(volumeComparisonXL,'StrokeIncrementComparison.xlsx','Sheet', testNum{i},'Range','B2');
    end
end


%VolumeAlgorithmAnalysis('C:\Users\opeas\OneDrive - Messiah University\000 ENGR415 Collab\300 Fall23\Volume Changes\VolumeAnalysisGit\BitnerPumpTests102\BitnerPumpTest_102_1_Fast_Scope.csv')