clear all, close all

%% LOAD DATA

load '181119_2TF_Surfaces_withClamp.mat' out_stor params_approx params_meas
Data = out_stor;
params = params_approx;


%% TARGET DISTRIBUTIONS

% target = [0 0 0 1]'; OutputName = 'AND';
% target = [0 1 1 1]'; OutputName = 'OR';
% target = [0 0.5 0.5 1]'; OutputName = 'Fuzzy_OR';
% target = [0 0.25 0.25 1]'; OutputName = 'Fuzzy_AND';
% target = [0 0.5 0 1]'; OutputName = 'ASym';
target = [0 1 0 0]'; OutputName = 'NegCoop';
% target = [0 1 0 1]'; OutputName = 'TF1_only';

% For Reviewer #3
% target = [1 0 0 0]'; OutputName = 'NOR';
% target = [0 1 1 0]'; OutputName = 'XOR';
% target = [1 1 1 0]'; OutputName = 'NAND';

% Not used in figures
% target = [0 0 0.5 1]'; OutputName = 'ASymAgg1';
% target = [0 0 1 0.5]'; OutputName = 'NegCoop1';
% target = [0 1 0 0.5]'; OutputName = 'NegCoop2';
% target = [0 0 1 0]'; OutputName = 'NegCoop3';
% target = [0 0 1 1]'; OutputName = 'TF1only';
% target = [0 1 0 1]'; OutputName = 'TF2only';


%% Generate Ideal Surfaces
L = 24;

TF1 = [ones(1,12) zeros(1,12)];
TF2 = [zeros(1,12) ones(1,12)];
Input = combvec(TF1,TF2);

ideal_AND = zeros(576,1);
ideal_OR = zeros(576,1);

ind2 = find((Input(1,:)==1)&(Input(2,:)==0));
ind3 = find((Input(1,:)==0)&(Input(2,:)==1));
ind4 = find((Input(1,:)==1)&(Input(2,:)==1));

ideal_AND(ind4) = 1;
ideal_OR(ind2) = 1;
ideal_OR(ind3) = 1;
ideal_OR(ind4) = 1;

% KL Search on Data
[row, col] = size(Data);
KL_AND = zeros(1,col);
KL_OR = zeros(1,col);
for i=1:col
    dist = Data(:,i);
    KL_AND(i) = KLgen(dist,ideal_AND);
    KL_OR(i) = KLgen(dist,ideal_OR);
end

%% TARGET OF INTEREST

% Generate Target Distribution
target_dist = zeros(576,1);

ind1 = find((Input(1,:)==0)&(Input(2,:)==0));
ind2 = find((Input(1,:)==1)&(Input(2,:)==0));
ind3 = find((Input(1,:)==0)&(Input(2,:)==1));
ind4 = find((Input(1,:)==1)&(Input(2,:)==1));

target_dist(ind1) = target(1);
target_dist(ind2) = target(2);
target_dist(ind3) = target(3);
target_dist(ind4) = target(4);

%% Fit Surfaces  

% KL of Interest (KLOI)
[row, col] = size(Data);
for i=1:col
    dist = Data(:,i);
    KLOI(i) = KLgen(dist,target_dist);
end

% Find top hits 1%
KLOI_sort = sort(KLOI);
ind = [];
for i=1:81
    ind(i) = find(KLOI==KLOI_sort(i));
end

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


%% Initialize Input Space

% Load Fit
load Fits/extrap_181115_Global_fixT2_4.mat ...
    Kp_meas Kp_approx Kt_meas Kt_approx ...
    Thi Tlow linTet_n linTet_EC50 C_adh1 c_approx TF2_hi

% Unpack variables

% Cooperativity constants
c2 = c_approx(2);
c3 = c_approx(3);
c4 = c_approx(4);
c5 = c_approx(5);
c6 = c_approx(6);

% Concentrations
TF1_hi = Thi;
TF1_low = Tlow;
C_adh1;

% TF2 Concentrations (See Final Expression Data in S4)
TF2_hi;                     % From Fit
TF2_low = TF2_hi/40.1;      % Fold change of inducible system from 603 EST-GFP


% Create Titration
L = 48;                 % # of points in Titration

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


for i=[1,20,40]

    % Surface parameters
    Kt1 = params(1,ind(i));
    Kp1 = params(2,ind(i));
    Kt2 = params(3,ind(i));
    Kp2 = params(4,ind(i));
    N1  = params(5,ind(i));
    N2  = params(6,ind(i));
    
    
    % Run Surface
    y = [Kt1 Kp1 Kt2 Kp2 c2 c3 c4 c5 c6];   % Compile Parameters
    Output = zeros(L^2,1);          % Storage
    % Run Surface
    parfor j=1:length(Input)
        Output(j) = meantxn_2TF_gen(y, TF1(j), TF2(j), C_adh1, N1, N2);
    end
    
    Output = reshape(Output, [L L]);

% Plot
close all
figure
    imagesc(Output)
    text(3,4,['KL = ' num2str(round(KLOI(ind(i)),3))],'HorizontalAlignment','left','FontSize',24,'Color',[0 0 0])
    colormap(mymap)
    pbaspect([L L 1])
    colorbar
    caxis([0 max(max(Output'))])
    colormap(mymap)             % Colormap goes here! (comment out to see in regular 'JET' colors)
    set(gca, 'XTickLabel', [])  % Removes Tick labels
    set(gca, 'YTickLabel', [])  % Removes Tick labels

saveas(gcf,['S14_Plots/' OutputName '_Sample_' num2str(i)],'pdf')

end

TF1 = reshape(TF1,[L L]);
TF2 = reshape(TF2,[L L]);

