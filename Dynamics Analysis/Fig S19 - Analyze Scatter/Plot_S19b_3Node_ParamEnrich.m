clear all

%% 3 Node Data - NoFB

load 181209_16h_3Node_NoFB.mat time GFP_ON_norm_stor params_meas GFP_ON_stor
params = params_meas;

remove_nonclamped = find((params_meas(2,:)~=0)&(params_meas(5,:)~=0));
params_meas = params_meas(:,remove_nonclamped);

GFP_ON = GFP_ON_norm_stor;

[GFP_ON, params2] = filterTCs(GFP_ON, params, GFP_ON_stor);

[ka2_half,ta2_half] = ONtime_16(params2,GFP_ON,time);
[kd2_half,td2_half] = OFFtime_16(params2,GFP_ON,time);


%% Chosen Parameters
ind = find((ta2_half<400)&(td2_half>1800)); OutputName = '3N_FastON_SlowOFF'     % Fast ON, Slow OFF
ind = find((ta2_half>600)&(td2_half<650));  OutputName = '3N_SlowON_FastOFF'     % Slow ON, Fast OFF
ind = find((ta2_half<500)&(td2_half<1000)); OutputName = '3N_FastON_FastOFF'     % Fast ON, Fast OFF

[length(ind) 100*length(ind)/length(ta2_half)]

%% Plot Config Locations

figure
plot(ta2_half(ind),td2_half(ind),'o','Color',[151 204 124]/255); hold on
set(gca,'FontSize',18)
xlim([0 1500])
ylim([0 3000])

% Save Plot
saveas(gcf,['Figures/' OutputName '_Configs'],'pdf')



%% Plot Parameter Enrichment

% Colors for plots
colors = [[32 120 184]; ...     % Kt1
    [230 47 45]; ...            % Kp1
    [70 70 70]; ...             % n1
    [105 54 142]; ...           % Kt2
    [230 47 45]; ...            % Kp2
    [70 70 70]]/255;            % n2


x = params2(:,ind);

ranges = {};
for i=1:6
    tab = tabulate(params_meas(i,:));
    ranges{i} = tab(:,1);
end

figure
for i=[1,2,4,5]
    
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


for i=[3,6]
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