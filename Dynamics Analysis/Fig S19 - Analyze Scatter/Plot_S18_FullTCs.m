clear all, close all

OutputName = '181209_Full';

%% Load Data

load 181209_16h_2Node.mat time GFP_ON_stor
GFP_ON_raw = GFP_ON_stor;

load 181209_16h_3Node_NoFB.mat time GFP_ON_stor
temp_raw = GFP_ON_stor;
GFP_ON_raw = [GFP_ON_raw temp_raw];

load 181209_16h_3Node_FB1.mat time GFP_ON_stor
temp_raw = GFP_ON_stor;
GFP_ON_raw = [GFP_ON_raw temp_raw];

load 181209_16h_3Node_FB2.mat time GFP_ON_stor
temp_raw = GFP_ON_stor;
GFP_ON_raw = [GFP_ON_raw temp_raw];

clear temp_ON GFP_ON_stor GFP_ON_norm_stor


%% Plot

% Grey Colors
colors = [ 225*ones(1,3);
           200*ones(1,3);
           175*ones(1,3);
           150*ones(1,3);
           125*ones(1,3);
           100*ones(1,3);
           75*ones(1,3); ]/256;
       
lc = length(colors);
ymax = 8000;

figure
    % 16h patch
    a = patch([ 0 960 960 0], [0 0 ymax ymax],'b','EdgeColor','none');
    a.FaceColor = [245 146 33]/255;
    a.FaceAlpha = 0.2;
    
    for i=1:length(GFP_ON_raw)
        patchline(time,GFP_ON_raw(:,i),'edgecolor',colors(mod(i-1,lc)+1,:),'edgealpha',0.1); hold on
    end
    
    ylim([0 ymax])
    xlim([0 4000])
    set(gca, 'XTickLabel', [])
    set(gca, 'YTickLabel', [])
    set(gca,'Fontsize',18)
    
    % Save Image
    r = 150; % pixels per inch
    set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 1000 400]/r);
    print(gcf,'-dpng',sprintf('-r%d',r), ['Figures/' OutputName '.png']);
    

