load MF_configs_start_times.mat

folder = 'S20_Data_All/';

%% Iterate thru files
extract_data = [];

for i=1:length(configs)
    
    % Load Data
    filename = configs{i,1}
    load([folder filename],'Data')
    
    % Prepare data
    st = configs{i,2};      % Start time
    GFP = Data(:,1);
    basal = mean(GFP(1:st-1));    % Basal GFP
    GFP = GFP(st:end);            % Correct Data
    stdev = Data(st:end,2);
    stdev_norm = Data(st:end,4);
    basal = min([basal min(GFP)]);
    GFP_norm = (GFP-basal)/(max(GFP)-basal);
    
    extract_data(i,1) = basal;
    extract_data(i,2) = max(GFP);
    ind = find(GFP==max(GFP))
    extract_data(i,3) = max(GFP)+stdev(ind);
    
    % Plot Normalized
    figure(1)
    subplot(5,5,i)
    st = 1; fin = 143;
    boundedline([0:142]*15,GFP_norm(st:fin),stdev_norm(st:fin),'b-'); hold on
    plot(960,0,'ro'); hold on
    set(gca,'FontSize',20)
    xlim([0 142*15])
    ylim([0 1.3])
    

end