function txn = meantxn_cp_ANY(y, TF, C, N)
% Calculates mean transcription for 1 TF + Clamp system of arbitrary N
% UNITS = [µM]

options = optimset('Display','off','TolX',10^-12,'TolFun',10^-12);

% Unpack variables
Kt = y(1);
Kp = y(2);

% Cooperativity terms
c2 = y(3);
c3 = y(4);
c4 = y(5);
c5 = y(6);

% Solve for free concentrations
L = length(TF);
x0 = [TF;C]/2;              % Initial Guess
lb = zeros(2*L,1);          % Lower bound = Zero
ub = [TF;C];                % Upper bound = Total concentration
f = @(x) chempot_gen(x,TF,C,Kp,N);
[out,fval] = lsqnonlin(f,x0,lb,ub,options);

% Extract Fraction Bound
TF_F = out(1:L,1);
C_F = out(L+1:2*L,1);

%% Initialize
fb = [];

% Txn rates
ratesTF = [1:N]/N;              
ratesC = [1:N]/N;

% Cooperativity terms
c = [1 c2 c3 c4 c5];

%% TF-DNA States
for n=1:N
    mult = nchoosek(N,n);
    fb  = [fb mult*(TF_F/Kt).^n];
end

%% TF-Clamp-DNA States
for n=1:N
    mult = nchoosek(N,n);
    fb  = [fb mult*(TF_F.^n.*C_F/Kp^n/Kt^n)/c(n)];
end

%% Calculate Mean Transcription
rates = [ratesTF ratesC]';
txn = (fb*rates)./(1 + fb*ones(length(rates),1));

end

