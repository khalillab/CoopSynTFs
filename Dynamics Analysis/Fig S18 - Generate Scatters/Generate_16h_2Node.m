clear all

OutputName = '181209_16h_2Node.mat';

%% Initialize Time Series
tmin = 0*15;                    % t = 0
tmax = 300*15;                  % t = max
inc = 301;                     % # of time steps

% Induction time
DOX  = [ones(1,64) zeros(1,237)];
time = linspace(tmin,tmax,inc);

%% Load Kinetic Parameters

load 181208_Fit6_5.mat kdeg_GFP kdeg_TF1 k2_2n T1hi T1_fold ...
    k1 kb_gabor T1low kb_cyc1_2n

%% Load Thermodynamic Model and Parameter Space

load ThermoModel/181119_Thermo_2N.mat params params_meas func_stor

%% Initialize Storage Arrays
GFP_ON_stor = zeros(inc,length(params));
GFP_ON_norm_stor = zeros(inc,length(params));

basal_stor = zeros(1,length(params));
TF1_max = zeros(1,length(params));

%% Loop and run Time Series

for i=1:length(params)
    tic
    
    % Thermo Model
    func = func_stor{i};
    
    % Rate Scaling based on number of operators    
    n = params(3,i);
    k2 = scaling(k2_2n,2,n);

    % Calculate Basal
    ThermLow = func(T1low*10^-6);
    basal = (kb_cyc1_2n + k2*ThermLow)/kdeg_GFP;
    
    % Run 2 Node ODE
    initialC = [T1low basal];
    [T,X] = ode23s(@(t,y)TwoNode(t,y,time,DOX,k1,k2,kb_gabor,kb_cyc1_2n,kdeg_TF1,kdeg_GFP,func), time, initialC);

    % Store output
    TF1_ON_stor = X(:,1);
    TF1_max(i) = max(X(:,1));
    
    GFP_ON = X(:,2);
    GFP_ON_norm = (GFP_ON-basal)/max(GFP_ON-basal);
    GFP_ON_stor(:,i) = GFP_ON; 
    GFP_ON_norm_stor(:,i) = GFP_ON_norm;
    basal_stor(i) = basal;
    
   toc
end

clear func_stor

%% Save
save(OutputName);

%% Plot
figure
plot(time,GFP_ON_stor)

figure
plot(time,GFP_ON_norm_stor)
ylim([0 1.1])

figure
plot(TF1_max,'o')

