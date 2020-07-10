% The following code is for generating the bar charts seen within the
% 'Optimisation in parameter fitting for Pandemoc Modelling' presentation
% Written by Jack Collins of NUI Galway, July 2020
clear all;
read = readtable('Data/CovidStatisticsProfileHPSCIrelandOpenData.csv');      % Read in data to table
narrow = table2array(read(:,4:8));                                          %Selects the few coloumns needed friom the table
DateMatrix = table2array(read(:,3));                                        % Isolates the dates
formatIN = ('yyyy/mm/dd');                                                  % Set up format for datenum
DateSerial = datenum(DateMatrix, formatIN);                                 % Converts dates to figures
Date = (DateSerial - DateSerial(1));                                        % Calculates days since day 1
Cases = (narrow(:,1));                                                      % Extract daily new cases data
Smooth = smoothdata(Cases, 'gaussian', 7);                                  % Reduce the noise present in the data
%% Plot the results
figure(2);
bar(Date,Cases);
title('Real Time Irish Data');
ylabel('New Casses');
xlabel('Day');
grid on;

figure(3);
bar(Date,Smooth, 'c');
ylim([0 1000]);
title('Real World Noise Reduced Irish Data');
ylabel('New Casses');
xlabel('Day');
grid on;
