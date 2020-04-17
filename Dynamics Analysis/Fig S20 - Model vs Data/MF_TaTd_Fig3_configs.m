clear all

folder = 'Data/'
data_summary = {};
GFP_compile = {};
std_compile = {};
time_compile = {};

% Induction start time for all videos
load MF_configs_start_times.mat
[m,n] = size(configs);

folder = 'S20_Data_All/';

bg_fluor = 400;

% Storing Tas and Tds
ta_compile = [];
ta2_compile = [];
ta3_compile = [];

td_compile = [];
td2_compile = [];
td3_compile = [];


%% Loop through .mat files

for i = 1:m
    
    filename = configs{i,1};
    load([folder filename],'Data')
    data_summary{i,1} = configs{i,1};
    
    
    st = configs{i,2};    % induction start frame
    
    
    GFP = Data(:,1)-bg_fluor;      % Subtract Background
    basal = mean(GFP(1:st-1));     % Basal GFP
%     basal = min(GFP);
    GFP = GFP(st:end);             % Correct Data
    stdev = Data(st:end,2);
    GFP_norm = (GFP-basal)/(max(GFP)-basal);
    stdev_norm = Data(st:end,4);
    
    
    % Normalizing the MF Data between 0 and 1
%     GFP_norm = (GFP_norm-GFP_norm(1))/(max(GFP_norm)-GFP_norm(1));
    

    % Store Data
    GFP_compile{i} = GFP_norm;
    stdev_compile{i} = stdev_norm;
    
    % Create Time arrays
    tmax = length(GFP_norm);
    time_compile{i} = linspace(0*15,(tmax-1)*15,tmax);
    
    
    % Store Half On and Off times
    [ka_half,ta_half] = ONtime_MF_data(GFP_compile{i},time_compile{i});
    [ka_half2,ta2_half] = ONtime_MF_data(GFP_compile{i}+stdev_compile{i},time_compile{i});
    [ka_half3,ta3_half] = ONtime_MF_data(GFP_compile{i}-stdev_compile{i},time_compile{i});
    
    ta_compile(i) = ta_half;
    ta2_compile(i) = ta2_half;
    ta3_compile(i) = ta3_half;
    
    
    [kd_half,td_half] = OFFtime_MF_data(GFP_compile{i},time_compile{i});
    [kd_half2,td2_half] = OFFtime_MF_data(GFP_compile{i}+stdev_compile{i},time_compile{i});
    [kd_half3,td3_half] = OFFtime_MF_data(GFP_compile{i}-stdev_compile{i},time_compile{i});
    
    td_compile(i) = td_half;
    td2_compile(i) = td2_half;
    td3_compile(i) = td3_half;
    
    
    data_summary{i,2} = ta_half;
    data_summary{i,3} = ta2_half;
    data_summary{i,4} = ta3_half;
    data_summary{i,5} = td_half;
    data_summary{i,6} = td2_half;
    data_summary{i,7} = td3_half;    
    
    
    figure(1)
    subplot(5,5,i)
    boundedline(time_compile{i},GFP_norm,stdev_norm); hold on
    plot(ta_half,0.5,'bo'); hold on
    plot(ta2_half,0.5,'bo'); hold on
    plot(ta3_half,0.5,'bo'); hold on
    plot(td_half+960,0.5,'ro'); hold on
    plot(td2_half+960,0.5,'ro'); hold on
    plot(td3_half+960,0.5,'ro'); hold on
    ylim([0 1.1])
    
end