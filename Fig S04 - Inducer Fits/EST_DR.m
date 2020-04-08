clear all

% load 160609_EST_ZEV_pRS605.mat
load 160609_EST_ZEV_pRS603.mat

%% Initialize
basal_fluor = 72;                   % YPH500 Intrinsic Fluorescence

Input = Data(:,1);                  % Inducer Titration
Output = Data(:,2)-basal_fluor;     % Raw Fluorescence Output

%% Fit Hill Function
start = [max(Output) min(Output) 0.1 1];
lb = [0 0 0 0];
ub = [max(Output)*2 max(Output) 10^4 10];
[cf, resnorm] = lsqcurvefit(@hillguess,start,Input,Output,lb,ub);

%% Plot
range = logspace(-3,2);
figure
semilogx(Input,Output,'b.',range,hillguess(cf,range),'b-'); hold on
set(gca,'FontSize',18)
xlabel('Inducer (nM)')
ylabel('Fluorescence (AFU)')
xlim([min(range) max(range)])

%% Constants
a = cf(1)
c = cf(2)
EC50 = cf(3)
nH = cf(4)