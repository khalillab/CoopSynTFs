function txn = meantxn_2TF_gen(y, TF1, TF2, C, N1, N2)
% Calculates transcription for 2 TF + Clamp assembly on DNA
% UNITS = [µM]

options = optimset('Display','off','TolX',10^-12,'TolFun',10^-12);

%% Unpack variables

Kt1 = y(1)  ;       % TF1-DNA Affinity
Kp1 = y(2)  ;       % TF1-Clamp Affinity
Kt2 = y(3)  ;       % TF2-DNA Affinity
Kp2 = y(4)  ;       % TF2-Clamp Affinity

N = N1 + N2 ;       % N1 = #TF1 binding sites, N2 = #TF2 Binding Sites


% Cooperativity constants
c2 = y(5);
c3 = y(6);
c4 = y(7);
c5 = y(8);
c6 = y(9);

c = [1 c2 c3 c4 c5 c6];

%% Solve for free concentrations

L = length(TF1)    ;
x0 = [TF1;TF2;C]/2 ;
lb = zeros(3*L,1)  ;
ub = [TF1;TF2;C]   ;
f = @(x) chempot_2TF_gen(x,TF1,TF2,C,Kp1,Kp2,N) ;
[out,fval] = lsqnonlin(f,x0,lb,ub,options)       ;

% Unpack free concentrations
TF1_F = out(1:L,1)     ;
TF2_F = out(L+1:2*L,1) ;
C_F = out(2*L+1:3*L,1) ;

%% Storage Matrices
fb     = [];        % fraction bound
ratesTF = [];       % TF-DNA binary rates
ratesC  = [];       % TF-DNA-Clamp tertiary rates

%% TF-DNA States

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


%% TF-Clamp-DNA States

% #TF1 bound to DNA - being clamped
for n1=1:N1
    state = nchoosek(N1,n1)*TF1_F.^n1.*C_F/(Kp1^n1*Kt1^n1*c(n1));
    fb = [fb state];
    ratesC = [ratesC n1];
end


% #TF2 bound to DNA - being clamped
for n2=1:N2
    state = nchoosek(N2,n2)*TF2_F.^n2.*C_F/(Kp2^n2*Kt2^n2*c(n2));
    fb = [fb state];
    ratesC = [ratesC n2];
end


% #TF1 & TF2 bound to DNA - being clamped
for n1=1:N1
    for n2=1:N2

        state = nchoosek(N1,n1)*(TF1_F).^n1*nchoosek(N2,n2).*(TF2_F).^n2.*C_F/(Kp1^n1*Kp2^n2*Kt1^n1*Kt2^n2*c(n1+n2));
        
        fb = [fb state];
        ratesC = [ratesC n1+n2];
    end
end


%% Calculate Mean Transcription

rates = [ratesTF ratesC]'/N ;
txn = (fb*rates)./(1 + fb*ones(length(rates),1)) ;


end

