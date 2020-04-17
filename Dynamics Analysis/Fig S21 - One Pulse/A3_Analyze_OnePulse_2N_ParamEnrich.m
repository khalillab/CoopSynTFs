clear all

% Parameter Enrichment Analysis for One Pulse data

%% Two Node Data

load 181209_OnePulse_2Node.mat

[gain_stor, ind] = GainScreen(gain_stor);
params = params_meas(:,ind);

% Normalize
gain_norm = zeros(size(gain_stor));
for i=1:length(gain_stor)
    gain_norm(:,i) = gain_stor(:,i)/max(gain_stor(:,i));
end

% Calculate thingies
[ m2, t2 ] = ThreshSharp( gain_norm, time_range );


%% Find Parameter Region of interest

t2 = t2/60/3;
ind_enrich = find((t2<5)&(m2>0.25)&(m2<0.75)); OutputName = 'LinearFilter';    % Linear Filters

length(ind_enrich)

% Colors for plots
colors = [[32 120 184]; ...     % Kt1
    [230 47 45]; ...            % Kp1
    [70 70 70]]/255;            % n1


x = params(:,ind_enrich);
ranges = {};
for i=1:3
    tab = tabulate(params(i,:));
    ranges{i} = tab(:,1);
end


figure
% Kt,Kp
for i=[1:2]
    
    fullrange = ranges{i};
    fullrange(:,2) = zeros(size(fullrange));
    
    subplot(2,6,i)
    
    % Get percentage of each parameters
    tab = tabulate(x(i,:));
    for j=1:length(tab(:,1))
        ind = find(fullrange(:,1)==tab(j,1));
        fullrange(ind,2) = tab(j,3)/100;
    end
    
    % Plot
    polygon_x = [min(fullrange(:,1)); fullrange(:,1); max(fullrange(:,1))];
    polygon_y = [0; fullrange(:,2); 0];
    patch(polygon_x,polygon_y,colors(i,:),'FaceAlpha',0.4); hold on
    
    semilogx(fullrange(:,1),fullrange(:,2),'-','Color',colors(i,:),'LineWidth',1.75)
    set(gca,'XScale','log')
    ylim([0 1])
    xlim([min(fullrange(:,1)),max(fullrange(:,1))])
    
end


% n
for i=[3]
    fullrange = ranges{i};
    fullrange(:,2) = zeros(size(fullrange));
    
    subplot(2,6,i)
    
    % Get percentage of each parameters
    tab = tabulate(x(i,:));
    for j=1:length(tab(:,1))
        ind = find(fullrange(:,1)==tab(j,1));
        fullrange(ind,2) = tab(j,3)/100;
    end

    % Plot
    polygon_x = [min(fullrange(:,1)); fullrange(:,1); max(fullrange(:,1))];
    polygon_y = [0; fullrange(:,2); 0];
    patch(polygon_x,polygon_y,colors(i,:),'FaceAlpha',0.4); hold on
    
    plot(fullrange(:,1),fullrange(:,2),'-','Color',colors(i,:),'LineWidth',1.75)
    ylim([0 1])
    xlim([min(fullrange(:,1)),max(fullrange(:,1))])

end

%% Save Image
r = 150; % pixels per inch
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 1050 200]/r);
print(gcf,'-dpdf',sprintf('-r%d',r), ['Figures/ParamEnrich_2N_' OutputName '.pdf']);