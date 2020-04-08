%% delaG_generator script %%
% Generates deltaG plots
% Units are in mM
% 1000 µM or 1mM is used as reference concentration

clearvars

%% Initialize
% n = [1 2 3 4 5];
n = [1 1 1 1 1];

% Load Fit
load Fits/extrap_181115_Global_fixT2_4.mat ...
    Kp_meas Kp_approx Kt_meas Kt_approx C_adh1 Thi Tlow linTet_n linTet_EC50 c_approx

% Unpack variables
% Cooperativity constants
Kc2 = c_approx(2);
Kc3 = c_approx(3);
Kc4 = c_approx(4);
Kc5 = c_approx(5);

scale = 10^-3;      % Units are in mM

%% CONFIG 1

% Constants
Kt = 0.01*scale ;
Kp = 50*scale ;

% Calculate Free Energies
N5_TF = [Kt Kt^2 Kt^3 Kt^4 Kt^5];
N5_TF_C = [Kt*Kp Kt^2*Kp^2*Kc2 Kt^3*Kp^3*Kc3 Kt^4*Kp^4*Kc4 Kt^5*Kp^5*Kc5];
N5_TF_PDZ = [Kt*Kp Kt^2*Kp^2 Kt^3*Kp^3 Kt^4*Kp^4 Kt^5*Kp^5];

N5_TF = log(N5_TF./((1000*scale).^n));          % TF bound states (blue)
N5_TF_C = log(N5_TF_C./((1000*scale).^n));      % TF-Clamp-DNA bound states (red)
N5_TF_PDZ = log(N5_TF_PDZ./((1000*scale).^n));  % TF-Clamp-DNA WITHOUT cooperativity constant (magenta)

% Plot
figure
plot(1,0,'g.',ones(1,length(N5_TF)), N5_TF, 'b.', ones(1,length(N5_TF_C)), N5_TF_C, 'r.')
hold on


%% CONFIG 2

% Constants
Kt = 0.01*scale ;
Kp = 50*scale ;


% Calculate Free Energies
N5_TF = [Kt Kt^2 Kt^3 Kt^4 Kt^5];
N5_TF_C = [Kt*Kp Kt^2*Kp^2*Kc2 Kt^3*Kp^3*Kc3 Kt^4*Kp^4*Kc4 Kt^5*Kp^5*Kc5];
N5_TF_PDZ = [Kt*Kp Kt^2*Kp^2 Kt^3*Kp^3 Kt^4*Kp^4 Kt^5*Kp^5];

N5_TF = log(N5_TF./((1000*scale).^n));          % TF bound states (blue)
N5_TF_C = log(N5_TF_C./((1000*scale).^n));      % TF-Clamp-DNA bound states (red)
N5_TF_PDZ = log(N5_TF_PDZ./((1000*scale).^n));  % TF-Clamp-DNA WITHOUT cooperativity constant (magenta)

% Plot
plot(2,0,'g.',2*ones(1,length(N5_TF)), N5_TF, 'b.', 2*ones(1,length(N5_TF_C)), N5_TF_C, 'r.')
hold on


%% CONFIG 3

% Constants
Kt = 0.5*scale ;
Kp = 0.1*scale ;

% Calculate Free Energies
N5_TF = [Kt Kt^2 Kt^3 Kt^4 Kt^5];
N5_TF_C = [Kt*Kp Kt^2*Kp^2*Kc2 Kt^3*Kp^3*Kc3 Kt^4*Kp^4*Kc4 Kt^5*Kp^5*Kc5];
N5_TF_PDZ = [Kt*Kp Kt^2*Kp^2 Kt^3*Kp^3 Kt^4*Kp^4 Kt^5*Kp^5];

N5_TF = log(N5_TF./((1000*scale).^n));          % TF bound states (blue)
N5_TF_C = log(N5_TF_C./((1000*scale).^n));      % TF-Clamp-DNA bound states (red)
N5_TF_PDZ = log(N5_TF_PDZ./((1000*scale).^n));  % TF-Clamp-DNA WITHOUT cooperativity constant (magenta)

% Plot
plot(3,0,'g.',3*ones(1,length(N5_TF)), N5_TF, 'b.', 3*ones(1,length(N5_TF_C)), N5_TF_C, 'r.')

xlim([0,4])


%% Save Plot
saveas(gcf,['Plots/S11_DeltaG_bars'],'pdf')