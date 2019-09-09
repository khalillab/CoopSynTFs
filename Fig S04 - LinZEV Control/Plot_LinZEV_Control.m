clear all

%% Load Data
load 181127_Data.mat

% columns: (1)/(2) = (-)/(+) EST Average GFP
% columns: (1)/(2) = (-)/(+) EST STDEV GFP
% rows 1-4 = yKL 701,712,711,757

%% Plot Data

y = Data(:,1:2);                  % data values
errY = zeros(4,2,2);
errY(:,:,1) = zeros(size(y));     % silence lower error
errY(:,:,2) = Data(:,3:4);        % upper error
h = barwitherr(errY, y,1.0);      % Plot with errorbars (1.0 = width)

set(gca,'XTickLabel',{'Promoter Only','ZEV','ZEV-Clamp','ZEV-TF'})
legend('(-) EST','(+) EST','Location','northwest')
ylim([0 8000])
pbaspect([1 1.2 1])
%   ylabel('Y Value')
%   set(h(1),'FaceColor','k')
  