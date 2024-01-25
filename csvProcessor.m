clear all
clc all

files = dir('C:\Users\opeas\OneDrive - Messiah University\000 ENGR415 Collab\300 Fall23\Volume Changes\VolumeAnalysisGit\BitnerPumpTests102/*.csv');
for file = files
    load(file.name)
end