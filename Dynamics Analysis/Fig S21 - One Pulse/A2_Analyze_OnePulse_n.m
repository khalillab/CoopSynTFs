clear all, close all

% Size of complex to study
n = 2; color = [232 153 82]/255;
% n = 3; color = [152 204 122]/255;
% n = 4; color = [179 225 231]/255;
% n = 5; color = [52 153 157]/255;


%% TWO NODE

load 181209_OnePulse_2Node.mat

[gain_stor, ind] = GainScreen(gain_stor);
params = params(:,ind);

% Normalize
gain_norm = zeros(size(gain_stor));
for i=1:length(gain_stor)
    gain_norm(:,i) = gain_stor(:,i)/max(gain_stor(:,i));
end

% Calculate thingies
[ m0, t0 ] = ThreshSharp( gain_norm, time_range );

% Find complexes of certain size
ind_n0 = find(params(3,:)==n);


%% THREE NODE

load 181209_OnePulse_3Node.mat

[gain_stor, ind] = GainScreen(gain_stor);
params = params(:,ind);
% Normalize
gain_norm = zeros(size(gain_stor));
for i=1:length(gain_stor)
    gain_norm(:,i) = gain_stor(:,i)/max(gain_stor(:,i));
end

% Calculate thingies
[ m1, t1 ] = ThreshSharp( gain_norm, time_range );

% Find complexes of certain size
ind_n1 = find(params(3,:)==n);


%% CFFL DATA

load 181209_OnePulse_CFFL.mat

[gain_stor, ind] = GainScreen(gain_stor);
params = params(:,ind);

% Normalize
gain_norm = zeros(size(gain_stor));
for i=1:length(gain_stor)
    gain_norm(:,i) = gain_stor(:,i)/max(gain_stor(:,i));
end

% Calculate thingies
[ m3, t3 ] = ThreshSharp( gain_norm, time_range );

% Find complexes of certain size
ind_n3 = find(params(3,:)==n);


%% PLOT

figure
    plot(t0(ind_n0)/60/3,m0(ind_n0),'o','Color',color); hold on
    plot(t1(ind_n1)/60/3,m1(ind_n1),'o','Color',color); hold on
    plot(t3(ind_n3)/60/3,m3(ind_n3),'o','Color',color); hold on
    set(gca,'FontSize',20)
    xlim([0 15])
    ylim([0 2.5])
    
% Save Image
r = 150; % pixels per inch
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 550 800]/r);
print(gcf,'-depsc',sprintf('-r%d',r), ['Figures/OnePulse_N_' num2str(n) '.eps']);
