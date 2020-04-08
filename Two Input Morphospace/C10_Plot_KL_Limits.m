clear all, close all

%% LOAD DATA

load '181119_2TF_Surfaces_withClamp.mat' out_stor params_approx params_meas
Data = out_stor;
params = params_meas;


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

%% Create Limits

q4 = logspace(-2,0,100);

AND_min = -log2(q4);
OR_min = log2(1/3) - (1/3)*(log2(((1-q4)/2).^2)-AND_min);


%% Plot Top Hits (Color = size of complex)

% Plot
figure
        loglog(KL_AND,KL_OR,'o'); hold on
        loglog(AND_min,OR_min,'--'); hold on        
        set(gca,'XScale','log')
        set(gca,'YScale','log')
        pbaspect([1.1 1 1])
        set(gca,'fontsize',22)
        xlim([10^-1 4])  
        ylim([2*10^-2 3])    
   


figure
        plot(KL_AND,KL_OR,'o'); hold on
        loglog(AND_min,OR_min,'-')
        pbaspect([1.1 1 1])
        set(gca,'fontsize',22)
%         xlim([10^-1 4])  
%         ylim([2*10^-2 3])    
% % Save Plot
% saveas(gcf,['S14_Plots/' OutputName '_Scatter'],'epsc')


    

    