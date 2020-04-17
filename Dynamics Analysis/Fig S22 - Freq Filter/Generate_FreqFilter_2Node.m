clear all

OutputName = '181209_Freq_2Node.mat';

%% Initialize Time Series
L = 20;
time_range = logspace(log10(90),log10(12000),L);
mult = round(time_range/45);
time_range = 45*mult;
freq_range = time_range.^-1;

% Create time courses
tmax = 200*15;
inc  = 201;
time = linspace(0,tmax,inc);
dc = 1/3;
t_on = time_range*dc;

DOX_stor = [];
for j=1:L
    A = [];
    for i=1:100
        A = [A ones(1,t_on(j)/15) zeros(1,t_on(j)*2/15)];
    end
    DOX_stor(j,:) = A(1:inc);
end
clear A
clear i
clear j

% % Plot DOX titration
% figure, imagesc(DOX_stor)


%% Load Kinetic Parameters

load 181208_Fit6_5.mat kdeg_GFP kdeg_TF1 k2_2n T1hi T1_fold ...
    k1 kb_gabor T1low kb_cyc1_2n

%% Load Thermodynamic Model and Parameter Space

load ThermoModel/181119_Thermo_2N.mat params params_meas func_stor

%% Initialize Storage Arrays
gain_stor = zeros(L,length(params));
AUC_stor = zeros(L,length(params));
% global_stor = cell(1,length(params));
tElapsed = zeros(1,length(params));

%% Loop and run Time Series

% Run through parameters
parfor i=1:length(params)

    % Thermo Model
    func = func_stor{i};
    
    % Rate Scaling based on number of operators    
    n = params(3,i);
    k2 = scaling(k2_2n,2,n);

    % Calculate Basal
    ThermLow = func(T1low*10^-6);
    basal = (kb_cyc1_2n + k2*ThermLow)/kdeg_GFP;
    
    % Storage vectors
    stor_GFP = zeros(inc,L);
    GFP_temp = zeros(inc,1);
    gain_temp = zeros(L,1);
     
    tic
    for j=1:L
        % DOX
        DOX = DOX_stor(j,:);

        % Run 2 Node ODE
        initialC = [T1low basal];
        [T,X] = ode23s(@(t,y)TwoNode(t,y,time,DOX,k1,k2,kb_gabor,kb_cyc1_2n,kdeg_TF1,kdeg_GFP,func), time, initialC);
        
        % Store GFP trace and max GFP
        GFP_temp = X(:,2);
        stor_GFP(:,j) = GFP_temp;
        gain_temp(j) = max(GFP_temp);
    end
    toc
    
	tElapsed(i) = toc;
    
%     global_stor{i} = stor_GFP;
    gain_stor(:,i) = gain_temp;    
    AUC_stor(:,i) = sum(stor_GFP)/max(max(stor_GFP));   

end

avgTime = mean(tElapsed)

%% Save
save(OutputName,'params','params_meas','time_range','freq_range', ... 
    'DOX_stor','gain_stor','tElapsed','AUC_stor');
