function dxdt = TwoNode(t,x,time,DOX,k1,k2,kbasal_gabor,kbasal_cyc1,kdeg_TF1,kdeg_GFP,func)

%% Network Structure
% Dox -> TF1 -> GFP
% Note: Experimental Dox = 0 to 10 µg/mL, Simulation Dox = 0 to 1
% Note: TF concentrations are scaled up by 10^6 to avoid MATRIX scaling
% problems when ODE is running

%% Initialize
dxdt = zeros(2,1);          % ODE column Vector

DOXI = interp1(time,DOX,t);
TF1 = x(1);
GFP = x(2);

%% Parameters

%% Dox -> TF
n1 = 1.376;               % Measured Hill
Km1 = 0.4527;             % Measured EC50/10

% kbasal_gabor;           % basal production of TF1
% k1;                     % production of TF1
% kdeg_TF1;               % TF1 dilution rate

%% TF -> GFP
% kbasal_cyc1;            % basal production of GFP from URA cyc1 promoter
% k2;                     % GFP production
% kdeg_GFP;               % GFP dilution rate

%% Equations

% d[TF1]/dt
dxdt(1) = kbasal_gabor + k1*DOXI^n1/(Km1^n1 + DOXI^n1) - kdeg_TF1*TF1;

%d[GFP]/dt
Therm1 = func(TF1*10^-6);       % Interpolation of thermodynamic model
dxdt(2) = kbasal_cyc1 + k2*Therm1 - kdeg_GFP*GFP;

end