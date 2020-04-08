function txn = meantxn_cp_TFonly(Kt, TF, N)
% Calculates mean transcription for 1 TF (without Clamp) system of arbitrary N
% UNITS = [µM]

% Free TF = Total TF
TF_F = TF;

% Txn rates
fb = [];
ratesTF = [1:N]/N;

%% TF-DNA States
for n=1:N
    mult = nchoosek(N,n);
    fb  = [fb mult*(TF_F/Kt).^n];
end

%% Calculate Mean Transcription
rates = ratesTF';
txn = (fb*rates)./(1 + fb*ones(length(rates),1));

end

