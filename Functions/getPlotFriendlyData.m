function plotData = getPlotFriendlyData(EfretData)   
    %Get long time-series for each cell
    for i = 1:length(EfretData)
        a = transpose(EfretData(i).a);
        t = transpose(EfretData(i).t);
        plotData.aSeries(i, :) = a(:);
        plotData.tSeries(i, :) = t(:);
    end
    
    %Get stimulus changes
    s = transpose(EfretData(1).s);
    plotData.sSeries = s(:);
    
    plotData.sChanges = zeros(length(plotData.sSeries), 1);
    for i = 2:length(plotData.sSeries)
        if plotData.sSeries(i) ~= plotData.sSeries(i-1)
            plotData.sChanges(i) = 1;
        end
    end
end