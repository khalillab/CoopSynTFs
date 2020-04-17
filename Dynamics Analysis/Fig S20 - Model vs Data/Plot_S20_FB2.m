clear all

%% Load MF Meta Data
load MF_configs_FB2.mat configs
% 1st col = Mat file
% 2nd col = starting index in MF movie
% 3rd col to last col = configuration parameters

folder = 'S20_Data_FB2/';

[m,n] = size(configs);

bg_fluor = 400;

%% Load Thermodynamic Model and Parameter Space

load ThermoModel/181119_Thermo_FB2 params params_meas ...
    ind1_stor ind2_stor

load ThermoModel/181119_2in_interp.mat func_stor
func1_stor = func_stor;
clear func_stor

load ThermoModel/181119_42_10_interp.mat func_stor
func2_stor = func_stor;
clear func_stor

%% Load Kinetic Parameters

load 181208_Fit6_5.mat kdeg_GFP kdeg_TF1 kdeg_TF2 ...
	T1hi T1_fold T1low T2low k1 kb_gabor kb_cyc1_2n k2_3N k3
    
k2_4n = k2_3N;      % 2nd node production rate with 4 operators (from fit)
k3_4n = k3;         % 3nd node production rate with 4 operators (from fit)

clear k2_3N k3


%% Initialize Time Series
tmin = 0*15;                    % t = 0
tmax = 267*15;                  % t = max
inc = 268;                     % # of time steps

% Induction time
DOX  = [ones(1,64) zeros(1,inc-64)];
time = linspace(tmin,tmax,inc);


%% Iterate thru files
extract_data = [];


for i=1:m
    
    % Load Data
    filename = configs{i,1};
    load([folder filename],'Data')
    
    % Find index in model
    ind = find((params_meas(1,:)==configs{i,3})&(params_meas(2,:)==configs{i,4})&...
        (params_meas(5,:)==configs{i,5})&(params_meas(3,:)==configs{i,6})&...
        (params_meas(4,:)==configs{i,7})&(params_meas(6,:)==configs{i,8})&...
        (params_meas(7,:)==configs{i,9})&(params_meas(8,:)==configs{i,10})&...
        (params_meas(9,:)==configs{i,11}));
    
    % Store indices
    configs{i,12} = ind;
    
    
    % RUN ODEs
    % Thermo Model
    func1 = func1_stor{ind1_stor(ind)};
    func2 = func2_stor{ind2_stor(ind)};
    
    % Rate Scaling based on number of operators   
    n  = params(9,ind);
    k2 = scaling(k2_4n,4,n);
    k3 = scaling(k3_4n,4,n);

    % Calculate B-Node Parameters
    T2low = 1;
    Therm1Low = func1(T1low*10^-6,T2low*10^-6);
    kb_cyc1_3N = kdeg_TF2*T2low;
    T2low_start = (kb_cyc1_3N + k2*Therm1Low)/kdeg_TF2;
    
    for j=1:50
        Therm1Low = func1(T1low*10^-6,T2low_start*10^-6);
        T2low_start = (kb_cyc1_3N + k2*Therm1Low)/kdeg_TF2;
    end    

    % Calculate C-Node Parameters
    Therm2Low = func2(T2low_start*10^-6);
    kb_cyc2_3N = kdeg_GFP*100;
    basal = (kb_cyc2_3N + k3*Therm2Low)/kdeg_GFP;       
    
    % Run ODEs
    initialC = [T1low, T2low_start, basal];
    [T,X] = ode23s(@(t,y)ThreeNode_FB2(t,y,time,DOX,k1,k2,k3,kdeg_TF1,kdeg_TF2,kdeg_GFP,kb_gabor,kb_cyc1_3N,kb_cyc2_3N,func1,func2), time, initialC);
    Model_GFP = X(:,3);
%     Model_GFP_norm = X(:,3)/max(X(:,3));
    Model_GFP_norm = (X(:,3)-basal)/(max(X(:,3))-basal); 
         
    % Calculate Model Ta, Td     
    [ka_half,ta_half] = ONtime_16(params(:,ind),Model_GFP_norm,time);
    [kd_half,td_half] = OFFtime_16(params(:,ind),Model_GFP_norm,time);
    
    % Prepare data
    st = configs{i,2};      % Start time
    GFP = Data(:,1)-bg_fluor;     % Subtract Background
    basal = mean(GFP(1:st-1));    % Basal GFP
    GFP = GFP(st:end);            % Correct Data
    stdev = Data(st:end,2);
    stdev_norm = Data(st:end,4);
    basal = min([basal min(GFP)]);
    GFP_norm = (GFP-basal)/(max(GFP)-basal);
    
    [ka_half,ta_half_meas] = ONtime_MF_data(GFP_norm,time);    
    [kd_half,td_half_meas] = OFFtime_MF_data(GFP_norm,time); 
    
    
%     % Plot Normalized
%     figure(1)
%     subplot(2,2,i)
%     st = 1; fin = 143;
%     boundedline(time(st:fin),GFP_norm(st:fin),stdev_norm(st:fin),'b-'); hold on
%     plot(time(st:fin),Model_GFP_norm(st:fin),'k--'); hold on
%     plot(960,0,'ro'); hold on
%     set(gca,'FontSize',20)
%     xlim([0 time(143)])
%     ylim([0 1.3])

    
%     % Plot Raw
%     figure(2)
%     subplot(2,2,i)
%     st = 1; fin = 143;
%     boundedline(time(st:fin),GFP(st:fin),stdev(st:fin),'b-'); hold on
%     plot(time(st:fin),Model_GFP(st:fin),'k--'); hold on
%     plot(960,0,'ro'); hold on
%     set(gca,'FontSize',20)
%     xlim([0 time(143)])
    
    % Plot Normalized + extended time axis
    figure(3)
    subplot(2,2,i)
    st = 1; fin = 143;
    boundedline(time(st:fin),GFP_norm(st:fin),stdev_norm(st:fin),'b-'); hold on
    plot(time,Model_GFP_norm,'k--'); hold on
    plot(960,0,'ro'); hold on
    set(gca,'FontSize',20)
    xlim([0 time(end)])
    ylim([0 1.3])    
    
    
    % Plot Model Ta vd Td
    figure(4)
    plot(ta_half,td_half,'o','Color',[58,31,90]/255); hold on
    set(gca,'FontSize',18)
    xlim([0 1500])
    ylim([0 3000])
    
    
    % Model vs Data - activation
    figure(6)
    
    diff_ta = abs(time-ta_half);
    diff_ta_sort = sort(diff_ta);
    ind_low = find(diff_ta_sort(1)==diff_ta);
    ind_high = find(diff_ta_sort(2)==diff_ta);
    
    GFP_meas(i) = mean([GFP_norm(ind_low) GFP_norm(ind_high)]);
    ta_pred(i) = ta_half;
    
    plot([ta_half ta_half],[GFP_norm(ind_low) GFP_norm(ind_high)]-0.5,'ro-'); hold on
    plot([200 1000],[0 0],'k--')
    set(gca,'FontSize',20)
    ylim([-0.5 0.5])    
    
    extract_data(i,:) = [ta_half td_half ta_half_meas td_half_meas GFP_norm(ind_low) GFP_norm(ind_high)];

end

ta_pred = ta_pred'
GFP_meas = GFP_meas'

