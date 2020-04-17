clear all

%% TWO NODE DATA

load 181209_OnePulse_2Node.mat

ind_linear = 2;
params_linear = params_meas(:,ind_linear)

% Normalize
gain_norm = zeros(size(gain_stor));
for i=1:length(gain_stor)
    gain_norm(:,i) = gain_stor(:,i)/max(gain_stor(:,i));
end

% Calculate Treshold and Sharpness of Activation
[ m1, t1 ] = ThreshSharp( gain_norm, time_range );

%% THREE NODE DATA

load 181209_OnePulse_3Node.mat

ind_nonlinear = 4946;
% ind_nonlinear = 4730;
params_nonlinear = params_meas(:,ind_nonlinear)

% Normalize
gain_norm = zeros(size(gain_stor));
for i=1:length(gain_stor)
    gain_norm(:,i) = gain_stor(:,i)/max(gain_stor(:,i));
end

% Calculate Treshold and Sharpness of Activation
[ m2, t2 ] = ThreshSharp( gain_norm, time_range );



%% PLOT Two Node

figure(1)
plot(t1(ind_linear)/60/3,m1(ind_linear),'ks','MarkerSize',20 ); hold on
set(gca,'FontSize',20)
xlim([0 15])
ylim([0 2.5])
    
% Save Image
r = 150; % pixels per inch
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 550 800]/r);
print(gcf,'-depsc',sprintf('-r%d',r), ['Figures/OnePulse_2Node_built.eps']);


%% Plot Three Node

figure(2)
plot(t2(ind_nonlinear)/60/3,m2(ind_nonlinear),'ks','MarkerSize',20 ); hold on
set(gca,'FontSize',20)
xlim([0 15])
ylim([0 2.5])
    
m2(ind_nonlinear)

% Save Image
r = 150; % pixels per inch
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 550 800]/r);
print(gcf,'-depsc',sprintf('-r%d',r), ['Figures/OnePulse_3Node_built.eps']);  