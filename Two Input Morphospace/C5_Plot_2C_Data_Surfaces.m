clear all, close all

%% LOAD DATA
load '180713_CB_Fig2_Surface_data.mat'

Name = 'Config1'; Output = Config1;
Name = 'Config2'; Output = Config2;
Name = 'Config4'; Output = Config4;
Name = 'Config5'; Output = Config5;


% Reorient matrix for surface
% decreasing ATC going down
% decreasing EST going across
Output = rot90(Output,1)';


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


%% Plot Surface
L = 12;

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

saveas(gcf,['Fig2C_Plots/181120_Data_12x12_' Name],'pdf')
