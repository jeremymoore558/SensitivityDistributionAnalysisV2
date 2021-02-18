function HillPlotData = fitHillFunction(popAvgData, SCAvgData, dataparms, parms, OutputDest)
    %% Fit hill function to data
    DoseResp = popAvgData.meanRnorm; %Dose-response data
    sigma = popAvgData.stdRnorm; %Standard deviation of measurements
    p0 = dataparms.Hillp0; %initial guess for parameters
    backConc = dataparms.backConc; %Background concentration of experiment
    concLevels = dataparms.concLevels; %Attractant concentrations measured
    
    %Equation for decreasing hill function. p(1) = n, p(2) = Kd
    y = @(p, x) 1 ./ (1 + (x./exp(p(2))).^exp(p(1))) - 1;
    
    %Inverse log-posterior. Here, is just likelihood
    inv_log_post = @(p) -(sum(-(1/2*sigma.^2) .* (DoseResp - y(p, concLevels)).^2));

    %Minimize log likelihood
    p_opt = fminunc(inv_log_post, p0);
    
    %% Plot fit
    ssDoseResp = SCAvgData.ScMeanRnorm;
    Lplot = dataparms.Lplot;
    
    figure('visible', parms.showPlot);
    hold on;
    %Plot single-cell dose-responses as points
    for i = 1:size(ssDoseResp, 1)
        plot(concLevels, ssDoseResp(i, :), '.', 'MarkerSize', 10, 'Color', [0.8 0.8 0.8])
    end
    
    %Plot fitted line
    plot(Lplot, y(p_opt, Lplot), 'linewidth', 3, 'Color', parms.lineColor)
    
    %Plot error bars on population-average measurements
    errorbar(concLevels, DoseResp, sigma/sqrt(size(ssDoseResp, 1)), 'o', 'MarkerSize', 5, 'Linewidth', 1.5, 'Color', parms.lineColor)

    xlim([min(Lplot), max(Lplot)])
    ylim([-1.5, 0.5])
    set(gca, 'xscale', 'log')
    
    p_text = exp(p_opt);
    title(['n = ', num2str(p_text(1)), ' | K = ', num2str(p_text(2))])
    
    %Axis labels
    xlabel(dataparms.xlabels);
    ylabel("\langle a \rangle")
    
    %Save Figure in Output Destination
    savefig(gcf, [OutputDest, 'CDFFit.fig'])
    saveas(gcf, [OutputDest, 'CDFFit.png'])
    
    %% Assemble Data for Easy Plotting Elsewhere
    HillPlotData.concLevels = concLevels;
    HillPlotData.backConc = backConc;
    HillPlotData.p_opt = p_opt;
    HillPlotData.ssDoseResp = ssDoseResp;
    HillPlotData.PopAvgDoseResp = DoseResp;
    HillPlotData.PopAvgDoseStd = sigma;

    
end