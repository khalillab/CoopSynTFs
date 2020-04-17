clear all, close all

%% n vs fluor data (measured)
data_n = 2:5;
data_fold = [1.00, 1.50, 2.11, 2.18];
data_error = [0.066, 0.064, 0.074, 0.120];

figure
errorbar(data_n,data_fold,data_error,'bo'); hold on

xlim([1.5 6.5])
ylim([0.5 2.5])

[ Qpre, p, sm, varcov] = fit_logistic(data_n,data_fold);

thalf = p(1);
Qinf = p(2);
alpha = p(3);

model_n = linspace(0,7,100);
model_fold = Qinf./(1 + exp(-alpha*(model_n-thalf)))

model_n2 = 2:6;
model_fold2 = Qinf./(1 + exp(-alpha*(model_n2-thalf)))

plot(model_n, model_fold,'r-')
plot(model_n2, model_fold2,'ro')


xlim([1.5 6.5])
ylim([0.5 2.5])

% %% Model
% n=2:6;
% nl = 3;
% rates = n.^nl./(2.25.^nl+n.^nl);
% 
% 
% figure(1)
%     plot(n,rates/rates(1),'b-'); hold on
%     
% % ratios = [1];
% % for i=2:length(n)
% %     ratios(i) = rates(i)/rates(i-1)
% % end
% 
% n1 = [2 3 4];
% data1 = [4600 5200 5500]-250;
% plot(n1,data1/data1(1),'mo'); hold on
% 
% 
% n2 = [2 3 4 5];
% data2 = [7.5 14 18 20];
% plot(n2,data2/data2(1),'ko'); hold on
% 
% % n3 = [2 3 4 5];
% % data3 = [3700 7500 13400 16000]-500;
% % plot(n3,data3/data3(1),'ks'); hold on
% 
% n4 = [2 3 4 5];
% data4 = [3910 4891 6937 7383]-783;
% plot(n4,data4/data4(1),'ro'); hold on
% 
% %% Use this data
% n5 = [2 3 4 5];
% data5 = [13004 18520 24745 26970]-1700;
% plot(n5,data5/data5(1),'rs'); hold on
% 
% % ylim([0 1.3])
% xlim([1 6])
