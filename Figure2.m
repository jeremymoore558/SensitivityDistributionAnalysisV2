%% Last updated 2/25/2021 JM
close all; clear;
addpath('./Functions')
%List of output directories with MeAsp dose-response curves
Files1 = ["./Outputs/210215_NoBackgroundMeAspDose/",...
        "./Outputs/210216_100MeAspBackgroundMeAspDose/", ...
        "./Outputs/210217_1SerBackgroundMeAspDose/"];
legend1 = ["0", "MeAsp", "Ser"];

%List of output directories with Ser dose-response curves
Files2 = ["./Outputs/210218_NoBackgroundSerDose/",...
        "./Outputs/210223_100MeAspBackgroundSerDose/", ...
        "./Outputs/210222_1SerBackgroundSerDose/"];

%% Plot sensitivity distributions:
plotSensitivityDistribution(Files1, legend1, Files2)
JMAxes
savefig(gcf, ['./Outputs/Figure2.fig'])
saveas(gcf, ['./Outputs/Figure2.png'])

%% Plot FretRange distributions for all experiments
plotFretRandDistribution(Files1, legend1, Files2)
JMAxes

