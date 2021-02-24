%% Last Updated 2/17/2021 JM
%Todo: Implement confidence intervals on CDFPoints using bootstrapping
%Todo: Implement confidence intervals on CDF parameters
%by MCMC Sampling

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

%% Plot FRET Time-series
plotFRETTimeSeries(EfretData, dataparms, parms, OutputDest);

%% Fit hill function to population-average dose-response data
%Collect dose-response data, and optimal parameters for hill function
HillPlotData = fitHillFunction(popAvgData, SCAvgData, dataparms, parms, OutputDest);

%% Fit CDF
CDFPlotData = fitLogNormCDF(SCAvgData, dataparms, parms, OutputDest);

%% Save Information for Recreating Plots Elsewhere
save([OutputDest, 'plotData.mat'], "HillPlotData", "CDFPlotData");

