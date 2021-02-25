function HillPlotData = fitHillFunction(popAvgData, SCAvgData, dataparms, parms, OutputDest)
    %% Fit hill function to data
    DoseResp = popAvgData.meanRnorm; %Dose-response data
    sigma = popAvgData.stdRnorm; %Standard deviation of measurements
    p0 = dataparms.Hillp0; %initial guess for parameters
    backConc = dataparms.backConc; %Background concentration of experiment
    concLevels = dataparms.concLevels; %Attractant concentrations measured
    
    %Equation for decreasing hill function. p(1) = log n, p(2) = log Kd, p(3) =
    %scaling factor
    y = @(p, x) p(3) * (1./ (1 + ((x-backConc)./(exp(p(2)))).^exp(p(1))) - 1);
    
    %Inverse log-posterior. Here, is just likelihood
    inv_log_post = @(p) -(sum(-(1./(2*sigma.^2)) .* (DoseResp - y(p, concLevels)).^2));
    
    %Minimize log likelihood
    p_opt = fminunc(inv_log_post, p0);
    
    % Log posterior with priors
    %Current priors are that:
        %n ~ N(n_ML, n_ML) (CV = 1)
        %K ~ N(K_ML, K_ML) (CV = 1)
        %A ~ U(0, 2)
    log_post = @(p) (sum(-(1./(2*sigma.^2)) .* (DoseResp - y(p, concLevels)).^2)) +...
        log(normpdf(p(1), p_opt(1), (abs(p_opt(1))))) + log(normpdf(p(2), p_opt(2), (abs(p_opt(2))))) + ...
        log(unifpdf(p(3), 0, 3));

    %Log posterior with uniform priors performs worse than gaussian priors
%     log_post = @(p) (sum(-(1/2*sigma.^2) .* (DoseResp - y(p, concLevels)).^2)) +...
%         log(unifpdf(p(1), -3, 3)) + log(unifpdf(p(2), -3, 3)) + ...
%         log(unifpdf(p(3), 0, 3));


    
    %% Evaluate posterior distribution to find error bars on parameters
    rnd = slicesample(p_opt, parms.nSamples, 'logpdf', log_post, 'thin', parms.thining);
    
    %Calculate percentiles
    %Percentile for n
    n_low = exp(prctile(rnd(:, 1), 2.5));
    n_high = exp(prctile(rnd(:, 1), 97.5));
    K_low = exp(prctile(rnd(:, 2), 2.5));
    K_high = exp(prctile(rnd(:, 2), 97.5));
    A_low = prctile(rnd(:, 3), 2.5);
    A_high = prctile(rnd(:, 3), 97.5);
    
    %Find error bars
    n_err = (n_high - n_low) ./ 2;
    K_err = (K_high - K_low)./ 2;
   
        %% Plot MCMC samples
    figure(); hold on

    subplot(3, 2, 1)
    plot(rnd(:, 1))
    ylabel("log n")
    subplot(3, 2, 2)
    histogram(rnd(:, 1))
    line([p_opt(1), p_opt(1)], ylim, 'LineWidth', 1, 'Color', 'r');
    camroll(-90)
    
    subplot(3, 2, 3)
    plot(rnd(:, 2))
    ylabel("log K_{1/2}")
    subplot(3, 2, 4)
    histogram(rnd(:, 2))
    line([p_opt(2), p_opt(2)], ylim, 'LineWidth', 1, 'Color', 'r');
    camroll(-90)
    
    subplot(3, 2, 5)
    plot(rnd(:, 3))
    ylabel("A")
    subplot(3, 2, 6)
    histogram(rnd(:, 3))
    line([p_opt(3), p_opt(3)], ylim, 'LineWidth', 1, 'Color', 'r');
    camroll(-90)
    sgtitle("MCMC samples of the posterior")

    
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
    if backConc ~= 0
        LplotNew = 10.^[log10(backConc):0.01:log10(max(Lplot))];
    else
        LplotNew = Lplot;
    end
    plot(LplotNew, y(p_opt, LplotNew), 'linewidth', 3, 'Color', parms.lineColor)
    
    %Plot error bars on population-average measurements
    errorbar(concLevels, DoseResp, sigma/sqrt(size(ssDoseResp, 1)), 'o', 'MarkerSize', 5, 'Linewidth', 1.5, 'Color', parms.lineColor)

    xlim([min(Lplot), max(Lplot)])
    ylim([-1.5, 0.5])
    set(gca, 'xscale', 'log')
    
    p_text = exp(p_opt);
%     title(['n = ', num2str(p_text(1)), '[', num2str(n_low), ',', num2str(n_high),']', ...
%         ' | K = ', num2str(p_text(2)), '[', num2str(K_low), ',', num2str(K_high),']'])
     title(['n = ', num2str(p_text(1)), '\pm', num2str(n_err), ...
        ' | K = ', num2str(p_text(2) + backConc), '\pm', num2str(K_err)])
   
    %Axis labels
    xlabel(dataparms.xlabels);
    ylabel("\langle R \rangle")
    
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
    HillPlotData.n_err = n_err;
    HillPlotData.K_err = K_err;

    
end