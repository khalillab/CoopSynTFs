clear all, clc, close all

% Code generates 1TF Behavior space (Dose response nH vs EC50)
% from parameter fit
% MATLAB 2016b

OutputName = '181115_1TF_behavior_space.mat';

%% Parameters

% Load Fit
load Fits/extrap_181115_Global_fixT2_4.mat ...
    Kp_meas Kp_approx Kt_meas Kt_approx C_adh1 Thi Tlow linTet_n linTet_EC50 c_approx

% Unpack variables

% Cooperativity constants
c2 = c_approx(2);
c3 = c_approx(3);
c4 = c_approx(4);
c5 = c_approx(5);

% Add Kp = 0 (No Clamp)
Kp_meas = [Kp_meas 0];
Kp_approx = [Kp_approx 0];

% Create Parameter space
params = combvec(Kt_approx, Kp_approx, [2:5]);
params_meas = combvec(Kt_meas, Kp_meas, [2:5]);

% Add n=1 no clamp configs
params_n1 = combvec(Kt_approx, 0, 1);
params_n1_meas = combvec(Kt_meas, 0, 1);

params = [params params_n1];
params_meas = [params_meas params_n1_meas];


%% TF Titration

% ZF Titration
ATC = logspace(log10(5000),log10(0.1),50)';
TF_perc = (ATC.^linTet_n)./(linTet_EC50^linTet_n + ATC.^linTet_n);
TF = (Thi - Tlow)*TF_perc + Tlow;

% Clamp
C = C_adh1*ones(size(ATC));


%% Calculate DRs

% Storate values
Model_DR = zeros(length(TF),length(params));
cf_stor = [];
res_stor = [];

% Iterate
parfor i=1:length(params)
    
    % Configuration
    Kt = params(1,i);
    Kp = params(2,i);
    N  = params(3,i);
    
    % Run DR
    if Kp==0
        txn = meantxn_cp_TFonly(Kt, TF, N);
        Model_DR(:,i) = txn;
    else
        txn = meantxn_cp_ANY([Kt Kp c2 c3 c4 c5], TF, C, N);
        Model_DR(:,i) = txn;
    end
    
    % Fit Hill
    data = Model_DR(:,i);
    start = [ data(1)-data(end)    data(end)    linTet_EC50   linTet_n ];
    lb =    [ 0  0  0  0 ];
    ub =    [ 1  1  10^6  100 ];
    [cf, res] = lsqcurvefit(@hillguess,start,ATC,data,lb,ub);  
    cf_stor(:,i) = cf';
    res_stor(i) = res;  
    
end



%% Plot Full Behavior Space


% Behavior space properties
ec50 = cf_stor(3,:);
nH = cf_stor(4,:);
fold_change = (cf_stor(1,:)+cf_stor(2,:))./cf_stor(2,:);


% Filter by n
ind2 = find((params(3,:)==2)&(params(2,:)>0));
ind3 = find((params(3,:)==3)&(params(2,:)>0));
ind4 = find((params(3,:)==4)&(params(2,:)>0));
ind5 = find((params(3,:)==5)&(params(2,:)>0));
ind_noC = find(params(2,:)==0);



% Plot
figure(1)
    semilogy(nH(ind_noC),ec50(ind_noC),'ko'); hold on
    semilogy(nH(ind2),ec50(ind2),'o'); hold on
    semilogy(nH(ind3),ec50(ind3),'o'); hold on
    semilogy(nH(ind4),ec50(ind4),'o'); hold on
    semilogy(nH(ind5),ec50(ind5),'o'); hold on
    xlim([1 3.5])
    ylim([10^-1 10^3])
    pbaspect([4.2 1 1])

figure(2)
    semilogy(nH(ind_noC),fold_change(ind_noC),'ko'); hold on
    semilogy(nH(ind2),fold_change(ind2),'o'); hold on
    semilogy(nH(ind3),fold_change(ind3),'o'); hold on
    semilogy(nH(ind4),fold_change(ind4),'o'); hold on
    semilogy(nH(ind5),fold_change(ind5),'o');
    xlim([1 3.5])


%% Filter Behavior Space
% Fold change > 2

%% Plot DRs

figure(3)
for i=1:length(params)
    semilogx(ATC,Model_DR(:,i),'o'); hold on
    semilogx(ATC,hillguess(cf_stor(:,i),ATC),'-'); hold on    
end

    
%% Save
save(OutputName)

