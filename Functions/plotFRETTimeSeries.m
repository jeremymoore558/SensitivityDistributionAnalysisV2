function plotFRETTimeSeries(EfretData, dataparms, parms, OutputDest)
    %% Reorganize data to make it amenable to plotting time-series
    plotData = getPlotFriendlyData(EfretData);
    avgASeries = median(plotData.aSeries, 1);
    avgTSeries = mean(plotData.tSeries, 1);
    switchTimes = find(plotData.sChanges);
    
    %% Plot population-average time-series
    avgTSeries = avgTSeries - min(avgTSeries);
    for i = 1:length(avgASeries)
       if i / 20 == round(i/20)
           avgTSeries(i) = nan;
       end
    end

    figure(); hold on
    % for i = 1:size(plotData.aSeries, 1)
    %     plot(avgTSeries, smooth(plotData.aSeries(i, :)), 'Color', [.8 .8 .8])
    % end
    subplot(2, 1, 1)
    plot(avgTSeries, avgASeries, 'Color', parms.lineColor, 'Linewidth', 3)
    xlabel('Time (s)')
    ylabel('\langle a \rangle')
    set(gca, {'XColor', 'YColor'}, {[0.4 0.4 0.4], [0.4 0.4 0.4]});
    set(gca, 'FontSize', 20)

    
    subplot(2, 1, 2)
    plot(avgASeries, 'Color', parms.lineColor, 'Linewidth', 3)
    xlabel('Frames')
    ylabel('\langle a \rangle')
    set(gca, {'XColor', 'YColor'}, {[0.4 0.4 0.4], [0.4 0.4 0.4]});
    set(gca, 'FontSize', 20)

    set(gcf, 'Position', [200,100, 1000, 600])
    
    %Save figure
    savefig(gcf, [OutputDest, 'PopAvgTimeSeries.fig'])
    saveas(gcf, [OutputDest, 'PopAvgTimeSeries.png'])

    
    %% Plot single-cell traces
    mkdir([OutputDest, 'SingleCellTraces/'])
    
    nPlots = 10;
    for i = 1:size(plotData.aSeries, 1)
        if mod(i, nPlots) == 1
            figure() 
        end
        subplot(nPlots, 1, mod(i-1, nPlots)+1)
        plot(plotData.aSeries(i, :));
        ylabel("a")
        if mod(i, nPlots) == 0 | i == size(plotData.aSeries, 1)
            xlabel('Frames')
            set(gcf, 'Position', [200,100, 1000, 600])
            savefig(gcf, [OutputDest, 'SingleCellTraces/upto', num2str(i), '.fig'])
            saveas(gcf, [OutputDest, 'SingleCellTraces/upto', num2str(i), '.png'])
        end
    end
  


end