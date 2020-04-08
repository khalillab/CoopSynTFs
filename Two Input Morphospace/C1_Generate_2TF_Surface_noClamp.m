clear all

% Code generates 2 TF - Clamp Surfaces
% MATLAB R2016b

OutputName = '181119_2TF_Surfaces_noClamp';

%% Load Fit
load Fits/extrap_181115_Global_fixT2_4.mat ...
    Kp_meas Kp_approx Kt_meas Kt_approx ...
    Thi Tlow linTet_n linTet_EC50 TF2_hi

%% Unpack variables

% Concentrations
TF1_hi = Thi;
TF1_low = Tlow;

% TF2 Concentrations (See Final Expression Data in S4)
TF2_hi;                     % Extrapolated from fit
TF2_low = TF2_hi/40.1;      % Fold change of inducible system from 603 EST-GFP


%% Create Titration
L = 24;                 % # of points in Titration

% linTET-TF1 Titration

ATC = logspace(log10(1000),log10(0.1),96);
TF_perc = (ATC.^linTet_n)./(linTet_EC50^linTet_n + ATC.^linTet_n);
TF1_r = (Thi - Tlow)*TF_perc + Tlow;
TF1_r = TF1_r([1:12,end-11:end]);        % Pull Corners of distribution


% linZEV-TF2 Titration

linZEV_n = 1.34;            % LinZEV Dose response in HIS Locus
linZEV_EC50 = 0.85;         % LinZEV Dose response in HIS Locus

EST = logspace(log10(12.5),log10(0.05),96);
TF2_perc = (EST.^linZEV_n)./(linZEV_EC50^linZEV_n + EST.^linZEV_n);
TF2_r = fliplr((TF2_hi - TF2_low)*TF2_perc + TF2_low);
TF2_r = TF2_r([1:12,end-11:end]);       % Pull Corners of distribution


% 2D Dose - Create matrix of TF1 vs TF2 titration
Input = combvec(TF1_r,TF2_r);
TF1 = Input(1,:)';
TF2 = Input(2,:)';


%% Parameter Space

% Measured affinities we want to look at for 2 TF Behavior Space
Kt1_meas_range = [0.0065, 0.0136, 0.0300, 0.0420, 0.1430, 0.2240];	% 43-8 Affinities
Kt2_meas_range = [0.0150, 0.0320, 0.0670, 0.0950, 0.2180, 0.4150];	% 42-10 Affinities
Kp_meas_range = [0];         % PDZ affinities
N_range = 1:3;

% Find approximated affinitiess
for i=1:length(Kt1_meas_range)
    Kt1_approx_range(i) = Kt_approx(find(Kt1_meas_range(i)==Kt_meas));
    Kt2_approx_range(i) = Kt_approx(find(Kt2_meas_range(i)==Kt_meas));
end

Kp_approx_range = [0];         % PDZ affinities


% Create parameter space (measured affinities)
params_meas = combvec(Kt1_meas_range, Kp_meas_range, ...
                      Kt2_meas_range, Kp_meas_range, ...
                      N_range, N_range);
                  
% Create parameter space (extrapolated affinities)
params_approx = combvec(Kt1_approx_range, Kp_approx_range, ...
                      Kt2_approx_range, Kp_approx_range, ...
                      N_range, N_range);

% Storage Vector
out_stor = zeros(L^2,length(params_meas));

%% Generate Surfaces

% Iterate
for i=1:length(params_approx)
    
    Kt1 = params_approx(1,i);
    Kt2 = params_approx(3,i);
    N1  = params_approx(5,i);
    N2  = params_approx(6,i);
    
    y = [Kt1 Kt2];   % Compile Parameters
    
    
    tic
    Output = zeros(L^2,1);          % Storage
    % Run Surface
    for j=1:length(Input)
        Output(j) = meantxn_2TF_noClamp(y, TF1(j), TF2(j), N1, N2);
    end
    toc
    
    % Output Array
    out_stor(:,i) = Output;
    
end


%% Save Data
save([OutputName '.mat'],'params_approx','params_meas','out_stor')




