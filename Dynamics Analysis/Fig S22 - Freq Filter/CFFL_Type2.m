function dxdt = CFFL_Type2(t,x,time,DOX,k1,k2,k3,kdeg_TF1,kdeg_TF2,kdeg_GFP,kb_gabor,kb_cyc1,kb_cyc2,func1,func2)

%% Network Structure
% Dox -> TF1; TF1xTF2 -> TF2; TF1xTF2 -> GFP
% Note: Experimental Dox = 0 to 10 µg/mL, Simulation Dox = 0 to 1
% Note: TF concentrations are scaled up by 10^6 to avoid MATRIX scaling
% problems when ODE is running

%% Initialize
dxdt = zeros(3,1);          % ODE Column Vector

DOXI = interp1(time,DOX,t);
TF1 = x(1);
TF2 = x(2);
GFP = x(3);

%% Dox -> TF1 Parameters
% k1;
n1 = 1.376;               % Measured Hill
Km1 = 0.4527;             % Measured EC50/10

%% Equations

% d[TF1]/dt
dxdt(1) = kb_gabor + k1*DOXI^n1/(Km1^n1 + DOXI^n1) - kdeg_TF1*TF1;

%d[TF2]/dt
Therm1 = func1(TF1*10^-6,TF2*10^-6);        % Interpolation of thermodynamic model
dxdt(2) = kb_cyc1 + k2*Therm1 - kdeg_TF2*TF2;

%d[GFP]/dt
Therm2 = func2(TF1*10^-6,TF2*10^-6);        % Interpolation of thermodynamic model
dxdt(3) = kb_cyc2 + k3*Therm2 - kdeg_GFP*GFP;

end