clear all

OutputName = '181209_Filtered';


%% Two Node

load 181209_16h_2Node.mat time GFP_ON_norm_stor params GFP_ON_stor
GFP_ON = GFP_ON_norm_stor;

[ GFP_ON, params1 ] = filterTCs( GFP_ON, params, GFP_ON_stor );
[m,n] = size(GFP_ON);

% Plot
figure
a = patch([ 0 960 960 0], [0 0 1.1 1.1],'b','EdgeColor','none'); hold on
a.FaceColor = [245 146 33]/255;
a.FaceAlpha = 0.2;
plot(time,GFP_ON,'Color',[232 153 82]/255); hold on
ylim([0 1.1])
xlim([0 4000])
set(gca,'Fontsize',18)
set(gca,'YTick',[0 0.5 1])

% Save Image
r = 150; % pixels per inch
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 1000 400]/r);
print(gcf,'-dpdf',sprintf('-r%d',r), ['Figures/' OutputName '_2node_TCs.pdf']);



%% Three Node

load 181209_16h_3Node_NoFB.mat time GFP_ON_norm_stor params GFP_ON_stor

GFP_ON = GFP_ON_norm_stor;

[ GFP_ON, params2 ] = filterTCs( GFP_ON, params, GFP_ON_stor );
[m,n] = size(GFP_ON);

% Plot
figure
a = patch([ 0 960 960 0], [0 0 1.1 1.1],'b','EdgeColor','none'); hold on
a.FaceColor = [245 146 33]/255;
a.FaceAlpha = 0.2;
plot(time,GFP_ON,'Color',[138 190 102]/256); hold on
ylim([0 1.1])
xlim([0 4000])
set(gca,'YTick',[0 0.5 1])
set(gca,'Fontsize',18)

% Save Image
r = 150; % pixels per inch
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 1000 400]/r);
print(gcf,'-dpdf',sprintf('-r%d',r), ['Figures/' OutputName '_3node_TCs.pdf']);



%% Three Node + FB1

% FB Type 1
load 181209_16h_3Node_FB1.mat time GFP_ON_norm_stor params GFP_ON_stor
GFP_ON = GFP_ON_norm_stor;
[ GFP_ON, params3 ] = filterTCs( GFP_ON, params, GFP_ON_stor );

% FB Type 2
load 181209_16h_3Node_FB2.mat time GFP_ON_norm_stor params GFP_ON_stor
temp1 = GFP_ON_norm_stor;

[ temp1, params4 ] = filterTCs( temp1, params, GFP_ON_stor );
GFP_ON = [GFP_ON temp1];
[m,n] = size(GFP_ON);


% Plot
figure
a = patch([ 0 960 960 0], [0 0 1.1 1.1],'b','EdgeColor','none'); hold on
a.FaceColor = [245 146 33]/255;
a.FaceAlpha = 0.2;
plot(time,GFP_ON,'Color',[40 167 223]/255); hold on
ylim([0 1.1])
xlim([0 4000])
set(gca,'Fontsize',18)
set(gca,'YTick',[0 0.5 1])

% Save Image
r = 150; % pixels per inch
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 1000 400]/r);
print(gcf,'-dpdf',sprintf('-r%d',r), ['Figures/' OutputName '_3nodeFB_TCs.pdf']);

