%% Last Updated 2/24/2021 JM
%Todo: Implement a filter for bad cells in the initial data processing
    %Idea for filter: remove responses below -2 and above 2
%Todo: Use keita's method for bootstrapping confidence interval on CDF
%points. Bootstrap from individual responses instead of single cell average

%This script is meant to be used to analyze data output by
%"FretDataExtractionAndProcessing" by K.K. 

%System parameters can be changed in 'parameters.m'.
%Path to datasets can be selected in 'datasets.m'. Plotting parameters must
%also be selected in this document. 

%% Add necessary functions to the PATH
close all; clear all;
addpath('./Functions')
parms = parameters(); %Struct containing system parameters
showPlot = parms.showPlot;

%% Datasets: Load 
dataparms = datasets(); %Load data parameters
backConc = dataparms.backConc;
xlabels = dataparms.xlabels;
Lplot = dataparms.Lplot;
Files = dataparms.Files;
OutFolder = dataparms.OutFolder; 
concLevels = dataparms.concLevels;

%% Make output destination
OutputDest = ['./Outputs/', OutFolder];
mkdir(OutputDest)

%% Initial data processing/reformatting
EfretData = combineFretFiles(Files); %Combine files into one dataset
n = length(concLevels); %Number of stimulus levels
m = min(round(size(EfretData(1).A, 1)./n), parms.m); %Number of responses per stim level

%Reformat data into a struct with n matrices with m measurements each
doseData = reorganizeData(EfretData, n, m);

%Calculate response-amplitude for each individual stimulus
doseData = calcResponseAmp2(doseData, n, parms);

%Calculate population-average and single-cell dose-response data
[popAvgData, SCAvgData] = calcPopAvgDoseResponse2(doseData, parms);

%% Distribution of dynamic ranges
%Find EfretMax - EfretMin and (EfretMax - EfretMin) / EfretMin
FretRangeData = findRangeDistribution(EfretData, OutputDest);

%% Plot FRET Time-series
plotFRETTimeSeries(EfretData, dataparms, parms, OutputDest);

%% Fit hill function to population-average dose-response data
%Collect dose-response data, and optimal parameters for hill function
HillPlotData = fitHillFunction(popAvgData, SCAvgData, dataparms, parms, OutputDest);

%% Fit CDF
CDFPlotData = fitLogNormCDF(SCAvgData, dataparms, parms, OutputDest);

%% Save Information for Recreating Plots Elsewhere
save([OutputDest, 'plotData.mat'], "HillPlotData", "CDFPlotData", "FretRangeData");

%% End
% close all; 

