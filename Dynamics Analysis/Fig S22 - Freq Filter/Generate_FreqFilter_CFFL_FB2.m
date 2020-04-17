clear all

OutputName = '181209_Freq_CFFL_FB2.mat';

%% Initialize Time Series
L = 20;
time_range = [logspace(log10(90),log10(10000),L-1) 30000];
mult = round(time_range/45);
time_range = 45*mult;
freq_range = time_range.^-1;

% Create time courses
tmax = 200*15;
inc  = 201;
time = linspace(0,tmax,inc);
dc = 1/3;
t_on = time_range*dc;

% DOX Titration
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

load 181208_Fit6_5.mat kdeg_GFP kdeg_TF1 kdeg_TF2 ...
	T1hi T1_fold T1low T2low k1 kb_gabor kb_cyc1_2n k2_3N k3

k2_4n = k2_3N;      % 2nd node production rate with 4 operators (from fit)
k3_4n = k3;         % 3nd node production rate with 4 operators (from fit)

clear k2_3N k3

%% Load Thermodynamic Model and Parameter Space

load ThermoModel/181119_CFFL_Type2.mat params params_meas ...
    ind1_stor ind2_stor

load ThermoModel/181119_2in_interp.mat func_stor
func1_stor = func_stor;
func2_stor = func_stor;
clear func_stor

%% Initialize Storage Arrays
TF2_stor = zeros(L,length(params));
gain_stor = zeros(L,length(params));
AUC_stor = zeros(L,length(params));
% global_stor = cell(1,length(params));
tElapsed = zeros(1,length(params));

%% Loop and run Time Series
% Set-up parallelization for cluster
ncores = 12;
myCluster = parcluster('local') % cores on compute node to be "local"
if getenv('ENVIRONMENT') % true if this is a batch job
  myCluster.JobStorageLocation = getenv('TMPDIR')  % points to TMPDIR
  ncores = str2num(getenv('NSLOTS'));
end
matlabpool(myCluster, ncores)


% Run through parameters
parfor i=1:length(params)

    % Thermo Model
    func1 = func1_stor{ind1_stor(i)};
    func2 = func2_stor{ind2_stor(i)};
    
    % Rate Scaling based on number of operators   
    n  = params(5,i)+params(6,i);
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
    Therm2Low = func2(T1low*10^-6,T2low_start*10^-6);
    kb_cyc2_3N = kdeg_GFP*100;
    basal = (kb_cyc2_3N + k3*Therm2Low)/kdeg_GFP;   
    
    % Storage vectors
    stor_GFP = zeros(inc,L);
    GFP_temp = zeros(inc,1);
    gain_temp = zeros(L,1);
    TF2_temp = zeros(L,1);
    
    tic
    for j=1:L
        % DOX
        DOX = DOX_stor(j,:);

        % Run ODEs
        initialC = [T1low, T2low_start, basal];
        [T,X] = ode23s(@(t,y)CFFL_Type2(t,y,time,DOX,k1,k2,k3,kdeg_TF1,kdeg_TF2,kdeg_GFP,kb_gabor,kb_cyc1_3N,kb_cyc2_3N,func1,func2), time, initialC);
        
        % Store GFP trace and max GFP
        GFP_temp = X(:,3);
        stor_GFP(:,j) = GFP_temp;
        gain_temp(j) = max(GFP_temp);
        TF2_temp(j) = max(X(:,2));
    end
    toc
    
	tElapsed(i) = toc;
    
%     global_stor{i} = stor_GFP;
    gain_stor(:,i) = gain_temp;    
    AUC_stor(:,i) = sum(stor_GFP)/max(max(stor_GFP));   
    TF2_stor(:,i) = TF2_temp;   

end

avgTime = mean(tElapsed)

%% Save
save(OutputName,'params','params_meas','time_range','freq_range', ... 
    'DOX_stor','gain_stor','tElapsed','TF2_stor','AUC_stor');
