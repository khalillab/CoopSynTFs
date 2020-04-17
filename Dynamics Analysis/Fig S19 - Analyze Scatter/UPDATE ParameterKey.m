
% Kp
subplot(2,6,1)
semilogx(10^-2,10^2) 
ylim([0 1])
xlim([10^-2 10^2])
set(gca,'XMinorTick','on')


% Kt1
subplot(2,6,2)
semilogx(10^-2,10^2) 
ylim([0 1])
xlim([0.06 10^0])

% Kt2
subplot(2,6,3)
semilogx(10^-2,10^2) 
ylim([0 1])
xlim([0.001 1])

% Kt2
subplot(2,6,4)
plot(1,5) 
ylim([0 1])
xlim([1 5])

%% Save Image
r = 150; % pixels per inch
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 1250 200]/r);
print(gcf,'-depsc',sprintf('-r%d',r), ['170325_Fig3_Params/ParameterKey.eps']);