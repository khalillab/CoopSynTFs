clear all

%% 2 Node Data
load 181209_16h_2Node.mat time GFP_ON_norm_stor params_meas GFP_ON_stor

params = params_meas;
remove_nonclamped = find(params_meas(2,:)~=0);
params_meas = params_meas(:,remove_nonclamped);

GFP_ON = GFP_ON_norm_stor;

[GFP_ON, params] = filterTCs(GFP_ON, params, GFP_ON_stor);

[ka1_half,ta1_half] = ONtime_16(params,GFP_ON,time);
[kd1_half,td1_half] = OFFtime_16(params,GFP_ON,time);

%% Chosen Parameters
ind = find((ta1_half<400)&(td1_half<600));     % Fast OFF, Fast ON
OutputName = '2N_FastON_FastOFF'

[length(ind) 100*length(ind)/length(ta1_half)]

%% Plot Config Locations

figure
% plot(ta1_half,td1_half,'bo'); hold on
plot(ta1_half(ind),td1_half(ind),'o','Color',[248 149 32]/255); hold on
set(gca,'FontSize',18)
xlim([0 1500])
ylim([0 3000])

% Save Plot
saveas(gcf,['Figures/' OutputName '_Configs'],'pdf')

%% Plot Parameter Enrichment

% Colors for plots
colors = [[32 120 184]; ...     % Kt1
    [230 47 45]; ...            % Kp1
    [70 70 70]]/255;            % n1


x = params(:,ind);
ranges = {};
for i=1:3
    tab = tabulate(params_meas(i,:));
    ranges{i} = tab(:,1);
end

figure
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

% Save Image
r = 150; % pixels per inch
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 1050 200]/r);
print(gcf,'-dpdf',sprintf('-r%d',r), ['Figures/' OutputName '_ParamEnrich.pdf']);
