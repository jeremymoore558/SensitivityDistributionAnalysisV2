function doseData = calcResponseAmp2(doseData, n, parms)
    for i = 1:length(doseData)
        preStimInd = doseData(i).s == doseData(i).s(1);
        postStimInd = doseData(i).s ~= doseData(i).s(1);
        
        %Modifiers to which indices to keep
        badBefore = parms.badBefore;
        badAfter = parms.badAfter;
        AllInd = find(postStimInd);
        badInd = [AllInd(1) - badBefore:AllInd(1) + badAfter];
        postStimInd(badInd) = 0;
        
        %Allocate memory to store average pre and post-stimulus A
        doseData(i).preStimVals = zeros(size(doseData(i).a1, 1),n);
        doseData(i).postStimVals = zeros(size(doseData(i).a1, 1),n);
        
        %Calculate response amplitude as difference between mean pre and
        %post stimulus a
        %Rows are mean for each response. Columns are different stimulus
        %levels
        doseData(i).preStimVals(:, 1) = mean(doseData(i).a1(:, preStimInd), 2);
        doseData(i).postStimVals(:,1) = mean(doseData(i).a1(:, postStimInd), 2);
        
        if n > 1
            doseData(i).preStimVals(:, 2) = mean(doseData(i).a2(:, preStimInd), 2);
            doseData(i).postStimVals(:,2) = mean(doseData(i).a2(:, postStimInd), 2);
        end
        if n > 2
            doseData(i).preStimVals(:, 3) = mean(doseData(i).a3(:, preStimInd), 2);
            doseData(i).postStimVals(:,3) = mean(doseData(i).a3(:, postStimInd), 2);
        end
        if n > 3
            doseData(i).preStimVals(:, 4) = mean(doseData(i).a4(:, preStimInd), 2);
            doseData(i).postStimVals(:,4) = mean(doseData(i).a4(:, postStimInd), 2);
        end
        if n > 4
            doseData(i).preStimVals(:, 5) = mean(doseData(i).a5(:, preStimInd), 2);
            doseData(i).postStimVals(:,5) = mean(doseData(i).a5(:, postStimInd), 2);
        end
       
        %Raw response amplitude to be normalized later by dividing by
        %cell-scale a0
        doseData(i).rawR = doseData(i).postStimVals - doseData(i).preStimVals;
        
        %Response amplitude normalized by each measured response's
        %pre-stimulus a
        doseData(i).normR = doseData(i).rawR ./ doseData(i).preStimVals;     
    end
end