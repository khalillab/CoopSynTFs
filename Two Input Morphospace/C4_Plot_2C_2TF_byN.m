clear all

load '181119_2TF_Surfaces_withClamp' out_stor params_approx
Data = out_stor;
params = params_approx;

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

complex_size = params(5,:)+params(6,:);
% Colors for different Sized Complexes
colors = [[232 153 82]; [152 204 122]; [178 224 230]; [52 153 157]; [33 83 120]]/255;

% N=2 to N=6 Clamped
for i=2:6
    close all
    figure
    ind = find(complex_size==i);
    loglog(KL_AND(ind),KL_OR(ind),'o','Color',colors(i-1,:)); hold on
    pbaspect([1.1 1 1])
    set(gca,'fontsize',22)
    xlim([10^-1 4])  
    ylim([2*10^-2 3])       
    saveas(gcf,['Fig2C_Plots/Scatter_2B_n' num2str(i)],'pdf')
end



% All Configs Clamped
figure
    loglog(KL_AND,KL_OR,'bo'); hold on
    pbaspect([1.1 1 1])
    set(gca,'fontsize',22)
    xlim([10^-1 4])  
    ylim([2*10^-2 3])    
saveas(gcf,['Fig2C_Plots/Scatter_All'],'pdf')


figure
    loglog(KL_AND2,KL_OR2,'ko'); hold on
    pbaspect([1.1 1 1])
    set(gca,'fontsize',22)
    xlim([10^-1 4])  
    ylim([2*10^-2 3])   
saveas(gcf,['Fig2C_Plots/Scatter_NoClamp'],'pdf')