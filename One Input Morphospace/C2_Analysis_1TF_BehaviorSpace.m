clear all, clc, close all

% Code to analysis and plot parameter analysis/enrichment
% MATLAB 2016b

%% Load Behavior Space

load 181115_1TF_behavior_space.mat cf_stor params params_meas ...
    Kt_meas Kp_meas Kt_approx Kp_approx

% Behavior space properties
ec50 = cf_stor(3,:);
nH = cf_stor(4,:);
fold_change = (cf_stor(1,:)+cf_stor(2,:))./cf_stor(2,:);

% Filter by n (size of complex) - seperate no clamp parameters (Kp=0)
ind2 = find((params(3,:)==2)&(params(2,:)>0));
ind3 = find((params(3,:)==3)&(params(2,:)>0));
ind4 = find((params(3,:)==4)&(params(2,:)>0));
ind5 = find((params(3,:)==5)&(params(2,:)>0));
ind_noClamp = find(params(2,:)==0);


%% Plot Behavior space

% figure
%     semilogy(nH(ind2),ec50(ind2),'o'); hold on
%     semilogy(nH(ind3),ec50(ind3),'o'); hold on
%     semilogy(nH(ind4),ec50(ind4),'o'); hold on
%     semilogy(nH(ind5),ec50(ind5),'o'); hold on
%     semilogy(nH(ind_noClamp),ec50(ind_noClamp),'ko'); hold on
%     semilogy(nH(ind_built),ec50(ind_built),'ks','MarkerSize',20,'LineWidth',1); hold on
%     xlim([1.35 3.75])
%     ylim([10^0 10^3])
%     pbaspect([4.2 1 1])

temp = [params_meas; cf_stor]
    
%% Screen Behavior space

% Screen Parameters for functional dose responses
% Basal < 0.2, Fold change > 2
screen = find((cf_stor(2,:)<0.2)&((cf_stor(1,:)+cf_stor(2,:))./cf_stor(2,:)>2));

% Filter for screened dose response
cf_stor = cf_stor(:,screen);
nH = nH(screen);
ec50 = ec50(screen);
params_meas = params_meas(:,screen);
params = params(:,screen);

% Filter by n (size of complex) - seperate no clamp parameters (Kp=0)
ind2 = find((params(3,:)==2)&(params(2,:)>0));
ind3 = find((params(3,:)==3)&(params(2,:)>0));
ind4 = find((params(3,:)==4)&(params(2,:)>0));
ind5 = find((params(3,:)==5)&(params(2,:)>0));
ind_noClamp = find(params(2,:)==0);

% Plot Full Scatter
figure
    semilogy(nH(ind_noClamp),ec50(ind_noClamp),'ko'); hold on
    semilogy(nH(ind2),ec50(ind2),'o'); hold on
    semilogy(nH(ind3),ec50(ind3),'o'); hold on
    semilogy(nH(ind4),ec50(ind4),'o'); hold on
    semilogy(nH(ind5),ec50(ind5),'o'); hold on
    xlim([1.35 3.75])
    ylim([10^0 10^3])
    pbaspect([4.2 1 1])
saveas(gcf,['Figures/Scatter_All'],'pdf')

    
% Plot No Clamp
figure
    semilogy(nH(ind_noClamp),ec50(ind_noClamp),'ko'); hold on
    xlim([1.35 3.75])
    ylim([10^0 10^3])
    pbaspect([4.2 1 1])
saveas(gcf,['Figures/Scatter_noC'],'pdf')

% Plot n=2
figure
    semilogy(nH(ind2),ec50(ind2),'o'); hold on
    xlim([1.35 3.75])
    ylim([10^0 10^3])
    pbaspect([4.2 1 1])
saveas(gcf,['Figures/Scatter_n2'],'pdf')

% Plot n=3
figure
    semilogy(nH(ind3),ec50(ind3),'o'); hold on

    xlim([1.35 3.75])
    ylim([10^0 10^3])
    pbaspect([4.2 1 1])
saveas(gcf,['Figures/Scatter_n3'],'pdf')

% Plot n=4
figure
    semilogy(nH(ind4),ec50(ind4),'o'); hold on
    xlim([1.35 3.75])
    ylim([10^0 10^3])
    pbaspect([4.2 1 1])
saveas(gcf,['Figures/Scatter_n4'],'pdf')

% Plot n=5
figure
    semilogy(nH(ind5),ec50(ind5),'o'); hold on
    xlim([1.35 3.75])
    ylim([10^0 10^3])
    pbaspect([4.2 1 1])
saveas(gcf,['Figures/Scatter_n5'],'pdf')
    
%% Define region of Parameter Analysis

% % Remove no clamp constructs for parameter analysis
% withclamp = find(params(2,:)>0);
% params_meas = params_meas(:,withclamp);
% nH = nH(withclamp);

% Linear DRs
ind_interest = find((nH>1.5)&(nH<1.7));
OutputName = 'Linear_DRs';

% % Medium DRs
ind_interest = find((nH>2.4)&(nH<2.6));
OutputName = 'Medium_DRs';

% % Nonlinear DRs
ind_interest = find((nH>3.4));
OutputName = 'Nonlinear_DRs';


% Parameters to tabulate
x = params_meas(:,ind_interest);


% % Plot ParamEnrich Zones
% figure
%     semilogy([1.5 1.7],[10^2 10^2],'k-'); hold on
%     xlim([1.35 3.75])
%     ylim([10^0 10^3])
%     pbaspect([4.2 1 1])
% saveas(gcf,['Figures/LinearDR'],'pdf')
% 
% figure
%     semilogy([2.4 2.6],[10^2 10^2],'k-'); hold on
%     xlim([1.35 3.75])
%     ylim([10^0 10^3])
%     pbaspect([4.2 1 1])
% saveas(gcf,['Figures/MediumDR'],'pdf')
% 
% figure
%     semilogy([3.4 3.6],[10^2 10^2],'k-'); hold on
%     xlim([1.35 3.75])
%     ylim([10^0 10^3])
%     pbaspect([4.2 1 1])
% saveas(gcf,['Figures/NonLinearDR'],'pdf')


%% Tablute and Plot Parameter Analysis

% Colors for plots
colors = [[32 120 184]; ...     % Kt
    [230 47 45]; ...            % Kp
    [70 70 70]]/255;            % n1


% Find bounds of parameter range
ranges = {};
for i=1:3
    tab = tabulate(params_meas(i,:));
    ranges{i} = tab(:,1);
end


figure

% Kt,Kp enrichment
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
    ylim([0 0.5])
    xlim([min(fullrange(:,1)),max(fullrange(:,1))])
    pbaspect([2 1 1])
    
end

% n enrichment
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
    pbaspect([2 1 1])

end


%% Save Image
r = 150; % pixels per inch
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 1050 200]/r);
print(gcf,'-dpdf',sprintf('-r%d',r), ['Figures/' OutputName '_ParameterEnrichment.pdf']);