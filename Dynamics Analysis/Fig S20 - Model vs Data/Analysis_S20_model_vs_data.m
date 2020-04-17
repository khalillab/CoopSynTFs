clc, clear all

%% Load/compile data
analysis_stor = [];
tc_stor = {};

load 181216_NoFB_Analysis.mat
analysis_stor = [analysis_stor; extract_data];
tc_stor = [tc_stor data_stor];

load 181216_FB1_Analysis.mat
analysis_stor = [analysis_stor; extract_data];
tc_stor = [tc_stor data_stor];

load 181216_FB2_Analysis.mat
analysis_stor = [analysis_stor; extract_data];
tc_stor = [tc_stor data_stor];

%% Rename
ta_model = analysis_stor(:,1);
td_model = analysis_stor(:,2);
ta_data = analysis_stor(:,3);
td_data = analysis_stor(:,4);
GFP_ta_low = analysis_stor(:,5);
GFP_ta_hi = analysis_stor(:,6);

%% Plot Ta vs Ta
x = ta_model;
y = ta_data;
X = [ones(length(x),1) x];
b = X\y;
yCalc2 = X*b;
Rsq2_ta = 1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2)


MAE_ta = sum(abs(ta_model-ta_data))/length(ta_model)
% RMSD_ta = sqrt(sum((ta_model-ta_data).^2)/length(ta_model))
MAE_ta_noFB = sum(abs(ta_model(1:7)-ta_data(1:7)))/length(ta_model(1:7))
MAE_ta_withFB = sum(abs(ta_model(8:end)-ta_data(8:end)))/length(ta_model(8:end))


figure(1)
    plot(ta_model(1:7),ta_data(1:7),'o'); hold on
    plot(ta_model(8:end),ta_data(8:end),'o'); hold on
    plot([0 1500],[0 1500],'k--'); hold on
    pbaspect([1 1 1])
    set(gca,'FontSize',18)
    title(['MAE=' num2str(MAE_ta)])
%     xlim([0 1000])
%     ylim([0 1000])

%% Plot Td vs Td
ind = find(td_data<3000);
% ind = find((td_data<3000)&(td_model<1500));

x = td_model(ind);
y = td_data(ind);
X = [ones(length(x),1) x];
b = X\y;
yCalc2 = X*b;
Rsq2_td = 1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2)


MAE_td = sum(abs(td_model(ind)-td_data(ind)))/length(td_data(ind))
RMSD_td = sqrt(sum((td_model(ind)-td_data(ind)).^2)/length(td_data(ind)))

MAE_td_noFB = sum(abs(td_model(ind(1:6))-td_data(ind(1:6))))/length(td_data(ind(1:6)))
MAE_td_withFB = sum(abs(td_model(ind(7:end))-td_data(ind(7:end))))/length(td_data(ind(7:end)))

% figure(2)
%     plot(td_model(ind),td_data(ind),'o'); hold on
%     plot([0 1800],[0 1800],'k--');
%     pbaspect([1 1 1])
%     xticks([0 500 1000 1500])
%     yticks([0 500 1000 1500])
%     set(gca,'FontSize',18)
%     title(['MAE=' num2str(MAE_td)])
% %     xlim([0 1800])
% %     ylim([0 1800])


figure(2)
    plot(td_model(ind(1:6)),td_data(ind(1:6)),'o'); hold on
    plot(td_model(ind(7:end)),td_data(ind(7:end)),'o'); hold on
    plot([0 1800],[0 1800],'k--');
    pbaspect([1 1 1])
    xticks([0 500 1000 1500])
    yticks([0 500 1000 1500])
    set(gca,'FontSize',18)
    title(['MAE=' num2str(MAE_td)])
    xlim([0 1800])
    ylim([0 1800])

    
%% Model - data

error_GFP = [];

figure(3)
for i=1:length(tc_stor)
    time = tc_stor{i}(:,1);
    data_GFP = tc_stor{i}(:,2);
    model_GFP = tc_stor{i}(:,3);
    error_GFP(:,i) = model_GFP-data_GFP;
    
    plot(time,model_GFP-data_GFP); hold on
    xlim([time(1) time(end)])
    pbaspect([7/3 1 1])
end

figure(3)
    plot(time,mean(error_GFP'),'k-','LineWidth',2)


error_abs_GFP = [];


figure(4)
for i=1:length(tc_stor)
    time = tc_stor{i}(:,1);
    data_GFP = tc_stor{i}(:,2);
    model_GFP = tc_stor{i}(:,3);
    error_abs_GFP(:,i) = abs(model_GFP-data_GFP);

    plot(time,abs(model_GFP-data_GFP)); hold on
    xlim([time(1) time(end)])
    pbaspect([7/3 1 1])
end


figure(4)
    plot(time,mean(error_abs_GFP'),'k-','LineWidth',2)
    
 
ymax = 18;
nbins = linspace(-1,1,12);
yratio = 1.2;

figure(6)
    subplot(1,6,1)
    histogram(error_GFP(4*4,:),nbins)
    ylim([0 ymax])
    pbaspect([1 yratio 1])
    
    subplot(1,6,2)
    histogram(error_GFP(10*4,:),nbins)
    ylim([0 ymax])
    pbaspect([1 yratio 1])
    
    subplot(1,6,3)
    histogram(error_GFP(16*4,:),nbins)
    ylim([0 ymax])
    pbaspect([1 yratio 1])

    subplot(1,6,4)
    histogram(error_GFP(22*4,:),nbins)
    ylim([0 ymax])
    pbaspect([1 yratio 1])

    subplot(1,6,5)
    histogram(error_GFP(28*4,:),nbins)
    ylim([0 ymax])
    pbaspect([1 yratio 1])

    subplot(1,6,6)
    histogram(error_GFP(34*4,:),nbins)
    ylim([0 ymax])
    pbaspect([1 yratio 1])
