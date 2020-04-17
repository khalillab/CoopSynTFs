clear all

%% TWO NODE DATA

load 181209_OnePulse_2Node.mat

[gain_stor, ind] = GainScreen(gain_stor);

% Normalize
gain_norm = zeros(size(gain_stor));
for i=1:length(gain_stor)
    gain_norm(:,i) = gain_stor(:,i)/max(gain_stor(:,i));
end

% Calculate Treshold and Sharpness of Activation
[ m1, t1 ] = ThreshSharp( gain_norm, time_range );

%% THREE NODE DATA

load 181209_OnePulse_3Node.mat

[gain_stor, ind] = GainScreen(gain_stor);

% Normalize
gain_norm = zeros(size(gain_stor));
for i=1:length(gain_stor)
    gain_norm(:,i) = gain_stor(:,i)/max(gain_stor(:,i));
end

% Calculate Treshold and Sharpness of Activation
[ m2, t2 ] = ThreshSharp( gain_norm, time_range );

%% CFFL DATA

load 181209_OnePulse_CFFL.mat

[gain_stor, ind] = GainScreen(gain_stor);

% Normalize
gain_norm = zeros(size(gain_stor));
for i=1:length(gain_stor)
    gain_norm(:,i) = gain_stor(:,i)/max(gain_stor(:,i));
end

% Calculate thingies
[ m3, t3 ] = ThreshSharp( gain_norm, time_range );


%% PLOT Two Node

figure(1)
plot(t1/60/3,m1,'o','Color',[232 153 82]/255 ); hold on
set(gca,'FontSize',20)
xlim([0 15])
ylim([0 2.5])
    
% Save Image
r = 150; % pixels per inch
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 550 800]/r);
print(gcf,'-depsc',sprintf('-r%d',r), ['Figures/OnePulse_2Node.eps']);

    
%% Plot Three Node

figure(2)
plot(t2/60/3,m2,'o','Color',[152 204 122]/255 ); hold on
set(gca,'FontSize',20)
xlim([0 15])
ylim([0 2.5])
    
% Save Image
r = 150; % pixels per inch
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 550 800]/r);
print(gcf,'-depsc',sprintf('-r%d',r), ['Figures/OnePulse_3Node.eps']);


%% Plot CFFL

figure(3)
plot(t3/60/3,m3,'o','Color',[52 153 157]/255 ); hold on
set(gca,'FontSize',20)
xlim([0 15])
ylim([0 2.5])
    
% Save Image
r = 150; % pixels per inch
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 550 800]/r);
print(gcf,'-depsc',sprintf('-r%d',r), ['Figures/OnePulse_CFFL.eps']);     