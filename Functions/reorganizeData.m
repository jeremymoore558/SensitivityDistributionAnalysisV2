function doseData = reorganizeData(EfretData, n, m)
    nRows = size(EfretData(1).a, 1);
    nReps = nRows ./ n;
    sortMat = repmat(transpose(1:n), nReps, 1);
    
    %For each cell, reformat data
    for i = 1:size(EfretData, 2)
        doseData(i).s = EfretData(i).s(2, :);
        doseData(i).a1 = EfretData(i).a(sortMat == 1, :);
        doseData(i).t1 = EfretData(i).t(sortMat == 1, :);
        doseData(i).a1 = doseData(i).a1(1:m, :);
        doseData(i).t1 = doseData(i).t1(1:m, :);
        
        if n > 1
            doseData(i).a2 = EfretData(i).a(sortMat == 2, :); 
            doseData(i).t2 = EfretData(i).t(sortMat == 2, :);
            doseData(i).a2 = doseData(i).a2(1:m, :);
            doseData(i).t2 = doseData(i).t2(1:m, :);
        end
        
        if n > 2
            doseData(i).a3 = EfretData(i).a(sortMat == 3, :); 
            doseData(i).t3 = EfretData(i).t(sortMat == 3, :);
            doseData(i).a3 = doseData(i).a3(1:m, :);
            doseData(i).t3 = doseData(i).t3(1:m, :);
        end
        
        if n > 3
            doseData(i).a4 = EfretData(i).a(sortMat == 4, :); 
            doseData(i).t4 = EfretData(i).t(sortMat == 4, :);
            doseData(i).a4 = doseData(i).a4(1:m, :);
            doseData(i).t4 = doseData(i).t4(1:m, :);
        end
        
        if n > 4
            doseData(i).a5 = EfretData(i).a(sortMat == 5, :); 
            doseData(i).t5 = EfretData(i).t(sortMat == 5, :);
            doseData(i).a5 = doseData(i).a5(1:m, :);
            doseData(i).t5 = doseData(i).t5(1:m, :);
        end
        
        if n>5
            doseData(i).a6 = EfretData(i).a(sortMat == 6, :); 
            doseData(i).t6 = EfretData(i).t(sortMat == 6, :);
            doseData(i).a6 = doseData(i).a6(1:m, :);
            doseData(i).t6 = doseData(i).t6(1:m, :);
        end
            
    end
end
