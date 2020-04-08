clear all

load 160609_ATC_pL329.mat

%% Initialize
basal_fluor = 72;                   % YPH500 Intrinsic Fluorescence

Input = Data(:,1);                  % Inducer Titration
Output = Data(:,2)-basal_fluor;     % Raw Fluorescence Output

%% Fit Hill Function
start = [max(Output) min(Output) 50 1.2];
lb = [0 0 0 0];
ub = [max(Output)*1.5 max(Output) 10^4 10];
[cf, resnorm] = lsqcurvefit(@hillguess,start,Input,Output,lb,ub);

%% Plot
range = logspace(-2,4);
figure
semilogx(Input,Output,'bo',range,hillguess(cf,range),'b-'); hold on
set(gca,'FontSize',18)
xlabel('Inducer (ng/mL)')
ylabel('Fluorescence (AFU)')
title('aTc Titration')
xlim([min(range) max(range)])

%% Constants
a = cf(1)
c = cf(2)
EC50 = cf(3)
nH = cf(4)