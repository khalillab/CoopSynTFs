clear all, clc, close all

% Code to analysis and plot parameter analysis/enrichment
% MATLAB 2016b

%% Load Behavior Space

load 181115_1TF_behavior_space.mat cf_stor params params_meas ...
    Kt_meas Kp_meas Kt_approx Kp_approx

% Behavior space properties
ec50 = cf_stor(3,:);
nH = cf_stor(4,:);
fold_change = (cf_stor(1,:)+cf_stor(2,:))./cf_stor(2,:);

% Filter by n (size of complex) - seperate no clamp parameters (Kp=0)
ind2 = find((params(3,:)==2)&(params(2,:)>0));
ind3 = find((params(3,:)==3)&(params(2,:)>0));
ind4 = find((params(3,:)==4)&(params(2,:)>0));
ind5 = find((params(3,:)==5)&(params(2,:)>0));
ind_noClamp = find(params(2,:)==0);

% Built configs
load 181213_DR_Configs.mat configs data
Kt_configs = configs(1,:);
Kp_configs = configs(2,:);
n_configs  = configs(3,:);
ind_built = [];

for i=1:length(configs)
    Kt_built = Kt_approx(find(Kt_configs(i)==Kt_meas));
    Kp_built = Kp_approx(find(Kp_configs(i)==Kp_meas));
    n_built  = n_configs(i);
    ind_built(i) = find((params(1,:)==Kt_built)&(params(2,:)==Kp_built)&(params(3,:)==n_built));
end

%% Plot Config Locations
figure
    for i=1:length(ind_built)
        semilogy(nH(ind_built(i)),ec50(ind_built(i)),'s','MarkerSize',16); hold on
        text(nH(ind_built(i))-0.05,ec50(ind_built(i)),num2str(i)); hold on
    end
    xlim([1.35 3.75])
    ylim([10^0 10^3])
    pbaspect([4.2 1 1])
saveas(gcf,['Figures/Scatter_Configs'],'pdf')


%% Model vs Data

cf_model = cf_stor(:,ind_built);


%% Hill coefficient
% R^2
x = cf_model(4,:)';
y = data(4,:)';
X = [ones(length(x),1) x];
b = X\y;
yCalc2 = X*b;
Rsq2_nH = 1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2)

% MAE
MAE_nH = sum(abs(cf_model(4,:)-data(4,:)))/length(data(4,:))

% RMSD
RMSD_nH = sqrt(sum((cf_model(4,:)-data(4,:)).^2)/length(data(4,:)))

% Plot
figure
    plot(cf_model(4,:),data(4,:),'o'); hold on
    plot([1 3.75],[1 3.75],'k--')
    pbaspect([1 1 1])
    title(['MAE = ' num2str(MAE_nH)])
    xlim([1, 3.75])
    ylim([1, 3.75])
saveas(gcf,['Figures/ModelvsData_nH'],'pdf')


%% EC50

% R^2
x = cf_model(3,:)';
y = data(3,:)';
X = [ones(length(x),1) x];
b = X\y;
yCalc2 = X*b;
Rsq2_EC50 = 1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2)

% MAE
MAE_EC50 = sum(abs(cf_model(3,:)-data(3,:)))/length(data(3,:))

% RMSD
RMSD_EC50 = sqrt(sum((cf_model(3,:)-data(3,:)).^2)/length(data(3,:)))

figure
    loglog(cf_model(3,:),data(3,:),'o'); hold on
    plot([10 200],[10 200],'k--')
    pbaspect([1 1 1])
    title(['MAE = ' num2str(MAE_EC50)])
    xlim([10, 200])
    ylim([10, 200])
saveas(gcf,['Figures/ModelvsData_EC50'],'pdf')


%% Table compile
compile = [configs' cf_model(4,:)' data(4,:)'];