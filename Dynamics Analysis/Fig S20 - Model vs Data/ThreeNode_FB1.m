function dxdt = ThreeNode_FB1(t,x,time,DOX,k1,k2_t,k3,kdeg_TF1,kdeg_TF2,kdeg_GFP,kb_gabor,kb_cyc1,kb_cyc2,k2_fb,func1,func2,func3)

%% Network Structure
% Dox -> TF1; TF1+TF2 -> TF2; TF2 -> GFP
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
Therm1 = func1(TF1*10^-6);      % Interpolation of thermodynamic model
Therm2 = func2(TF2*10^-6);      % Feedback interpolation
dxdt(2) = kb_cyc1 + k2_t*Therm1 + k2_fb*Therm2 - kdeg_TF2*TF2;

%d[GFP]/dt
Therm3 = func3(TF2*10^-6);      % Interpolation of thermodynamic model
dxdt(3) = kb_cyc2 + k3*Therm3 - kdeg_GFP*GFP;

end