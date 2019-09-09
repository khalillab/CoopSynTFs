function [ Fb ] = WangExact(x, xdata, Rt, Lt_s, Kd1 )
% Exact expression for Competitive Binding
% Wang, Z.X. An exact mathematical expression for describing competitive
% binding of two different ligands to a protein molecule. FEBS letters 360, 111-114 (1995)

%% Unpack Variables
Kd2 = x;            % TF-Competitor Affinity
Lt = xdata;         % Competitor concentration

%% Define Constants
a = Kd1 + Kd2 + Lt + Lt_s - Rt ;
b = Kd2*(Lt_s - Rt) + Kd1*(Lt - Rt) + Kd1*Kd2 ;
c = -Kd1*Kd2*Rt ;
theta = acos( (-2*a.^3 + 9*a.*b - 27*c) ./ (2* ( (a.^2-3*b).^3).^0.5 ) ) ;

%% Fraction Bound
u = 2*(a.^2-3*b).^0.5.*cos(theta/3);
Fb = (u - a) ./ (3*Kd1 + u - a) ;

end

