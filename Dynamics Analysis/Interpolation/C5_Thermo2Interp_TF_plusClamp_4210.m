clear all

% Matlab R2013a
% 1D Interpolation of 42-10 TF-DNA interactions with clamp

OutputName = '181119_42_10_interp';

%% Load Fit
load Fits/extrap_181115_Global_fixT2_4.mat ...
    Kt_meas Kt_approx Kp_meas Kp_approx C_adh1 c_approx Thi Tlow

%% Initialize

TFrange = logspace(-7,-1,500)';              % TF [] range (µM)
C = C_adh1*ones(length(TFrange),1);         % Clamp Concentration (µM)

% Cooperativity constants
c2 = c_approx(2);
c3 = c_approx(3);
c4 = c_approx(4);
c5 = c_approx(5);

% 42-10 Measured Affinity range
Kt_4210_meas_range  = [0.0024 0.015 0.032 0.067 0.095 0.218];

% 43-8 Approximated Affinity range
for i=1:length(Kt_4210_meas_range)
    Kt_4210_approx_range(i) = Kt_approx(find(Kt_4210_meas_range(i)==Kt_meas));
end

% Kp Measured Affinity range
Kp_meas_range = [0.062 0.18 0.88 1.97 27.3];

% Kp Approximated Affinity range
for i=1:length(Kp_meas_range)
    Kp_approx_range(i) = Kp_approx(find(Kp_meas_range(i)==Kp_meas));
end

% Number of operators
N_range = 2:5;

% Create Space
params = combvec(Kt_4210_approx_range, Kp_approx_range, N_range);
params_meas = combvec(Kt_4210_meas_range, Kp_meas_range, N_range);

% Storage Vector
res_stor = zeros(1,length(params));
out_stor = zeros(length(TFrange),length(params));
poly_stor = zeros(length(TFrange),length(params));
func_stor = cell(1,length(params));

%% 1D Interpolations

parfor i=1:length(params)
    tic
    
    Kt = params(1,i);
    Kp = params(2,i);
    N  = params(3,i);
    
    % Run DR
    txn = zeros(size(TFrange));   
    txn = meantxn_cp_ANY([Kt Kp c2 c3 c4 c5], TFrange, C, N);

    % 1D Interpolation
    F = griddedInterpolant(TFrange,txn,'pchip');
    
    % Store interpolation
    func_stor{i} = F;
    
    % Evaluate and store interpolation over TF range
    temp = func_stor{i};
    poly_stor(:,i) = temp(TFrange);
    
    % Store output and goodness of interpolation
    out_stor(:,i) = txn;
    res_stor(i) = sum((out_stor(:,i)-poly_stor(:,i)).^2);
   
    toc
end

%% Plot a few circuits


figure
TFrange = logspace(-7,-1,500)';
    
% for i=1:120
for i=[62,68,74]

    F = func_stor{i};
    semilogx(TFrange,F(TFrange),'-'); hold on    
end

%% Save Data
OutputName = [OutputName '.mat'];
save(OutputName,'params','func_stor','res_stor','params_meas')