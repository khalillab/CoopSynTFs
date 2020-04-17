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

% Calculate activation and deactivation times
[ka2_half_all,ta2_half_all] = ONtime_16(params,GFP_ON,time);
[kd2_half_all,td2_half_all] = OFFtime_16(params,GFP_ON,time);

% Filter out non-productive TCs
[GFP_ON, params] = filterTCs(GFP_ON, params, GFP_ON_stor);

% Calculate activation and deactivation times
[ka2_half,ta2_half] = ONtime_16(params,GFP_ON,time);
[kd2_half,td2_half] = OFFtime_16(params,GFP_ON,time);


%% 3 Node Data - FB1

load 181209_16h_3Node_FB1.mat time GFP_ON_norm_stor params GFP_ON_stor

GFP_ON = GFP_ON_norm_stor;

% Calculate activation and deactivation times
[ka3_half_all,ta3_half_all] = ONtime_16(params,GFP_ON,time);
[kd3_half_all,td3_half_all] = OFFtime_16(params,GFP_ON,time);

% Filter out non-productive TCs
[GFP_ON, params3] = filterTCs(GFP_ON, params, GFP_ON_stor);

[ka3_half,ta3_half] = ONtime_16(params3,GFP_ON,time);
[kd3_half,td3_half] = OFFtime_16(params3,GFP_ON,time);


%% 3 Node Data - FB2

load 181209_16h_3Node_FB2.mat time GFP_ON_norm_stor params GFP_ON_stor

GFP_ON = GFP_ON_norm_stor;

% Calculate activation and deactivation times
[ka4_half_all,ta4_half_all] = ONtime_16(params,GFP_ON,time);
[kd4_half_all,td4_half_all] = OFFtime_16(params,GFP_ON,time);

% Filter out non-productive TCs
[GFP_ON, params4] = filterTCs(GFP_ON, params, GFP_ON_stor);

[ka4_half,ta4_half] = ONtime_16(params4,GFP_ON,time);
[kd4_half,td4_half] = OFFtime_16(params4,GFP_ON,time);


%% Index of built circuits
ind_noFB = [494, 488, 493, 3872, 3662, 3656, 4730];
ind_FB1 = [6680, 6674, 6602, 6614, 6866, 6794, 11864, ...
            11858, 11786, 11870, 11798, 6788, 11792];
ind_FB2 = [35756, 24974, 22778, 24956];

ind_all = [ind_noFB, ind_FB1, ind_FB2];
ta_built = [ta2_half_all(ind_noFB), ta3_half_all(ind_FB1), ta4_half_all(ind_FB2)];
td_built = [td2_half_all(ind_noFB), td3_half_all(ind_FB1), td4_half_all(ind_FB2)];

%% Plot

% plot limits
xlow = 200;
xhigh = 800;
ylow = 400;
yhigh = 1600;

% plot aspect ratio
xratio = 1.2;       


figure
plot(ta2_half,td2_half,'o'); hold on
set(gca,'FontSize',18)
pbaspect([xratio 1 1])
xlim([xlow xhigh])
ylim([ylow yhigh])

% Save Plot
saveas(gcf,['Figures/Fig3B_Space_3N'],'pdf')



figure
plot(ta4_half,td4_half,'o'); hold on
plot(ta3_half,td3_half,'o'); hold on
set(gca,'FontSize',18)
pbaspect([xratio 1 1])
xlim([xlow xhigh])
ylim([ylow yhigh])

% Save Plot
saveas(gcf,['Figures/Fig3B_Space_FB'],'pdf')



figure
ind4 = find(td4_half==3000);
ind3 = find(td3_half==3000);
plot(ta4_half(ind4),yhigh*ones(size(ind4)),'o'); hold on
plot(ta3_half(ind3),yhigh*ones(size(ind3)),'o'); hold on
set(gca,'FontSize',18)
pbaspect([xratio 1 1])
xlim([xlow xhigh])
ylim([ylow yhigh])

% Save Plot
saveas(gcf,['Figures/Fig3B_Space_Memory'],'pdf')



figure

for i=1:length(ind_all)
    if td_built(i) == 3000
        plot(ta_built(i),yhigh,'ks','MarkerSize',20,'LineWidth',2); hold on
        text(ta_built(i)-100,yhigh,num2str(i),'FontSize',18); hold on
    else 
        plot(ta_built(i),td_built(i),'ks','MarkerSize',20,'LineWidth',2); hold on
        text(ta_built(i)-100,td_built(i),num2str(i),'FontSize',18); hold on
    end
end


set(gca,'FontSize',18)
pbaspect([xratio 1 1])
xlim([xlow xhigh])
ylim([ylow yhigh])

% Save Plot
saveas(gcf,['Figures/Fig3B_Space_BuiltConfigs'],'pdf')
