function dataparms = datasets()
    %% No Background, MeAsp Dose Response
    dataparms.backConc = 0; %Background concentration for fitting hill function
    dataparms.xlabels = '[MeAsp]'; %xlabel on plots
    dataparms.Lplot = 10.^[-3:0.01:3]; %Range of plots
    dataparms.Files = ["./Data/210215/FOV1.mat"]; %Where to load data from
    dataparms.OutFolder = '210215_NoBackgroundMeAspDose/'; %Where to output data to
    dataparms.concLevels = [10^-1, 10^-.5, 10^0, 10^.5, 10];
    dataparms.Hillp0 = [log(2), log(10^1)]; %Log of estimated parameters to fit hill function
    dataparms.Normp0 = [1, 5];
    
    %% 100 uM MeAsp background, MeAsp Dose Response
%     dataparms.backConc = 100; %Background concentration for fitting hill function
%     dataparms.xlabels = '[MeAsp]'; %xlabel on plots
%     dataparms.Lplot = 10.^[-3:0.01:3]; %Range of plots
%     dataparms.Files = ["./Data/210216/FOV1.mat"]; %Where to load data from
%     dataparms.OutFolder = '210216_100MeAspBackgroundMeAspDose/'; %Where to output data to
%     dataparms.concLevels = [102, 105, 110, 120, 140];
%     dataparms.Hillp0 = [log(2), log(10^2)]; %Log of estimated parameters to fit hill function
%     dataparms.Normp0 = [log(110), log(2)];
    
    %% 1 uM Ser Background, MeAsp Dose Response
%     dataparms.backConc = 0; %Background concentration for fitting hill function
%     dataparms.xlabels = '[MeAsp]'; %xlabel on plots
%     dataparms.Lplot = 10.^[-3:0.01:3]; %Range of plots
%     dataparms.Files = ["./Data/210217/FOV1.mat"]; %Where to load data from
%     dataparms.OutFolder = '210217_1SerBackgroundMeAspDose/'; %Where to output data to
%     dataparms.concLevels = [10^-1, 10^-.5, 10^0, 10^.5, 10];
%     dataparms.Hillp0 = [log(2), log(10^1)]; %Log of estimated parameters to fit hill function
%     dataparms.Normp0 = [1, 5];
    
end