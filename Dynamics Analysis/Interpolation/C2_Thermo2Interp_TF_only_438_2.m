clear all

% Matlab R2013a
% 1D Interpolation of 43-8 TF-DNA interactions without clamp

OutputName = '181119_43_8_TFonly_FB1'; N_range = 1:3;
% OutputName = '181119_43_8_TFonly_2_5'; N_range = 2:5;

%% Load Fit
load Fits/extrap_181115_Global_fixT2_4.mat Kt_meas Kt_approx Thi Tlow

%% Initialize

TFrange = logspace(-6,0,500)';              % TF [] range

% 43-8 Measured Affinity range
Kt_438_meas_range  = [0.0065 0.0136 0.030 0.042 0.143 0.224];

% 43-8 Approximated Affinity range
for i=1:length(Kt_438_meas_range)
    Kt_438_approx_range(i) = Kt_approx(find(Kt_438_meas_range(i)==Kt_meas));
end

% Kp
Kp_range = [0];
Kp_meas_range = [0];

% Create Space
params = combvec(Kt_438_approx_range, Kp_range, N_range);
params_meas = combvec(Kt_438_meas_range, Kp_meas_range, N_range);

% Storage Vector
res_stor = zeros(1,length(params));
out_stor = zeros(length(TFrange),length(params));
poly_stor = zeros(length(TFrange),length(params));
func_stor = cell(1,length(params));

%% 1D Interpolations

for i=1:length(params)
    tic
    
    Kt = params(1,i);
    N  = params(3,i);
    
    % Run DR
    txn = [];
    txn = meantxn_cp_TFonly(Kt, TFrange, N);

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

%% Plot a few configs
figure
TFrange = logspace(-6,0,500)';
    
for i=1:length(params)
    F = func_stor{i};
    semilogx(TFrange,F(TFrange),'-'); hold on    
end

%% Save Data
OutputName = [OutputName '.mat'];
save(OutputName,'params','func_stor','res_stor','params_meas')