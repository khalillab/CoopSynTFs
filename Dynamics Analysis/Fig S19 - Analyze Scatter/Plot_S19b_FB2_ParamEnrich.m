clear all

%% 3 Node Data - FB2

load 181209_16h_3Node_FB2.mat time GFP_ON_norm_stor params_meas GFP_ON_stor
params = params_meas;
GFP_ON = GFP_ON_norm_stor;

[GFP_ON, params4] = filterTCs(GFP_ON, params, GFP_ON_stor);

[ka4_half,ta4_half] = ONtime_16(params4,GFP_ON,time);
[kd4_half,td4_half] = OFFtime_16(params4,GFP_ON,time);

%% Chosen Parameters
ind = find((ta4_half<375)&(td4_half>2600)&(td4_half<3000));	OutputName = 'FB2_FastON_SlowOFF';	% Fast ON, Slow OFF
ind = find((ta4_half>900)&(td4_half<750));	OutputName = 'FB2_SlowON_FastOFF';	% SlowON, Fast OFF
ind = find((ta4_half>750)&(td4_half>1500)&(td4_half<3000));	OutputName = 'FB2_SlowON_SlowOFF';	% Slow ON, Slow OFF
% ind = find((ta4_half<400)&(td4_half==3000)); OutputName = 'FB2_FastON_Memory';      % Fast ON, Memory
% ind = find((ta4_half>800)&(td4_half==3000)); OutputName = 'FB2_SlowON_Memory';     % Slow ON, Memory

[length(ind) 100*length(ind)/length(ta4_half)]

% Fraction of parameters with memory
frac_memory = length(find(td4_half == 3000))/length(td4_half)

%% Plot Config Locations
num_hits = length(ind)

figure
plot(ta4_half(ind),td4_half(ind),'o','Color',[179 225 231]/255); hold on
set(gca,'FontSize',18)
xlim([0 1500])
ylim([0 3000])

% Save Plot
saveas(gcf,['Figures/' OutputName '_Configs'],'pdf')


%% Plot Parameter Enrichment

% Colors for plots
colors = [[32 120 184]; ...     % Kt1
    [230 47 45]; ...            % Kp1
    [105 54 142]; ...           % Kt2
    [230 47 45]; ...            % Kp2
    [70 70 70]; ...             % n1
    [70 70 70]; ...             % n2
    [105 54 142]; ...           % Kt3
    [230 47 45]; ...            % Kp3
    [70 70 70]]/255;            % n3


x = params4(:,ind);
ranges = {};
for i=1:9
    tab = tabulate(params_meas(i,:));
    ranges{i} = tab(:,1);
end

figure
for i=[1:4,7:8]
    
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


for i=[5:6,9]
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


% Save Image
r = 150; % pixels per inch
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 1050 200]/r);
print(gcf,'-dpdf',sprintf('-r%d',r), ['Figures/' OutputName '_ParamEnrich.pdf']);