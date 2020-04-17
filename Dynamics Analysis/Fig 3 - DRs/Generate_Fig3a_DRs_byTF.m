clear all, clc, close all

% Code generates Dox-TF DRs for Figure 3a
% MATLAB 2016b

%% Parameters

% Load ThermoModel Fit
load Fits/extrap_181115_Global_fixT2_4.mat ...
    Kp_meas Kp_approx Kt_meas Kt_approx C_adh1 c_approx

% Unpack variables
% Cooperativity constants
c2 = c_approx(2);
c3 = c_approx(3);
c4 = c_approx(4);
c5 = c_approx(5);

%% TF Titration

% ZF Titration
TF = logspace(log10(10^0),log10(10^-3),50)';

% Clamp
C = C_adh1*ones(size(TF));


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
    start = [ data(1)-data(end)    data(end)    0.01   1.5 ];
    lb =    [ 0  0  0  0 ];
    ub =    [ 1  1  10^6  100 ];
    [cf1, res1] = lsqcurvefit(@hillguess,start,TF,data,lb,ub);  
 

    % Fit Hill NonLinear
    data = txn2;
    start = [ data(1)-data(end)    data(end)    0.01   1.5 ];
    lb =    [ 0  0  0  0 ];
    ub =    [ 1  1  10^6  100 ];
    [cf2, res2] = lsqcurvefit(@hillguess,start,TF,data,lb,ub);  




%% Plot DRs


figure
%     semilogx(TF,txn1,'o'); hold on
    semilogx(TF,hillguess(cf1,TF),'--')
    title(num2str(cf1(4)))
    set(gca,'FontSize',22)
    ylim([-0.05 1.05])
saveas(gcf,['Figures/LinearDR'],'pdf')

figure
%     semilogx(TF,txn2,'o'); hold on
    semilogx(TF,hillguess(cf2,TF),'--')
    title(num2str(cf2(4)))
    set(gca,'FontSize',22)
    ylim([-0.05 1.05])
saveas(gcf,['Figures/NonLinearDR'],'pdf')



cf1
cf2
