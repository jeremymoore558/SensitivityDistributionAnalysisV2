function [popAvgData, SCAvgData] = calcPopAvgDoseResponse2(doseData, parms)
    %Assemble all measured responses into one large matrix    
    for i = 1:length(doseData)
        popAvgData.allRData(:, :, i) = doseData(i).rawR; %(rep, doselevel, cell)
        popAvgData.allRData_norm(:, :, i) = doseData(i).normR; 
        popAvgData.a0(i) = mean(doseData(i).preStimVals(:));
    end
    
    for i = 1:size(popAvgData.allRData, 2)
        temp = popAvgData.allRData(:, i, :);
        SCAvgData.allRData(:, i) = temp(:); %(rep, doselevel)
        
        temp = popAvgData.allRData_norm(:, i, :);
        SCAvgData.allRData_norm(:, i) = temp(:);
    end
    
    if ~parms.meanormedian
    	%Calculate mean response amplitude
        popAvgData.meanRraw = mean(popAvgData.allRData, [3, 1]);
        popAvgData.stdRraw = std(popAvgData.allRData, 0, [3, 1]);
        popAvgData.meanRnorm = mean(popAvgData.allRData_norm, [3, 1]);
        popAvgData.stdRnorm = std(popAvgData.allRData_norm, 0, [3, 1]);
        
        %Single-cell average dataset
        SCAvgData.ScMeanRraw = transpose(squeeze(mean(popAvgData.allRData, 1)));
        SCAvgData.ScStdRraw = transpose(squeeze(std(popAvgData.allRData,0, 1)));
        SCAvgData.ScMeanRnorm = transpose(squeeze(mean(popAvgData.allRData_norm, 1)));
        SCAvgData.ScStdRnorm = transpose(squeeze(std(popAvgData.allRData_norm,0, 1)));
    else
        %Calculate median response amplitude
        popAvgData.meanRraw = median(popAvgData.allRData, [3, 1]);
        popAvgData.stdRraw = std(popAvgData.allRData, 0, [3, 1]);
        popAvgData.meanRnorm = median(popAvgData.allRData_norm, [3, 1]);
        popAvgData.stdRnorm = std(popAvgData.allRData_norm, 0, [3, 1]);
            
        %Single-cell average dataset
        SCAvgData.ScMeanRraw = transpose(squeeze(median(popAvgData.allRData, 1)));
        SCAvgData.ScStdRraw = transpose(squeeze(std(popAvgData.allRData,0, 1)));
        SCAvgData.ScMeanRnorm = transpose(squeeze(median(popAvgData.allRData_norm, 1)));
        SCAvgData.ScStdRnorm = transpose(squeeze(std(popAvgData.allRData_norm,0, 1)));
    end
end