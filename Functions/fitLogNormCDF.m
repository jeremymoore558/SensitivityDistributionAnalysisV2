function CDFPlotData = fitLogNormCDF(SCAvgData, dataparms, parms, OutputDest)
    %% Collect points on the CDF using P(K<L) ~ P(R>0.5)
    singleCellRnorm = SCAvgData.ScMeanRnorm;
    concLevels = dataparms.concLevels;
    
    %Calculate percent of cells that respond less than half-maximally
    lessThanHalf = sum(singleCellRnorm < -0.5, 1); 
    CDFPoints = lessThanHalf./size(singleCellRnorm, 1);
    
    %% Using bootstrapping, get std for each point
    nRuns = parms.nBootstraps;
    AllLessThanHalf = zeros(nRuns, size(lessThanHalf, 2));
    for i = 1:nRuns
        %Get random samples from the data
        samp = randi(size(singleCellRnorm, 1), size(singleCellRnorm, 1), size(singleCellRnorm, 2));
       for j = 1:size(singleCellRnorm, 2)
            ssRnormSamp(:, j) = singleCellRnorm(samp(:, j), j);            
       end
       AllLessThanHalf(i, :) = sum(ssRnormSamp < -0.5, 1);
    end
    CDFPointSamples = AllLessThanHalf ./ size(singleCellRnorm, 1);
    CDFPointErr = std(CDFPointSamples, 0, 1);
    
    %% Fit Log-normal CDF to data
    sigma = CDFPointErr;
    sigma(sigma == 0) = 0.01; %Just in case you have a sample with 0 error
    p0 = dataparms.Normp0;
%     p0(1:2) = log(p0(1:2));
    fitfun = @(b, L) b(3)*logncdf(L, (b(1)), ((b(2)))); %b(1) = meanKhalf, b(2) = variance, b(3) scaling
    inv_log_post = @(p) -(sum(-(1./(2*sigma.^2)).*(CDFPoints - fitfun(p, (concLevels))).^2));
    p_opt2 = fminunc(inv_log_post, p0);
    
    % Log posterior with priors
    %Current priors are that:
        %n ~ N(n_ML, n_ML) (CV = n_ML)
        %K ~ N(K_ML, K_ML) (CV = 1)
        %A ~ U(0, 2)
    log_post = @(p) (sum(-(1./(2*sigma.^2)).*(CDFPoints - fitfun(p, (concLevels))).^2)) +...
        log(normpdf(p(1), p_opt2(1), abs(p_opt2(1)))) + log(normpdf(p(2), p_opt2(2), abs(p_opt2(2)))) + ...
        log(unifpdf(p(3), -1, 3));

    %% Evaluate posterior distribution to find error bars on parameters
    rnd = slicesample(p_opt2, parms.nSamples, 'logpdf', log_post, 'thin', parms.thining);
    
    %Calculate percentiles
    %Percentile for n
    K_low = exp(prctile(rnd(:, 1), 2.5));
    K_high = exp(prctile(rnd(:, 1), 97.5));
    Var_low = exp(prctile(rnd(:, 2), 2.5));
    Var_high = exp(prctile(rnd(:, 2), 97.5));
    A_low = prctile(rnd(:, 3), 2.5);
    A_high = prctile(rnd(:, 3), 97.5);
    
    %Find error bars
    K_err = (K_high - K_low) ./ 2;
    Var_err = (Var_high - Var_low)./ 2;
   
        %% Plot MCMC samples
    figure(); hold on

    subplot(3, 2, 1)
    plot(rnd(:, 1))
    ylabel("log K_{1/2}")
    subplot(3, 2, 2)
    histogram(rnd(:, 1))
    line([p_opt2(1), p_opt2(1)], ylim, 'LineWidth', 1, 'Color', 'r');
    camroll(-90)
    
    subplot(3, 2, 3)
    plot(rnd(:, 2))
    ylabel("log \sigma^2")
    subplot(3, 2, 4)
    histogram(rnd(:, 2))
    line([p_opt2(2), p_opt2(2)], ylim, 'LineWidth', 1, 'Color', 'r');
    camroll(-90)
    
    subplot(3, 2, 5)
    plot(rnd(:, 3))
    ylabel("A")
    subplot(3, 2, 6)
    histogram(rnd(:, 3))
    line([p_opt2(3), p_opt2(3)], ylim, 'LineWidth', 1, 'Color', 'r');
    camroll(-90)
    sgtitle("MCMC samples of the posterior")

    
    %Save Figure in Output Destination
    savefig(gcf, [OutputDest, 'CDFMCMC.fig'])
    saveas(gcf, [OutputDest, 'CDFHillMCMC.png'])


    
    %% Plot CDF Fit
    Lplot = dataparms.Lplot;
    figure('visible', parms.showPlot)
    hold on
    plot(Lplot, fitfun(p_opt2, Lplot), 'linewidth', 3, 'Color', parms.lineColor)
    errorbar(concLevels, CDFPoints, CDFPointErr, 'o', 'MarkerSize', 5, 'Color', parms.lineColor)
    xlim([min(Lplot), max(Lplot)])
    set(gca, 'xscale', 'log')
    
    %Axis labels
    xlabel(dataparms.xlabels)
    ylabel("P(K_{1/2} < [L])")
    xlim([min(Lplot), max(Lplot)])
    ylim([0, 1])
    
    %Put data in title
    p_text = (exp(p_opt2));
    title(['\langle K_{1/2} \rangle = ', num2str(p_text(1)), '\pm', num2str(K_err), '|', ...
        '\sigma^2 = ', num2str(p_text(2)), '\pm', num2str(Var_err)])

    
    %Save Figure in Output Destination
    savefig(gcf, [OutputDest, 'CDFFit.fig'])
    saveas(gcf, [OutputDest, 'CDFFit.png'])

    
    %% Save optimal parameters
    CDFPlotData.p_opt = p_opt2;
    CDFPlotData.Lplot = Lplot;
    CDFPlotData.concLevels = concLevels;
    CDFPlotData.CDFPoints = CDFPoints;
    CDFPlotData.K_err = K_err;
    CDFPlotData.Var_err = Var_err;
    CDFPlotData.CDFPointStd = CDFPointErr;

end