clear all, clc


%% Load Data

load 181221_CB_mainFigs

[m,n] = size(Data);
cf_data = zeros(4,n);
cf_model = zeros(4,n);

%% Load Model
load 181115_1TF_behavior_space.mat params_meas cf_stor

%% Fit Hill functions
range = logspace(-1,4,100);

for i=1:n

    % Fit Hill Functions
    Input = ATC;              % ATC Titration
    Output = Data(:,i);       % Mean GFP
    start = [max(Output)-min(Output) min(Output) 50 1.5];
    lb = [0 0 0 0];
    ub = [max(Output) max(Output) 10^4 10];
    [cf, resnorm] = lsqcurvefit(@hillguess,start,Input,Output,lb,ub);
    cf_data(:,i) = cf';
    
    % Find model fits
    Kt = configs(1,i);
    Kp = configs(2,i);
    n  = configs(3,i);
    ind = find((params_meas(1,:)==Kt)&(params_meas(2,:)==Kp)&(params_meas(3,:)==n))
    cf_model(:,i) = cf_stor(:,ind);
 
    figure
        errorbar(Input,Output/max(hillguess(cf,range)),SEMs(:,i)/max(hillguess(cf,range)),'ko','CapSize',0); hold on
        semilogx(range,hillguess(cf,range)/max(hillguess(cf,range)),'b-'); hold on
        semilogx(range,hillguess(cf_model(:,i),range)/max(hillguess(cf_model(:,i),range)),'b-'); hold on
        pbaspect([1.16 1 1])
        xlim([0.6 3000])
        ylim([0 1.1])
        set(gca,'FontSize',18)
        set(gca,'Xscale','log')
        saveas(gcf,['Figures/Figure2B_FINAL_' num2str(i)],'eps')

end