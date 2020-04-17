clear all

index = 4946;
% index = 4730;
% index = 488;
% index = 494;

OutputName = 'NonLinear';
fin = 960;

%% Initialize Time Series

time_range = [0.5 1 2 4 8 16]*60*3;
L = length(time_range);
mult = round(time_range/15);
time_range = 15*mult;
freq_range = time_range.^-1;

% Create time courses
tmax = 600*5;
inc  = 601;
time = linspace(0,tmax,inc);
dc = 1/3;
t_on = time_range*dc;

DOX_stor = [];
for j=1:L
    A = [ones(1,t_on(j)/5) zeros(1,inc-t_on(j)/5)];
    DOX_stor(j,:) = A(1:inc);
end
clear A
clear i
clear j


%% Load Kinetic Parameters

load 181208_Fit6_5.mat kdeg_GFP kdeg_TF1 kdeg_TF2 ...
	T1hi T1_fold T1low T2low k1 kb_gabor kb_cyc1_2n k2_3N k3

k2_4n = k2_3N;      % 2nd node production rate with 4 operators (from fit)
k3_4n = k3;         % 3nd node production rate with 4 operators (from fit)

clear k2_3N k3

%% Load Thermodynamic Model and Parameter Space

load ThermoModel/181119_Thermo_3N_NoFB params params_meas ...
    func1_stor func2_stor


%% Run Simulation
i = index;

    % Thermo Model
    func1 = func1_stor{i};
    func2 = func2_stor{i};
    
    % Rate Scaling based on number of operators
    n  = params(3,i);
    k2 = scaling(k2_4n,4,n);
    k3 = scaling(k3_4n,4,n);

    % Calculate B-Node Parameters
    Therm1Low = func1(T1low*10^-6);
    kb_cyc1_3N = kdeg_TF2*T2low;
    T2low_start = (kb_cyc1_3N + k2*Therm1Low)/kdeg_TF2;

    % Calculate C-Node Parameters
    Therm2Low = func2(T2low_start*10^-6);
    kb_cyc2_3N = kdeg_GFP*100;
    basal = (kb_cyc2_3N + k3*Therm2Low)/kdeg_GFP;       
    
    % Storage vectors
    stor_GFP = zeros(inc,L);
    GFP_temp = zeros(inc,1);
    gain_temp = zeros(L,1);
     
    tic
    for j=1:L
        % DOX
        DOX = DOX_stor(j,:);

        % Run ODEs
        initialC = [T1low, T2low_start, basal];
        [T,X] = ode23s(@(t,y)ThreeNode_NoFB(t,y,time,DOX,k1,k2,k3,kdeg_TF1,kdeg_TF2,kdeg_GFP,kb_gabor,kb_cyc1_3N,kb_cyc2_3N,func1,func2), time, initialC);
          
        GFP_temp = X(:,3);        
        stor_GFP(:,j) = GFP_temp;
        gain_temp(j) = max(GFP_temp);
    end
    toc
    
	stor_GFP_norm = stor_GFP/max(max(stor_GFP));


%% Plot TimeCourses
 
for i=1:6
figure(i)

    plot(time, stor_GFP_norm(:,i),'r'); hold on
    plot(time_range(i)/3, 0.4,'bo'); hold on
    pbaspect([1 1.2 1])
    xlim([0 720])
    set(gca,'FontSize',22)
    ylim([0 1.3])
    
    % Save Plot
    saveas(gcf,['Figures/TC_Nonlinear_' num2str(i)],'pdf')

end



params_meas(:,index)