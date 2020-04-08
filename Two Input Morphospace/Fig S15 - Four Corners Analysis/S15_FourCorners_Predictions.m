clear all, clc, close all

% Code predicts 4 corners data for 2 TF + Clamp
% MATLAB R2016a

OutputName = '181031_4corners_model'

%% Load Fit
load Fits/extrap_181115_Global_fixT2_4.mat ...
    Kp_meas Kp_approx Kt_meas Kt_approx ...
    C_adh1 Thi Tlow linTet_n linTet_EC50 c_approx TF2_hi

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
C_adh1;

% TF2 Concentrations (See Final Expression Data in S4)
TF2_hi;                     % From Fit
TF2_low = TF2_hi/40.1;      % Fold change of inducible system from 603 EST-GFP


%% Create Four Corners

TF1 = [TF1_low TF1_hi TF1_low TF1_hi]';
TF2 = [TF2_low TF2_low TF2_hi TF2_hi]';
C   = [C_adh1 C_adh1 C_adh1 C_adh1]';

%% Load measured configurations and data

% Load Data
load 180712_4corners_CB_data.mat configs_built data_built

params_meas = configs_built';

% Find approximated affinities
params_approx = zeros(size(params_meas));

for i=1:length(configs_built)
    params_approx(1,i) = Kt_approx(find(Kt_meas==params_meas(1,i)));
    params_approx(2,i) = Kp_approx(find(Kp_meas==params_meas(2,i)));
    params_approx(3,i) = Kt_approx(find(Kt_meas==params_meas(3,i)));
    params_approx(4,i) = Kp_approx(find(Kp_meas==params_meas(4,i)));
    params_approx(5,i) = params_meas(5,i);
    params_approx(6,i) = params_meas(6,i);
    
end
                 
% Storage vectors
stor = zeros(length(params_approx),4);             % Raw 4 corners
stor_norm = zeros(length(params_approx),4);        % Normalized 4 corners

%% Predict 4 corners

for i=1:length(params_approx)
    
    Kt1 = params_approx(1,i);
    Kp1 = params_approx(2,i);
    Kt2 = params_approx(3,i);
    Kp2 = params_approx(4,i);
    N1  = params_approx(5,i);
    N2  = params_approx(6,i);
        
    % Predict 4 corners
    corner = [];
    y = [Kt1 Kp1 Kt2 Kp2 c2 c3 c4 c5 c6];
    corners = meantxn_2TF_gen(y, TF1, TF2, C, N1, N2);

    % Store Data
    stor(i,:) = corners';                       % Raw
    stor_norm(i,:) = corners'/max(corners);     % Normalized

end



%% Calculate Kullback-Leibler Divergence for Ideal AND and OR gates

% First column = KL_AND
% Second column = KL_OR

KL_meas = zeros(length(data_built),2);
KL_pred = zeros(length(stor_norm),2);

for i=1:length(data_built)
    KL_meas(i,1) = KLgen(data_built(i,:),[0 0 0 1]);    % KL_AND
    KL_meas(i,2) = KLgen(data_built(i,:),[0 1 1 1]);    % KL_OR 
    KL_pred(i,1) = KLgen(stor_norm(i,:),[0 0 0 1]);     % KL_AND
    KL_pred(i,2) = KLgen(stor_norm(i,:),[0 1 1 1]);     % KL_OR
end


% % Compare model vs data
% AND_diff = abs(KL_pred(:,1)-KL_meas(:,1));
% OR_diff = abs(KL_pred(:,2)-KL_meas(:,2));
% 
% AND_diff_sort = sort(AND_diff,'descend');
% OR_diff_sort = sort(OR_diff,'descend');
% 
% % Top differences betweeh model and data
% for i=1:3
%     ind_top_AND(i) = find(AND_diff_sort(i)==AND_diff);
%     ind_top_OR(i) = find(OR_diff_sort(i)==OR_diff);
% end


%% Model vs Data - KL (Linear Scale)

% figure
%     subplot(1,2,1)
%     plot(KL_pred(:,1),KL_meas(:,1),'ro'); hold on    
%     plot([0 2],[0 2],'k--')
%     xlabel('Model KL AND')
%     ylabel('Data KL AND')
%     xlim([0 2])
%     ylim([0 2])
%     pbaspect([1 1 1])
%     set(gca,'FontSize',18)
% 
%     subplot(1,2,2)
%     plot(KL_pred(:,2),KL_meas(:,2),'ro'); hold on
%     plot([0 1.5],[0 1.5],'k--')
%     xlabel('Model KL OR')
%     ylabel('Data KL OR')
%     xlim([0 1.5])
%     ylim([0 1.5])
%     pbaspect([1 1 1])
%     set(gca,'FontSize',18)

    
%% Model vs Data - KL (Log Scale)

range = logspace(-2,1,100);

x = KL_pred(:,1);
y = KL_meas(:,1);
X = [ones(length(x),1) x];
b = X\y;
yCalc2 = X*b;
Rsq2_AND = 1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2)

x = KL_pred(:,2);
y = KL_meas(:,2);
X = [ones(length(x),1) x];
b = X\y;
yCalc2 = X*b;
Rsq2_OR = 1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2)


figure
    subplot(1,2,1)
    RMSD_AND = sqrt(sum((KL_pred(:,1)-KL_meas(:,1)).^2)/length(KL_pred(:,1)))
    MAE_AND = sum(abs((KL_pred(:,1)-KL_meas(:,1))))/length(KL_pred(:,1))
    plot(KL_pred(:,1),KL_meas(:,1),'ro'); hold on
    plot(range,range,'k--'); hold on  
    xlabel('Model KL AND')
    ylabel('Data KL AND')
    title(num2str(MAE_AND))
    set(gca,'XScale','log')
    set(gca,'YScale','log')
    xlim([10^-1 5])
    ylim([10^-1 5])
    pbaspect([1 1 1])
    set(gca,'FontSize',18)

    subplot(1,2,2)
    RMSD_OR = sqrt(sum((KL_pred(:,2)-KL_meas(:,2)).^2)/length(KL_pred(:,2)))
    MAE_OR = sum(abs((KL_pred(:,2)-KL_meas(:,2))))/length(KL_pred(:,2))
    plot(KL_pred(:,2),KL_meas(:,2),'ro'); hold on
    plot([10^-2 5],[10^-2 5],'k--')
    title(num2str(MAE_OR))
    xlabel('Model KL OR')
    ylabel('Data KL OR')
    set(gca,'XScale','log')
    set(gca,'YScale','log')    
    xlim([10^-2 5])
    ylim([10^-2 5])
    pbaspect([1 1 1])
    set(gca,'FontSize',18)


%% Model vs Data - Bar Graphs (One Stack)

barcolor = [50 150 100]/255;    % Green
% barcolor = [0 0 0 ]/255;        % Black

figure

for i=1:25
    
    % Model
    subplot(25,2,i*2-1)    
    h = bar(stor_norm(i,:),'FaceColor',barcolor);
    h.EdgeColor = 'none';
    ylim([0 1.1])    
    xlim([0.25 4.75])
    set(gca,'xticklabel',{[]})
    set(gca,'yticklabel',{[]})
    pbaspect([2 1 1])
    
    
    % Data
    subplot(25,2,i*2)
    h = bar(data_built(i,:),'FaceColor',barcolor);
    h.EdgeColor = 'none';
    ylim([0 1.1])
    xlim([0.25 4.75])
    set(gca,'xticklabel',{[]})
    set(gca,'yticklabel',{[]})
    pbaspect([2 1 1])

end

%% Save Data
save([OutputName '.mat'],'stor','stor_norm')