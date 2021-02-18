function EfretDataFinal = combineFretFiles(Files)
    load(Files(1), "reorgData");
    EfretDataFinal = reorgData.resp_data;

    for i = 2:length(Files)
        load(Files(i), "reorgData");
        EfretDataTemp = reorgData.resp_data;
        for j = 1:length(EfretDataTemp)
            EfretDataFinal(length(EfretDataFinal) + 1) = EfretDataTemp(j);
        end
    end
end