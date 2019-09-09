%% Function for fitting Competition Data - Fig S2/3 %%
%  ALL UNITS: µM

clear all, clc

%%  INPUT

% Experimental Conditions
Rt   = 0.1984;         % TF Concentration
Kd1  = 0.025;          % TF-Probe Affinity
Lt_s = 0.010;          % Probe concentration

% Import Data
load Sample.mat Data
Lt   = Data(:,1);       % Import Titration of Competitor concentration
Fb   = Data(:,2);       % Import Measured Fraction Bound


%% Solve for Kd2 (TF-competitor affinity)

x0 = [ Kd1 ];                                           % Initial Affinity Guess
fun = @(x,xdata) WangExact(x, xdata, Rt, Lt_s, Kd1 );   % Function Handle

lb = Kd1/10^3;                          % Lower bound on fit
ub = Kd1*10^4;                          % Upper bound on fit
options=optimset('TolFun', 1e-12);      % Set Fitting Tolerance

[x, res] = lsqcurvefit(fun,x0,Lt,Fb,lb,ub,options);    % Run Fit
Kd2 = x  % TF-competitor affinity


%% Plot
figure
    semilogx(Lt,Fb,'bo')        % Data
    hold on
    Lt = logspace(-3,2,100);    % Fitted Line
    semilogx(Lt,fun(x,Lt),'r-')
    ylim([0 1])
    xlabel('[Competitor] (uM)')
    ylabel('fraction probe bound')