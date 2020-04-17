clear all, close all

%% Load Data

load 181209_Freq_CFFL_FB2.mat;

%% Find parameter

ind = find((params_meas(1,:)==0.143)&(params_meas(2,:)==0.88)&(params_meas(3,:)==0.015)&...
        (params_meas(4,:)==1.97)&(params_meas(5,:)==2)&(params_meas(6,:)==2)&...
        (params_meas(7,:)==0.143)&(params_meas(8,:)==0.88)&(params_meas(9,:)==0.015)&...
        (params_meas(10,:)==1.97)&(params_meas(11,:)==2)&(params_meas(12,:)==2))

%% Plot BODE (S22)

gain_norm = gain_stor./max(gain_stor);

gain_norm(1,ind)/min(gain_norm(:,ind))

figure
semilogx(freq_range,gain_norm(:,ind))
set(gca,'FontSize',24)
xlim([10^-4 10^-2])
ylim([0 1.1])
saveas(gcf,['Figures/S22_Bode_Band_stop'],'pdf')