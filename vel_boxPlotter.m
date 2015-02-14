%% cat together a bunch of velocity files and run stats

[video_name, pathname] = uigetfile({'*.csv;*', ...
    'Comma-separated values (*.csv)'}, ...
    'Select a set of flypath files (created by "larva_velocity.m")...', 'MultiSelect','on');
if (pathname ~= 0)
    inputFiles = strcat(pathname,video_name);
else
    break;
end

%read file and calculate stats for each...
if (isa(inputFiles,'char'))
    inputFiles = {inputFiles};
end
num_files = length(inputFiles);
plotData = zeros(100,num_files);
plotData(:) = NaN;
for fileNum = 1:num_files
    rep_new = csvread(char(inputFiles(fileNum)));
    
    %calc avg velocity
    avgVel = zeros(size(rep_new,2),1);
    for col = 1:size(rep_new,2)
        velData = rep_new(:,col);
        avgVel(col) = mean(velData(~isnan(velData)));
    end
    plotData((1:length(avgVel)),fileNum) = avgVel;
end

%% now make a box plot

figure('Name', strcat('Velocity'));
plotLabel = inputFiles;
% remove the path from the labels, if present
for barNum = 1:length(plotLabel)
    barLabel = char(plotLabel(barNum));
    ind = strfind(barLabel, '/');
    if isempty(ind)
        plotLabel(barNum) = {barLabel};
    else
        plotLabel(barNum) = {barLabel(ind(length(ind))+1:length(barLabel))};
    end
end
% remove '.csv' from the labels, if present
for barNum = 1:length(plotLabel)
    barLabel = char(plotLabel(barNum));
    ind = strfind(barLabel, '.csv');
    if isempty(ind)
        plotLabel(barNum) = {barLabel};
    else
        plotLabel(barNum) = {barLabel(1:ind(length(ind))-1)};
    end
end
boxplot(plotData, ...
    'labels', plotLabel);
ylim([0 (max(max(plotData)) + 0.1)]);
ylabel(strcat('Average velocity (mm/s) '), 'fontsize', 11);
