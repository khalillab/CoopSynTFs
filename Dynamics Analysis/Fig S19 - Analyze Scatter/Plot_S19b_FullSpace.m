clear all

%% 2 Node Data
load 181209_16h_2Node time GFP_ON_norm_stor params GFP_ON_stor

GFP_ON = GFP_ON_norm_stor;

% Filter out non-productive TCs
[GFP_ON, params] = filterTCs(GFP_ON, params, GFP_ON_stor);

% Calculate activation and deactivation times
[ka1_half,ta1_half] = ONtime_16(params,GFP_ON,time);
[kd1_half,td1_half] = OFFtime_16(params,GFP_ON,time);

%% 3 Node Data - NoFB

load 181209_16h_3Node_NoFB.mat time GFP_ON_norm_stor params GFP_ON_stor

GFP_ON = GFP_ON_norm_stor;

% Filter out non-productive TCs
[GFP_ON, params] = filterTCs(GFP_ON, params, GFP_ON_stor);

% Calculate activation and deactivation times
[ka2_half,ta2_half] = ONtime_16(params,GFP_ON,time);
[kd2_half,td2_half] = OFFtime_16(params,GFP_ON,time);


%% 3 Node Data - FB1

load 181209_16h_3Node_FB1.mat time GFP_ON_norm_stor params_meas GFP_ON_stor
params = params_meas;
GFP_ON = GFP_ON_norm_stor;

[GFP_ON, params3] = filterTCs(GFP_ON, params, GFP_ON_stor);

[ka3_half,ta3_half] = ONtime_16(params3,GFP_ON,time);
[kd3_half,td3_half] = OFFtime_16(params3,GFP_ON,time);


%% 3 Node Data - FB2

load 181209_16h_3Node_FB2.mat time GFP_ON_norm_stor params_meas GFP_ON_stor
params = params_meas;
GFP_ON = GFP_ON_norm_stor;

[GFP_ON, params4] = filterTCs(GFP_ON, params, GFP_ON_stor);

[ka4_half,ta4_half] = ONtime_16(params4,GFP_ON,time);
[kd4_half,td4_half] = OFFtime_16(params4,GFP_ON,time);


%% Plot

% 2 Node
figure
plot(ta1_half,td1_half,'o'); hold on
set(gca,'FontSize',18)
xlim([0 1500])
ylim([0 3000])

% Save Plot
saveas(gcf,['Figures/Full_Space_2N'],'pdf')



% 3 Node
figure
plot(ta2_half,td2_half,'o'); hold on
set(gca,'FontSize',18)
xlim([0 1500])
ylim([0 3000])

% Save Plot
saveas(gcf,['Figures/Full_Space_3N'],'pdf')


% 3 Node + FB (no memory)
ind3 = find(td3_half<3000);
ind4 = find(td4_half<3000);

figure
plot(ta3_half(ind3),td3_half(ind3),'o'); hold on
plot(ta4_half(ind4),td4_half(ind4),'o'); hold on
set(gca,'FontSize',18)
xlim([0 1500])
ylim([0 3000])

% Save Plot
saveas(gcf,['Figures/Full_Space_3N_FB_noMemory'],'pdf')



% 3 Node + FB (with memory)
ind3 = find(td3_half==3000);
ind4 = find(td4_half==3000);

figure
plot(ta3_half(ind3),td3_half(ind3),'o'); hold on
plot(ta4_half(ind4),td4_half(ind4),'o'); hold on
set(gca,'FontSize',18)
xlim([0 1500])
ylim([0 3000])

% Save Plot
saveas(gcf,['Figures/Full_Space_3N_FB_withMemory'],'pdf')





