clear all, clc

%% Load Data
load 181215_model_vs_data.mat

%% Plot

nbins = linspace(0,0.5,15)
ta_error = ta(:,4)-0.5;

figure
plot(ta(:,2),abs(ta_error),'o')

% figure
%     plot(ta(:,2),abs(ta(:,4)-0.5),'o')
%     xlim([200 1000])


figure
plot(td(:,2),td(:,3),'o'); hold on
plot([500 1500],[500 1500],'k--')
xlim([500 1500])
ylim([500 1500])