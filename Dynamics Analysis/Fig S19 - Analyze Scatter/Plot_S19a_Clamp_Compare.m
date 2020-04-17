clear all

%% 2 Node Data
load 181209_16h_2Node time GFP_ON_norm_stor params GFP_ON_stor

GFP_ON = GFP_ON_norm_stor;

% Filter out non-productive TCs
[GFP_ON, params] = filterTCs(GFP_ON, params, GFP_ON_stor);

ind1_m = find(params(2,:)==0);      % No Clamp configs
ind1_p = find(params(2,:)~=0);      % Clamped configs

% Calculate activation and deactivation times
[ka1_half,ta1_half] = ONtime_16(params,GFP_ON,time);
[kd1_half,td1_half] = OFFtime_16(params,GFP_ON,time);

%% 3 Node Data - NoFB

load 181209_16h_3Node_NoFB.mat time GFP_ON_norm_stor params GFP_ON_stor

GFP_ON = GFP_ON_norm_stor;

% Filter out non-productive TCs
[GFP_ON, params] = filterTCs(GFP_ON, params, GFP_ON_stor);

ind2_m = find((params(2,:)==0)&(params(5,:)==0));	% No Clamp configs
ind2_p = find((params(2,:)~=0)&(params(5,:)~=0));   % Clamped configs

% Calculate activation and deactivation times
[ka2_half,ta2_half] = ONtime_16(params,GFP_ON,time);
[kd2_half,td2_half] = OFFtime_16(params,GFP_ON,time);


%% Total numbers
minus_clamp = length(ind1_m) + length(ind2_m)
plus_clamp = length(ind1_p) + length(ind2_p)


%% Plot

% Minus Clamp configs
figure
plot(ta2_half(ind2_m),td2_half(ind2_m),'o','Color',[58,31,90]/255); hold on
plot(ta1_half(ind1_m),td1_half(ind1_m),'o','Color',[58,31,90]/255); hold on
text(1000,2000,num2str(minus_clamp),'FontSize',18)
set(gca,'FontSize',18)
xlim([0 1500])
ylim([0 3000])

% Save Plot
saveas(gcf,['Figures/minus_clamp_configs'],'pdf')


% Plus Clamp configs
figure
plot(ta2_half(ind2_p),td2_half(ind2_p),'o','Color',[184,66,91]/255); hold on
plot(ta1_half(ind1_p),td1_half(ind1_p),'o','Color',[184,66,91]/255); hold on
text(1000,2500,num2str(plus_clamp),'FontSize',18)
set(gca,'FontSize',18)
xlim([0 1500])
ylim([0 3000])

% Save Plot
saveas(gcf,['Figures/plus_clamp_configs'],'pdf')
