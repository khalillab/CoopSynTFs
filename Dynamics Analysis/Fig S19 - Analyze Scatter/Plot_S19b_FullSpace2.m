clear all

%% 3 Node Data - NoFB

load 181209_16h_3Node_NoFB.mat time GFP_ON_norm_stor params_meas GFP_ON_stor

GFP_ON = GFP_ON_norm_stor;

% Calculate activation and deactivation times
[ka2_half,ta2_half] = ONtime_16(params_meas,GFP_ON,time);
[kd2_half,td2_half] = OFFtime_16(params_meas,GFP_ON,time);

% Filter out non-productive TCs
[GFP_ON, params_meas_filter] = filterTCs(GFP_ON, params_meas, GFP_ON_stor);

% Calculate activation and deactivation times
[ka2_half,ta2_half_filter] = ONtime_16(params_meas_filter,GFP_ON,time);
[kd2_half,td2_half_filter] = OFFtime_16(params_meas_filter,GFP_ON,time);

save('181217_3Node_Model_Analysis.mat','ta2_half','td2_half',...
    'ta2_half_filter','td2_half_filter', ...
    'params_meas','params_meas_filter')

%% 3 Node Data - FB1

load 181209_16h_3Node_FB1.mat time GFP_ON_norm_stor params_meas GFP_ON_stor
GFP_ON = GFP_ON_norm_stor;

[ka3_half,ta3_half] = ONtime_16(params_meas,GFP_ON,time);
[kd3_half,td3_half] = OFFtime_16(params_meas,GFP_ON,time);

[GFP_ON, params_meas_filter] = filterTCs(GFP_ON, params_meas, GFP_ON_stor);

[ka3_half,ta3_half_filter] = ONtime_16(params_meas_filter,GFP_ON,time);
[kd3_half,td3_half_filter] = OFFtime_16(params_meas_filter,GFP_ON,time);

save('181217_3Node_FB1_Model_Analysis.mat','ta3_half','td3_half',...
    'ta3_half_filter','td3_half_filter', ...
    'params_meas','params_meas_filter')

%% 3 Node Data - FB2

load 181209_16h_3Node_FB2.mat time GFP_ON_norm_stor params_meas GFP_ON_stor
GFP_ON = GFP_ON_norm_stor;

[ka4_half,ta4_half] = ONtime_16(params_meas,GFP_ON,time);
[kd4_half,td4_half] = OFFtime_16(params_meas,GFP_ON,time);

[GFP_ON, params_meas_filter] = filterTCs(GFP_ON, params_meas, GFP_ON_stor);

[ka4_half,ta4_half_filter] = ONtime_16(params_meas_filter,GFP_ON,time);
[kd4_half,td4_half_filter] = OFFtime_16(params_meas_filter,GFP_ON,time);

save('181217_3Node_FB2_Model_Analysis.mat','ta4_half','td4_half',...
    'ta4_half_filter','td4_half_filter', ...
    'params_meas','params_meas_filter')


%% Plot

% 3 Node
figure
plot(ta2_half,td2_half,'o'); hold on
set(gca,'FontSize',18)
xlim([0 1500])
ylim([0 3000])


% 3 Node + FB (no memory)
ind3 = find(td3_half<3000);
ind4 = find(td4_half<3000);

figure
plot(ta3_half(ind3),td3_half(ind3),'o'); hold on
plot(ta4_half(ind4),td4_half(ind4),'o'); hold on
set(gca,'FontSize',18)
xlim([0 1500])
ylim([0 3000])



% 3 Node + FB (with memory)
ind3 = find(td3_half==3000);
ind4 = find(td4_half==3000);

figure
plot(ta3_half(ind3),td3_half(ind3),'o'); hold on
plot(ta4_half(ind4),td4_half(ind4),'o'); hold on
set(gca,'FontSize',18)
xlim([0 1500])
ylim([0 3000])






