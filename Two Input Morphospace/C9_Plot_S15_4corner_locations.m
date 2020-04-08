clear all

load '181119_2TF_Surfaces_withClamp' out_stor params_approx params_meas
Data = out_stor;
params = params_meas;

load '181119_2TF_Surfaces_noClamp.mat' out_stor
Data2 = out_stor;

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

%% KL Search on Data

% Clamp Data
[row, col] = size(Data);
KL_AND = zeros(1,col);
KL_OR = zeros(1,col);
for i=1:col
    dist = Data(:,i);
    KL_AND(i) = KLgen(dist,ideal_AND);
    KL_OR(i) = KLgen(dist,ideal_OR);
end


% No Clamp Data
[row2, col2] = size(Data2);
KL_AND2 = zeros(1,col2);
KL_OR2 = zeros(1,col2);
for i=1:col2
    dist2 = Data2(:,i);
    KL_AND2(i) = KLgen(dist2,ideal_AND);
    KL_OR2(i) = KLgen(dist2,ideal_OR);
end


%% Plot

% All Configs Clamped
figure
    loglog(KL_AND,KL_OR,'bo'); hold on
    pbaspect([1.1 1 1])
    set(gca,'fontsize',22)
    xlim([10^-1 4])  
    ylim([2*10^-2 3])   

%% Find 4 corner configs

load 180712_4corners_CB_data.mat configs_built

ind = [];
for i=1:length(configs_built)
    
    config = configs_built(i,:);
    
    ind(i) = find((config(1)==params(1,:))&(config(2)==params(2,:))&(config(3)==params(3,:))& ...
        (config(4)==params(4,:))&(config(5)==params(5,:))&(config(6)==params(6,:)));
end

%% Plot locations of 4 corners

figure
% 4 corner locations
for i=1:length(ind)
    loglog(KL_AND(ind(i)),KL_OR(ind(i)),'ks','MarkerSize',20,'LineWidth',1); hold on
    text(KL_AND(ind(i))/1.4,KL_OR(ind(i)),num2str(i),'FontSize',12); hold on
end
    pbaspect([1.1 1 1])
    set(gca,'fontsize',22)
    xlim([10^-1 4])  
    ylim([2*10^-2 3])    
saveas(gcf,['Fig2C_Plots/Four_Corner_locations'],'pdf')


    % Locations of configs in main
figure
    loglog(KL_AND,KL_OR,'bo'); hold on
    loglog(KL_AND(ind([6,11,19,21])),KL_OR(ind([6,11,19,21])),'ks','MarkerSize',20,'LineWidth',2); hold on
    pbaspect([1.1 1 1])
    set(gca,'fontsize',22)
    xlim([10^-1 4])  
    ylim([2*10^-2 3])   
    
saveas(gcf,['Fig2C_Plots/Main_Circuit_locations'],'pdf')
