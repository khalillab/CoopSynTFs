clear all, clc, close all

% Code generates Dox-TF DRs for Figure 3a
% MATLAB 2016b

%% Parameters

% Load ThermoModel Fit
load Fits/extrap_181115_Global_fixT2_4.mat ...
    Kp_meas Kp_approx Kt_meas Kt_approx C_adh1 c_approx

% Load Dynamics Fit for DOX-related parameters
load Fits/181208_Fit6_5 ...
    T1hi T1low

Thi = T1hi/10^6;
Tlow = T1low/10^6;

% Unpack variables
% Cooperativity constants
c2 = c_approx(2);
c3 = c_approx(3);
c4 = c_approx(4);
c5 = c_approx(5);


%% TF Titration

linTet_n = 1.376;               % Measured DOX Hill
linTet_EC50 = 4.527;             % Measured DOX EC50


% ZF Titration
DOX = logspace(log10(100),log10(0.01),50)';
TF_perc = (DOX.^linTet_n)./(linTet_EC50^linTet_n + DOX.^linTet_n);
TF = (Thi - Tlow)*TF_perc + Tlow;

% Clamp
C = C_adh1*ones(size(DOX));


%% Calculate DRs

    
    % Linear Configuration
    Kt_m = 0.0136;
    N  = 2;
    Kt = Kt_approx(find(Kt_m==Kt_meas));
    txn1 = meantxn_cp_TFonly(Kt, TF, N);
        
    % Linear Configuration
    Kt_m = 0.224;
    Kp_m = 1.97;
    Kt = Kt_approx(find(Kt_m==Kt_meas));
    Kp = Kp_approx(find(Kp_m==Kp_meas));
    N = 4;
    
    txn2 = meantxn_cp_ANY([Kt Kp c2 c3 c4 c5], TF, C, N);

    
    % Fit Hill Linear
    data = txn1;
    start = [ data(1)-data(end)    data(end)    linTet_EC50   linTet_n ];
    lb =    [ 0  0  0  0 ];
    ub =    [ 1  1  10^6  100 ];
    [cf1, res1] = lsqcurvefit(@hillguess,start,DOX,data,lb,ub);  
 

    % Fit Hill NonLinear
    data = txn2;
    start = [ data(1)-data(end)    data(end)    linTet_EC50   linTet_n ];
    lb =    [ 0  0  0  0 ];
    ub =    [ 1  1  10^6  100 ];
    [cf2, res2] = lsqcurvefit(@hillguess,start,DOX,data,lb,ub);  




%% Plot DRs

figure
    semilogx(DOX,hillguess(cf1,DOX)/max(hillguess(cf1,DOX)),'--'); hold on
    title(['nh=' num2str(cf1(4)) ' and EC50=' num2str(cf1(3))])
    set(gca,'FontSize',22)
    xlim([0.07 40])
    ylim([-0.05 1.05])
saveas(gcf,['Figures/DOX_LinearDR'],'pdf')

figure
    semilogx(DOX,hillguess(cf2,DOX)/max(hillguess(cf2,DOX)),'--'); hold on    
    title(['nh=' num2str(cf2(4)) ' and EC50=' num2str(cf2(3))])
    set(gca,'FontSize',22)
    xlim([0.07 40])
    ylim([-0.05 1.05])
saveas(gcf,['Figures/DOX_NonLinearDR'],'pdf')





cf1
cf2
