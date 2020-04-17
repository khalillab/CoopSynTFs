clear all, close all

%% Load Data (ea = edgealpha for plot)

% load 181209_Freq_2Node.mat; ea = 1; OutputName = 'Bode_2N';
% load 181209_Freq_3Node.mat; ea = 0.1; OutputName = 'Bode_3N';
% load 181209_Freq_3Node_FB2.mat; ea = 0.1; OutputName = 'Bode_3N_FB2';
load 181209_Freq_CFFL_NoFB.mat; ea = 0.1; OutputName = 'Bode_CFFL';
% load 181209_Freq_CFFL_FB2.mat; ea = 0.1; OutputName = 'Bode_CFFL_FB2';


%% Initialize
gain_norm = zeros(size(gain_stor));
gain_temp = [];

%% Normalize Gain
for i=1:length(params)
    gain_temp = gain_stor(:,i);
    gain_norm(:,i) = gain_temp/max(gain_temp);
end

%% Plot Space

% Grey Colors
colors = [ 200*ones(1,3);
           175*ones(1,3);
           150*ones(1,3);
           125*ones(1,3);
           100*ones(1,3);
           75*ones(1,3);
           50*ones(1,3); ]/256;

lc = length(colors);

figure(1)
for i=1:length(gain_norm)
    patchline(freq_range,gain_norm(:,i),'edgecolor',colors(mod(i-1,lc)+1,:),'edgealpha',ea); hold on
end
set(gca,'Xscale','log')
set(gca,'FontSize',24)
xlim([min(freq_range) max(freq_range)])
xlim([10^-4 max(freq_range)])
ylim([0 1.1])


% % Save Image
r = 150; % pixels per inch
print(gcf,'-dpng',sprintf('-r%d',r), ['Figures/' OutputName '.png']);
       