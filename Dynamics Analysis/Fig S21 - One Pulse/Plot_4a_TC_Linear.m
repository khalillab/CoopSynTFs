clear all

index = 2;

OutputName = 'Linear';
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

load 181208_Fit6_5.mat kdeg_GFP kdeg_TF1 k2_2n T1hi T1_fold ...
    k1 kb_gabor T1low kb_cyc1_2n

%% Load Thermodynamic Model and Parameter Space

load ThermoModel/181119_Thermo_2N.mat params params_meas func_stor


%% Run simulation

i = index;

    % Thermo Model
    func = func_stor{i};
    
    % Rate Scaling based on number of operators    
    n = params(3,i);
    k2 = scaling(k2_2n,2,n);

    % Calculate Basal
    ThermLow = func(T1low*10^-6);
    basal = (kb_cyc1_2n + k2*ThermLow)/kdeg_GFP;

    stor_GFP = zeros(inc,L);
    GFP_temp = zeros(inc,1);
    gain_temp = zeros(L,1);
     
    tic
    for j=1:L
        % DOX
        DOX = DOX_stor(j,:);

        % Run 2 Node ODE
        initialC = [T1low basal];
        [T,X] = ode23s(@(t,y)TwoNode(t,y,time,DOX,k1,k2,kb_gabor,kb_cyc1_2n,kdeg_TF1,kdeg_GFP,func), time, initialC);
        
        GFP_temp = X(:,2);
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
    saveas(gcf,['Figures/TC_Linear_' num2str(i)],'pdf')
end

