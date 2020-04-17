clear all

%% Load Data
data = {'181209_Freq_2Node.mat','181209_Freq_3Node.mat',...
        '181209_Freq_CFFL_NoFB.mat'};

filter_cutoff = 0.2;        % Cutoff for 'good' freq filter
bd_threshold = 2;           % Threshold for 'good' BD

%% Plot Discarded

% Red Colors
red_colors = [ [234 160 165];
       [234 142 150];
       [234 125 134];
       [234 108 120];
       [234 91 104];
       [234 73 90];
       [234 56 74]; ]/256;

lc = length(red_colors);

figure
for j=1:length(data)
    load(data{j})
    
    % Initialize
    gain_norm = zeros(size(gain_stor));
    gain_temp = [];

    % Normalize Gain
    for i=1:length(params)
        gain_temp = gain_stor(:,i);
        gain_norm(:,i) = gain_temp/max(gain_temp);
    end

    % Screen for Filters

    % Prescreen
    ind_screen = find(gain_stor(end,:)>1000);
    gain_stor = gain_stor(:,ind_screen);
    gain_norm = gain_norm(:,ind_screen);
    params = params(:,ind_screen);

    % Bad filters
    ind_bad = find((gain_norm(end,:)==1)&(min(gain_norm)>filter_cutoff));
    perc_bad = length(ind_bad)/length(params)

    % Plot
    [m,n] = size(gain_norm(:,ind_bad));
    for i=1:n
        patchline(freq_range,gain_norm(:,ind_bad(i)),'edgecolor',red_colors(mod(i-1,lc)+1,:),'edgealpha',0.025); hold on
        
%         linealpha(freq_range,gain_norm(:,ind_bad(i)),'EdgeColor',colors(mod(i-1,lc)+1,:),'EdgeAlpha',0.025); hold on
%         linealpha(freq_range,gain_norm(:,ind_good(i)),'EdgeColor',[52 153 157]/255,'EdgeAlpha',0.075); hold on
%         linealpha(freq_range,gain_norm(:,ind_bd(i)),'EdgeColor',[33 83 120]/255,'EdgeAlpha',0.5); hold on
    end
    set(gca,'Xscale','log')
    set(gca,'FontSize',24)
    xlim([10^-4 10^-2])
    ylim([0 1.1])
    
end

% Save Image
r = 150; % pixels per inch
print(gcf,'-dpng',sprintf('-r%d',r), ['Figures/Bodes_Discarded.png']);



%% Plot Low Pass Filters

data = {'181209_Freq_2Node.mat','181209_Freq_3Node.mat',...
'181209_Freq_3Node_FB2.mat', '181209_Freq_CFFL_NoFB.mat', ...
'181209_Freq_CFFL_FB2.mat'};

close all

figure
for j=1:length(data)
    load(data{j})
    
    % Initialize
    gain_norm = zeros(size(gain_stor));
    gain_temp = [];

    % Normalize Gain
    for i=1:length(params)
        gain_temp = gain_stor(:,i);
        gain_norm(:,i) = gain_temp/max(gain_temp);
    end

    % Screen for Filters

    % Prescreen
    ind_screen = find(gain_stor(end,:)>1000);
    gain_stor = gain_stor(:,ind_screen);
    gain_norm = gain_norm(:,ind_screen);
    params = params(:,ind_screen);

    % Good filters
    ind_good = find((gain_norm(end,:)==1)&(gain_norm(1,:)<filter_cutoff));
    p(j) = length(ind_good);
    perc_good = length(ind_good)/length(params)



    % Plot
    [m,n] = size(gain_norm(:,ind_good));
    for i=1:n
        patchline(freq_range,gain_norm(:,ind_good(i)),'edgecolor',[52 153 157]/255,'edgealpha',0.1); hold on
    end
    set(gca,'Xscale','log')
    set(gca,'FontSize',24)
    xlim([10^-4 10^-2])
    ylim([0 1.1])
    
end

% Save Image
r = 150; % pixels per inch
print(gcf,'-dpng',sprintf('-r%d',r), ['Figures/Bodes_LowPass.png']);



%% Plot Band Stop Filters

data = {'181209_Freq_2Node.mat','181209_Freq_3Node.mat',...
'181209_Freq_3Node_FB2.mat', '181209_Freq_CFFL_NoFB.mat', ...
'181209_Freq_CFFL_FB2.mat'};

close all

figure
for j=1:length(data)
    load(data{j})
    
    % Initialize
    gain_norm = zeros(size(gain_stor));
    gain_temp = [];

    % Normalize Gain
    for i=1:length(params)
        gain_temp = gain_stor(:,i);
        gain_norm(:,i) = gain_temp/max(gain_temp);
    end

    % Screen for Filters

    % Prescreen
    ind_screen = find(gain_stor(end,:)>1000);
    gain_stor = gain_stor(:,ind_screen);
    gain_norm = gain_norm(:,ind_screen);
    params = params(:,ind_screen);

    % Burst Detectors
    ind_bd = [];
    for i=1:length(params)
        if gain_norm(1,i)>bd_threshold*min(gain_norm(:,i))
            ind_bd = [ind_bd i];
        end
    end
    perc_bd = length(ind_bd)/length(params)
    g(j) = length(ind_bd);

    % Plot
    [m,n] = size(gain_norm(:,ind_bd));
    for i=1:n
        patchline(freq_range,gain_norm(:,ind_bd(i)),'edgecolor',[33 83 120]/255,'edgealpha',0.25); hold on
    end
    set(gca,'Xscale','log')
    set(gca,'FontSize',24)
    xlim([10^-4 10^-2])
    ylim([0 1.1])
    
end

% Save Image
r = 150; % pixels per inch
print(gcf,'-dpng',sprintf('-r%d',r), ['Figures/Bodes_BandStop.png']);


