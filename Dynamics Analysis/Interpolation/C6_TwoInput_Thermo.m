function [ OutputName ] = TwoInput_Thermo( Name, start, finish )
% Create two input thermodynamic space
% Start = starting index
% Finish = finishign index
% Matlab R2013a

OutputName = [Name '_' num2str(start) '_' num2str(finish) '.mat']
start
finish

%% Load Fit
load Fits/extrap_181115_Global_fixT2_4.mat ...
    Kp_meas Kp_approx Kt_meas Kt_approx ...
    C_adh1 c_approx

%% Unpack variables

% Cooperativity constants
c2 = c_approx(2);
c3 = c_approx(3);
c4 = c_approx(4);
c5 = c_approx(5);
c6 = c_approx(6);

% Clamp concentration
C = C_adh1;

%% TF Ranges
L = 50;

TF1range = logspace(-4,-1,L);
TF2range = logspace(-7,-2.5,L);

Input = combvec(TF1range,TF2range);
TF1 = Input(1,:);
TF2 = Input(2,:);

%% Parameter Space

% Measured affinities we want to look at for 2 TF Behavior Space
Kt1_meas_range = [0.0065, 0.0136, 0.0300, 0.0420, 0.1430, 0.2240];	% 43-8 Affinities
Kt2_meas_range = [0.0150, 0.0320, 0.0670, 0.0950, 0.2180, 0.4150];	% 42-10 Affinities
Kp_meas_range  = [0.0620, 0.1800, 0.8800, 1.9700, 27.3000];         % PDZ affinities
N_range = 1:3;

% Find approximated affinitiess
for i=1:length(Kt1_meas_range)
    Kt1_approx_range(i) = Kt_approx(find(Kt1_meas_range(i)==Kt_meas));
    Kt2_approx_range(i) = Kt_approx(find(Kt2_meas_range(i)==Kt_meas));
end

for i=1:length(Kp_meas_range)
    Kp_approx_range(i) = Kp_approx(find(Kp_meas_range(i)==Kp_meas));
end

% Create parameter space (measured affinities)
params_meas = combvec(Kt1_meas_range, Kp_meas_range, ...
                      Kt2_meas_range, Kp_meas_range, ...
                      N_range, N_range);
                  
% Create parameter space (extrapolated affinities)
params = combvec(Kt1_approx_range, Kp_approx_range, ...
                      Kt2_approx_range, Kp_approx_range, ...
                      N_range, N_range);

% Storage Vector
surf_stor = zeros(length(Input),length(params_meas));

%% Run Surfaces

% Set-up parallelization for cluster
myCluster = parcluster('local') % cores on compute node to be "local"
if getenv('ENVIRONMENT') % true if this is a batch job
  myCluster.JobStorageLocation = getenv('TMPDIR')  % points to TMPDIR
end

ncores = 12;
matlabpool(myCluster, ncores)

% Iterate
parfor i=start:finish
    
    Kt1 = params(1,i);
    Kp1 = params(2,i);
    Kt2 = params(3,i);
    Kp2 = params(4,i);
    N1  = params(5,i);
    N2  = params(6,i);
    
    y = [Kt1 Kp1 Kt2 Kp2 c2 c3 c4 c5 c6];   % Compile Parameters
    
    tic
    Output = zeros(L^2,1);                  % Storage
    % Run Surface
    for j=1:length(Input)
        Output(j) = meantxn_2TF_gen(y, TF1(j), TF2(j), C, N1, N2);
    end
    toc
    
    % Output Array
    surf_stor(:,i) = Output;
    
end


%% Save Thermo
save(OutputName,'params','params_meas','surf_stor',...
    'start','finish','TF1range','TF2range')

end

