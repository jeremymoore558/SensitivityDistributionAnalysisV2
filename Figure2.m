%% Last updated 2/25/2021 JM
close all; clear;
%List of output directories with MeAsp dose-response curves
Files1 = ["./Outputs/210215_NoBackgroundMeAspDose/",...
        "./Outputs/210216_100MeAspBackgroundMeAspDose/", ...
        "./Outputs/210217_1SerBackgroundMeAspDose/"];
legend1 = ["0 Background", "100\muM MeAsp", "1\muM Ser"];

%List of output directories with Ser dose-response curves
Files2 = ["./Outputs/210218_NoBackgroundSerDose/",...
        "./Outputs/210223_100MeAspBackgroundSerDose/", ...
        "./Outputs/210222_1SerBackgroundSerDose/"];

    
%% Declare fit functions
CDFFunc = @(p, L) p(3)*logncdf(L, p(1), p(2));
PDFFunc = @(p, L) lognpdf(L, p(1), p(2));

%% Color Palette To Color Each Background
colr = ["#058ED9", "#FF934F", "#CC2D35"];
    
%% Load and plot CDF for all Data
figure()

%MeAsp dose response curves
for i = 1:length(Files1)
    %Load Dataset
    load([convertStringsToChars(Files1(i)), 'plotData.mat'])
    
    %Plot CDF In Top left
    subplot(2,2,1)
    hold on
    C(i) = plot(CDFPlotData.concLevels, CDFPlotData.CDFPoints, 'o', 'color', colr(i));
    plot(CDFPlotData.Lplot, CDFFunc(CDFPlotData.p_opt, CDFPlotData.Lplot), 'color', colr(i), 'Linewidth', 1.8);
    if i == length(Files1)
        xlabel('[MeAsp]')
        ylabel('[P(K_{1/2} < [L])')
        set(gca, 'xscale', 'log')
    end
    
    subplot(2, 2, 3)
    hold on
    y = PDFFunc(CDFPlotData.p_opt, CDFPlotData.Lplot);
    plot(CDFPlotData.Lplot, y./max(y), 'color', colr(i), 'Linewidth', 1.8)
    if i == length(Files1)
        xlabel('[MeAsp]')
        ylabel('[P(K_{1/2} = [L])')
        set(gca, 'xscale', 'log')
    end
end

%Ser Dose-response curves
for i = 1:length(Files2)
    %Load Dataset
    load([convertStringsToChars(Files2(i)), 'plotData.mat'])
    
    %Plot CDF In Top left
    subplot(2,2,2)
    hold on
    C(i) = plot(CDFPlotData.concLevels, CDFPlotData.CDFPoints, 'o', 'color', colr(i));
    plot(CDFPlotData.Lplot, CDFFunc(CDFPlotData.p_opt, CDFPlotData.Lplot), 'color', colr(i), 'Linewidth', 1.8);
    if i == length(Files1)
        xlabel('[Ser]')
        ylabel('[P(K_{1/2} < [L])')
        set(gca, 'xscale', 'log')
        lgnd = legend(C, legend1, 'Position', [.54, .83, .2, .1]); 
        set(lgnd,'color','none');
        legend boxoff
    end
    
    subplot(2, 2, 4)
    hold on
    y = PDFFunc(CDFPlotData.p_opt, CDFPlotData.Lplot);
    plot(CDFPlotData.Lplot, y./max(y), 'color', colr(i), 'Linewidth', 1.8)
    if i == length(Files1)
        xlabel('[Ser]')
        ylabel('[P(K_{1/2} = [L])')
        set(gca, 'xscale', 'log')
    end
end

set(gcf, 'Position', [50, 50, 800, 600])
