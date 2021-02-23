function HillPlotData = fitHillFunction(popAvgData, SCAvgData, dataparms, parms, OutputDest)
    %% Fit hill function to data
    DoseResp = popAvgData.meanRnorm; %Dose-response data
    sigma = popAvgData.stdRnorm; %Standard deviation of measurements
    p0 = dataparms.Hillp0; %initial guess for parameters
    backConc = dataparms.backConc; %Background concentration of experiment
    concLevels = dataparms.concLevels; %Attractant concentrations measured
    
    %Equation for decreasing hill function. p(1) = log n, p(2) = log Kd, p(3) =
    %scaling factor
    y = @(p, x) p(3) * (1./ (1 + (x./exp(p(2))).^exp(p(1))) - 1);
    
    %Inverse log-posterior. Here, is just likelihood
    inv_log_post = @(p) -(sum(-(1/2*sigma.^2) .* (DoseResp - y(p, concLevels)).^2));
    
    %Minimize log likelihood
    p_opt = fminunc(inv_log_post, p0);
    
    % Log posterior with priors
    %Current priors are that:
        %n ~ N(n_ML, n_ML) (CV = 1)
        %K ~ N(K_ML, K_ML) (CV = 1)
        %A ~ U(0, 2)
    log_post = @(p) (sum(-(1/2*sigma.^2) .* (DoseResp - y(p, concLevels)).^2)) +...
        log(normpdf(p(1), p_opt(1), p_opt(1))) + log(normpdf(p(2), p_opt(2), p_opt(2))) + log(unifpdf(p(3), 0, 2));

    
    %% Evaluate posterior distribution to find error bars on parameters
    rnd = slicesample(p0, parms.nSamples, 'logpdf', log_post, 'thin', parms.thining);
   
        %% Plot MCMC samples
    figure(); hold on
    subplot(3, 2, 1)
    plot(rnd(:, 1))
    ylabel("log n")
    subplot(3, 2, 2)
    histogram(rnd(:, 1))
    xlabel("log n")
    
    subplot(3, 2, 3)
    plot(rnd(:, 2))
    ylabel("log K_{1/2}")
    subplot(3, 2, 4)
    histogram(rnd(:, 1))
    xlabel("log K_{1/2}")
    
    subplot(3, 2, 5)
    plot(rnd(:, 3))
    ylabel("A")
    subplot(3, 2, 6)
    histogram(rnd(:, 3))
    xlabel("A")
    
    %Save Figure in Output Destination
    savefig(gcf, [OutputDest, 'HillMCMC.fig'])
    saveas(gcf, [OutputDest, 'HillMCMC.png'])


    %% Plot fit
%     p_opt = median(rnd);
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
    savefig(gcf, [OutputDest, 'HillFit.fig'])
    saveas(gcf, [OutputDest, 'HillFit.png'])
    
    
    %% Assemble Data for Easy Plotting Elsewhere
    HillPlotData.concLevels = concLevels;
    HillPlotData.backConc = backConc;
    HillPlotData.p_opt = p_opt;
    HillPlotData.ssDoseResp = ssDoseResp;
    HillPlotData.PopAvgDoseResp = DoseResp;
    HillPlotData.PopAvgDoseStd = sigma;

    
end