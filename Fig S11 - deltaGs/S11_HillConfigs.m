clear all

% Creates dose responses for 3 configurations
% MATLAB 2016b

%% Initialize

% Load Fit
load Fits/extrap_181115_Global_fixT2_4.mat ...
    Kp_meas Kp_approx Kt_meas Kt_approx C_adh1 Thi Tlow linTet_n linTet_EC50 c_approx

% Unpack variables
% Cooperativity constants
c2 = c_approx(2);
c3 = c_approx(3);
c4 = c_approx(4);
c5 = c_approx(5);


%% Create parameter space  
Kt_range = [0.01 0.5] ;
Kp_range = [50 0.1] ;

%% TF Titration

TF = logspace(log10(10^0),log10(10^-4),50)';
C = C_adh1*ones(size(TF));                    % Clamp Titration

%% RUN SIMULATIONS
% Low Kt, high Kp, n=2
    Kt = Kt_range(1);
    Kp = Kp_range(1);
    N = 2;
    
    % Create Dose Response
    Data =  meantxn_cp_ANY([Kt Kp c2 c3 c4 c5], TF, C, N);
%     Data = Data/max(Data);

    % Fit Hill
    start = [ Data(1)-Data(end) Data(end)    TF(15)   3 ];
    lb =    [ 0    0    0     0   ];
    ub =    [ 1.1  0.9  1  100 ];
    [cf, res] = lsqcurvefit(@hillguess,start,TF,Data,lb,ub);

    % Plot
    figure(1)
%     semilogx(TF,Data,'bo'); hold on
    semilogx(TF,hillguess(cf,TF),'b-')
    xlim([TF(end) TF(1)])
    ylim([-0.05 1.05])
    text(2*TF(end),0.9,['nH=' sprintf('%.2f',cf(4))],'FontSize',18);
    text(2*TF(end),0.75,['EC_5_0=' sprintf('%.2f',cf(3))],'FontSize',18);
    set(gca,'FontSize',18)
    cf(3)
    saveas(gcf,['Plots/S11_Hill_Config1'],'pdf')
    
 % Low Kt, high Kp, n=5
    Kt = Kt_range(1);
    Kp = Kp_range(1);
    N = 5;
    
    % Create Dose Response
    Data =  meantxn_cp_ANY([Kt Kp c2 c3 c4 c5], TF, C, N);
%     Data = Data/max(Data);

    % Fit Hill
    start = [ Data(1)-Data(end) Data(end)    TF(15)   2 ];
    lb =    [ 0    0    0     0   ];
    ub =    [ 1.1  0.9  10^9  100 ];
    [cf, res] = lsqcurvefit(@hillguess,start,TF,Data,lb,ub);

    % Plot
    figure(2)
%     semilogx(TF,Data,'bo'); hold on
    semilogx(TF,hillguess(cf,TF),'b-')
    xlim([TF(end) TF(1)])
    ylim([-0.05 1.05])
    text(2*TF(end),0.9,['nH=' sprintf('%.2f',cf(4))],'FontSize',18);
    text(2*TF(end),0.75,['EC_5_0=' sprintf('%.2f',cf(3))],'FontSize',18);
    set(gca,'FontSize',18)
    cf(3)
    saveas(gcf,['Plots/S11_Hill_Config2'],'pdf')

% High Kt, low Kp, n=5
    Kt = Kt_range(2);
    Kp = Kp_range(2);
    N = 5;
    
    % Create Dose Response
    Data =  meantxn_cp_ANY([Kt Kp c2 c3 c4 c5], TF, C, N);
%     Data = Data/max(Data);

    % Fit Hill
    start = [ Data(1)-Data(end) Data(end)    TF(15)   2 ];
    lb =    [ 0    0    0     0   ];
    ub =    [ 1.1  0.9  10^9  100 ];
    [cf, res] = lsqcurvefit(@hillguess,start,TF,Data,lb,ub);

    % Plot
    figure(3)
%     semilogx(TF,Data,'bo'); hold on
    semilogx(TF,hillguess(cf,TF),'b-')
    xlim([TF(end) TF(1)])
    ylim([-0.05 1.05])
    text(2*TF(end),0.9,['nH=' sprintf('%.2f',cf(4))],'FontSize',18);
    text(2*TF(end),0.75,['EC_5_0=' sprintf('%.2f',cf(3))],'FontSize',18);
    set(gca,'FontSize',18)
    cf(3)
    saveas(gcf,['Plots/S11_Hill_Config3'],'pdf')







