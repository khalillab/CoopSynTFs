function F = chempot_2TF_gen(x, TF1_Tot, TF2_Tot, C_Tot, Kp1, Kp2, N)
% Calculates free concentrations of TF1, TF2, and Clamp for valency of N

%   UNITS = [µM]

%   INPUTS:  TF1_Tot  = Total TF1 Concentration
%            TF2_Tot  = Total TF2 Concentration
%            C_tot    = Total Clamp Concentration
%            Kp1      = TF1 PDZ ligand Binding Affinity
%            Kp2      = TF2 PDZ ligand Binding Affinity
%            N        = Clamp valency

%   OUTPUTS: x(1)   = TF1_F = Free TF1 Concentration
%            x(2)   = TF2_F  = Free TF2 Concentration
%            x(3)   = C_F  = Free Clamp Concentration

%% Initialize
L = length(TF1_Tot);
TF1_F = x(1:L,1);
TF2_F = x(L+1:2*L,1);
C_F   = x(2*L+1:3*L,1);

%% System of equations
%  System of equations such that F(x) == 0
F = [TF1_F - TF1_Tot; TF2_F - TF2_Tot; C_F - C_Tot;];

% #TF1 bound to clamp
for n1=0:N
    % #TF2 bound to clamp
    for n2=0:(N-n1)
        state = nchoosek(N,n1)*(TF1_F.^n1)*nchoosek(N-n1,n2).*(TF2_F.^n2).*C_F/Kp1^n1/Kp2^n2;
        
        if (n1 == 0) && (n2 == 0)
            % Edge case
            F = F;
        else
            F = F + [n1*state; n2*state; state];
        end
        
    end
end
 
end
