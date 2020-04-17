clear all

%% Load MF Meta Data
load MF_configs_FB1.mat configs
% 1st col = Mat file
% 2nd col = starting index in MF movie
% 3rd col to last col = configuration parameters

folder = 'S20_Data_FB1/';

[m,n] = size(configs);

bg_fluor = 400;

%% Load Thermodynamic Model and Parameter Space

load ThermoModel/181119_Thermo_FB1 params params_meas ...
    ind1_stor ind2_stor ind3_stor

load ThermoModel/181119_43_8_TFonly_FB1.mat func_stor
func1_stor = func_stor;
clear func_stor

load ThermoModel/181119_Set_42_10.mat func_stor
func2_stor = func_stor;
func3_stor = func_stor;
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
data_stor = {};

for i=1:m
    
    % Load Data
    filename = configs{i,1};
    load([folder filename],'Data')
    
    % Find index in model
    ind = find((params_meas(1,:)==configs{i,3})&(params_meas(2,:)==configs{i,4})&...
        (params_meas(3,:)==configs{i,5})&(params_meas(4,:)==configs{i,6})&...
        (params_meas(5,:)==configs{i,7})&(params_meas(6,:)==configs{i,8})&...
        (params_meas(7,:)==configs{i,9})&(params_meas(8,:)==configs{i,10})&...
        (params_meas(9,:)==configs{i,11}));
    
    % Store indices
    configs{i,12} = ind;

    % Run ODEs
    % Thermo Model
    func1 = func1_stor{ind1_stor(ind)};
    func2 = func2_stor{ind2_stor(ind)};
    func3 = func3_stor{ind3_stor(ind)};
    
    % Rate Scaling based on number of operators   
    n1  = params(3,ind);
    n2  = params(6,ind);
    N = n1+n2;
    k2_t = scaling(k2_4n,4,n1);
    k2_fb = scaling(k2_4n,4,n2);
    k3 = scaling(k3_4n,4,n2);

    % Calculate B-Node Parameters
    Therm1Low = func1(T1low*10^-6);
    
    T2low = 1;
    Therm2Low = func2(T2low*10^-6);
    kb_cyc1_3N = kdeg_TF2*T2low;
    T2low_start = (kb_cyc1_3N + k2_t*Therm1Low + k2_fb*Therm2Low)/kdeg_TF2;
    
    for j=1:50
        Therm2Low = func2(T2low_start*10^-6);
        T2low_start = (kb_cyc1_3N + k2_t*Therm1Low + k2_fb*Therm2Low)/kdeg_TF2;
    end

    % Calculate C-Node Parameters
    Therm3Low = func3(T2low_start*10^-6);
    kb_cyc2_3N = kdeg_GFP*100;
    basal = (kb_cyc2_3N + k3*Therm3Low)/kdeg_GFP;       
    
    % Run ODEs
    initialC = [T1low, T2low_start, basal];
    [T,X] = ode23s(@(t,y)ThreeNode_FB1(t,y,time,DOX,k1,k2_t,k3,kdeg_TF1,kdeg_TF2,kdeg_GFP,kb_gabor,kb_cyc1_3N,kb_cyc2_3N,k2_fb,func1,func2,func3), time, initialC);
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

    % Calculate Microfluidics Ta, Td     
    [ka_half,ta_half_meas] = ONtime_MF_data(GFP_norm,time);    
    [kd_half,td_half_meas] = OFFtime_MF_data(GFP_norm,time);    
    
    % Plot Normalized
    figure(1)
    subplot(4,4,i)
    st = 1; fin = 143;
    boundedline(time(st:fin),GFP_norm(st:fin),stdev_norm(st:fin),'b-'); hold on
    plot(time(st:fin),Model_GFP_norm(st:fin),'k--'); hold on
    plot(ta_half,0.5,'ko'); hold on
    plot(td_half+960,0.5,'ko'); hold on
    plot(ta_half_meas,0.5,'ro'); hold on
    plot(td_half_meas+960,0.5,'ro'); hold on
    plot(960,0,'ro'); hold on
    set(gca,'FontSize',20)
    xlim([0 time(143)])
    ylim([0 1.3])

    
    
    % Find measued GFP value at predicted ta
    diff_ta = abs(time-ta_half);
    diff_ta_sort = sort(diff_ta);
    ind_ta_low = find(diff_ta_sort(1)==diff_ta);
    ind_ta_high = find(diff_ta_sort(2)==diff_ta);
    GFP_ta_meas(i) = mean([GFP_norm(ind_ta_low) GFP_norm(ind_ta_high)]);
    ta_pred(i) = ta_half;
    
    
    extract_data(i,:) = [ta_half td_half ta_half_meas td_half_meas GFP_norm(ind_ta_low) GFP_norm(ind_ta_high)];
    
    st = 1; fin = 143;
    data_stor{i} = [time(st:fin)' GFP_norm(st:fin) Model_GFP_norm(st:fin)];
    
    n_stor(i) = configs{i,11};

end

%% Save Data
save('181216_FB1_Analysis.mat','extract_data','data_stor','n_stor')