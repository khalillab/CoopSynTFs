function F = chempot_gen(x, TF_Tot, C_Tot, Kp, N)

% Calculates free concentrations of TF and Clamp
%   UNITS = [µM]
%   INPUTS:  TF_Tot = Total TF Concentration
%            C_Tot  = Total Clamp Concentration
%            Kp     = PDZ ligand Binding Affinity
%   OUTPUTS: x(1)   = TF_F = Free TF Concentration
%            x(2)   = C_F  = Free Clamp Concentration

%% Initialize
L = length(TF_Tot);
TF_F = x(1:L,1);
C_F = x(L+1:2*L,1);

%% System of equations
%  System of equations such that F(x) == 0
F = [TF_F - TF_Tot; C_F - C_Tot;];

for n=1:N
    mult = nchoosek(N,n);
    F = F + [n*mult*(TF_F.^n.*C_F/Kp^n) ; mult*(TF_F.^n.*C_F/Kp^n)];
end
 
end

