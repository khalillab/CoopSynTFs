clear all, close all

%% Colormap

% Blue-green (1:1:1:1)
ratio = [1 1 1 1]; n=16;
c1 = [247   252   253]/255;
c2 = [204   236   230]/255;
c3 = [102   194   164]/255;
c4 = [35   139    69]/255;
c5 = [0    68    27]/255;
mymap1 = ColorScaler_Mod( c1, c2, n*ratio(1) );
mymap2 = ColorScaler_Mod( c2, c3, n*ratio(2) );
mymap3 = ColorScaler_Mod( c3, c4, n*ratio(3) );
mymap4 = ColorScaler_Mod( c4, c5, n*ratio(4) );
mymap = [mymap1; mymap2; mymap3; mymap4];

% Remove repeats
r = 1;
temp = [];
for i=1:length(mymap)-1
    if isequal(mymap(i,:),mymap(i+1,:))==0
       temp(r,:) = mymap(i,:);
       r = r+1;
    end
end
mymap = [temp; mymap(end,:)];


%% Load Fit
load Fits/extrap_181115_Global_fixT2_4.mat ...
    Kp_meas Kp_approx Kt_meas Kt_approx ...
    Thi Tlow linTet_n linTet_EC50 C_adh1 c_approx TF2_hi

%% Unpack variables

% Cooperativity constants
c2 = c_approx(2);
c3 = c_approx(3);
c4 = c_approx(4);
c5 = c_approx(5);
c6 = c_approx(6);

% Concentrations
TF1_hi = Thi;
TF1_low = Tlow;
C = C_adh1;

% TF2 Concentrations (See Final Expression Data in S4)
TF2_hi;                     % Extrapolated from fit
TF2_low = TF2_hi/40.1;      % Fold change of inducible system from 603 EST-GFP


%% Create Titration
L = 12;                 % # of points in Titration

% linTET-TF1 Titration
ATC = logspace(log10(1000),log10(0.1),L);
TF_perc = (ATC.^linTet_n)./(linTet_EC50^linTet_n + ATC.^linTet_n);
TF1_r = (Thi - Tlow)*TF_perc + Tlow;


% linZEV-TF2 Titration
linZEV_n = 1.34;            % LinZEV Dose response in HIS Locus
linZEV_EC50 = 0.85;         % LinZEV Dose response in HIS Locus
EST = logspace(log10(12.5),log10(0.05),L);
TF2_perc = (EST.^linZEV_n)./(linZEV_EC50^linZEV_n + EST.^linZEV_n);
TF2_r = fliplr((TF2_hi - TF2_low)*TF2_perc + TF2_low);


% 2D Dose - Create matrix of TF1 vs TF2 titration
Input = combvec(TF1_r,TF2_r);
TF1 = Input(1,:)';
TF2 = Input(2,:)';


%% Fit Surfaces  

% Config #1
% Fuzzy 2 Gate
Name = 'Config1'
    Kt1_meas = 0.143;
    Kp1_meas = 0.18;
    Kt2_meas = 0.095;
    Kp2_meas = 0.18;
    N1_meas  = 2;
    N2_meas  = 2; 

% % Config #2
% % AND Gate
% Name = 'Config2'
%     Kt1_meas = 0.224;
%     Kp1_meas = 0.88;
%     Kt2_meas = 0.415;
%     Kp2_meas = 0.88;
%     N1_meas  = 3;
%     N2_meas  = 3;

% % Config #4
% % OR Gate
% Name = 'Config4'
%     Kt1_meas = 0.143;
%     Kp1_meas = 0.062;
%     Kt2_meas = 0.218;
%     Kp2_meas = 0.062;
%     N1_meas  = 3;
%     N2_meas  = 3;  

% % Config #5
% % Fuzzy 1 Gate
% Name = 'Config5'
%     Kt1_meas = 0.143;
%     Kp1_meas = 0.18;
%     Kt2_meas = 0.415;
%     Kp2_meas = 0.18;
%     N1_meas  = 3;
%     N2_meas  = 3; 


% Find approximated affinities from fit

Kt1 = Kt_approx(find(Kt1_meas==Kt_meas))
Kt2 = Kt_approx(find(Kt2_meas==Kt_meas))
Kp1 = Kp_approx(find(Kp1_meas==Kp_meas))
Kp2 = Kp_approx(find(Kp2_meas==Kp_meas))
N1 = N1_meas
N2 = N2_meas

y = [Kt1 Kp1 Kt2 Kp2 c2 c3 c4 c5 c6];   % Compile Parameters

tic
Output = zeros(L^2,1);          % Storage
% Run Surface
for j=1:length(Input)
    Output(j) = meantxn_2TF_gen(y, TF1(j), TF2(j), C, N1, N2);
end
toc

% Reshape surface into grid
Output = reshape(Output, [L L]);


%% Plot - Surface

figure(1)
    imagesc(Output)
    colormap(mymap)
    pbaspect([L L 1])
    colorbar
    caxis([0 max(max(Output'))])
    set(gca,'xtick', linspace(0.5,L+0.5,L+1), 'ytick', linspace(0.5,L+.5,L+1));
    set(gca,'xgrid', 'on', 'ygrid', 'on', 'gridlinestyle', '-', 'xcolor', 'k', 'ycolor', 'k', 'GridAlpha', 0.5);
    colormap(mymap)             % Colormap goes here! (comment out to see in regular 'JET' colors)
    set(gca, 'XTickLabel', [])  % Removes Tick labels
    set(gca, 'YTickLabel', [])  % Removes Tick labels

saveas(gcf,['Fig2C_Plots/181120_Model_12x12_' Name],'pdf')
