function txn = meantxn_2TF_noClamp(y, TF1, TF2, N1, N2)

% Calculates transcription for 2 TFs on DNA
% UNITS = [µM]

% Unpack variables
Kt1 = y(1)  ;
Kt2 = y(2)  ;

% Total N
N = N1 + N2 ;

%% Free [TF] = Total [TF]
TF1_F = TF1 ;
TF2_F = TF2 ;

%% Count States

fb     = [];
ratesTF = [];

% #TF1 bound to DNA
for n1=0:N1
    
    % #TF2 bound to DNA
    for n2=0:N2
        
        state = nchoosek(N1,n1)*(TF1_F/Kt1).^n1*nchoosek(N2,n2).*(TF2_F/Kt2).^n2;
        
        if (n1 == 0) && (n2 == 0)
            % Edge case
            fb = fb;
        else
            fb = [fb state];
            ratesTF = [ratesTF n1+n2];
        end
        
    end
end


%% Calculate Mean Transcription
rates = [ratesTF]'/N ;
txn = (fb*rates)./(1 + fb*ones(length(rates),1)) ;

end

