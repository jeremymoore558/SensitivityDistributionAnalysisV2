function CDFPlotData = fitLogNormCDF(SCAvgData, dataparms, parms, OutputDest)
    %% Fit Log-normal CDF to data
    singleCellRnorm = SCAvgData.ScMeanRnorm;
    concLevels = dataparms.concLevels;
    
    %Calculate percent of cells that respond less than half-maximally
    lessThanHalf = sum(singleCellRnorm < -0.5, 1); 
    CDFPoints = lessThanHalf./size(singleCellRnorm, 1);
    
    p0 = dataparms.Normp0;
    fitfun = @(b, L) logncdf(L, b(1), b(2)); %b(1) = meanKhalf, b(2) = variance
    inv_log_post = @(p) -(sum(-(CDFPoints - fitfun(p, (concLevels))).^2));
    p_opt2 = fminunc(inv_log_post, p0);
    
    %% Plot CDF Fit
    Lplot = dataparms.Lplot;
    figure('visible', parms.showPlot)
    hold on
    plot(Lplot, fitfun(p_opt2, Lplot), 'linewidth', 3, 'Color', parms.lineColor)
    plot(concLevels, CDFPoints, 'o', 'MarkerSize', 5, 'Color', parms.lineColor)
    xlim([min(Lplot), max(Lplot)])
    set(gca, 'xscale', 'log')
    
    %Axis labels
    xlabel(dataparms.xlabels)
    ylabel("P[R < 0.5]")
    xlim([min(Lplot), max(Lplot)])
    ylim([0, 1])
    
    %Save Figure in Output Destination
    savefig(gcf, [OutputDest, 'HillFit.fig'])
    saveas(gcf, [OutputDest, 'HillFit.png'])

    
    %% Save optimal parameters
    CDFPlotData.p_opt = p_opt2;
    CDFPlotData.Lplot = Lplot;
    CDFPlotData.concLevels = concLevels;
    CDFPlotData.CDFPoints = CDFPoints;
    
end