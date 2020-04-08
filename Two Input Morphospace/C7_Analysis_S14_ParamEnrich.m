clear all, close all

%% LOAD DATA

load '181119_2TF_Surfaces_withClamp.mat' out_stor params_approx params_meas
Data = out_stor;
params = params_meas;


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


%% Plot Target Distribution

figure
      imagesc(reshape(target_dist,[L L]))
      pbaspect([L L 1])
      colorbar
      caxis([0 1])
      colormap(mymap)             % Colormap goes here! (comment out to see in regular 'JET' colors)
      set(gca, 'XTickLabel', [])  % Removes Tick labels
      set(gca, 'YTickLabel', [])  % Removes Tick labels
     
% Save Plot
saveas(gcf,['S14_Plots/' OutputName '_Target'],'pdf')


%% KL of Interest (KLOI)

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


%% Plot Top Hits (Color = size of complex)

% Colors for different Sized Complexes
colors = [[232 153 82]; [152 204 122]; [178 224 230]; [52 153 157]; [33 83 120]]/255;

% Top hit positions
KL_AND = KL_AND(ind);
KL_OR = KL_OR(ind);
complex_size = params(5,ind)+params(6,ind);


% Plot
figure
    for i=[6,5,4,3,2]
        ind_N = find(complex_size==i)
        loglog(KL_AND(ind_N),KL_OR(ind_N),'o','Color',colors(i-1,:)); hold on
    end
        set(gca,'XScale','log')
        set(gca,'YScale','log')
        pbaspect([1.1 1 1])
        set(gca,'fontsize',22)
        xlim([10^-1 4])  
        ylim([2*10^-2 3])    
   
% Save Plot
saveas(gcf,['S14_Plots/' OutputName '_Scatter'],'epsc')


    
    
%% PARAM ENRICHMENT

% Colors for plots
colors = [[32 120 184]; ...     % Kt1
    [230 47 45]; ...            % Kp1
    [105 54 142]; ...           % Kt2
    [230 47 45]; ...            % Kp2
    [70 70 70]; ...             % n1
    [70 70 70]; ...             % n2
    [70 70 70]]/255;            % n3

% Sum n
params(7,:) = params(5,:)+params(6,:);

x = params(:,ind);
ranges = {};
for i=1:7
    tab = tabulate(params(i,:));
    ranges{i} = tab(:,1);
end

figure
for i=[1:4]
    
    fullrange = ranges{i};
    fullrange(:,2) = zeros(size(fullrange));
    
    subplot(2,6,i)
    
    % Get percentage of each parameters
    tab = tabulate(x(i,:));
    for j=1:length(tab(:,1))
        ind = find(fullrange(:,1)==tab(j,1));
        fullrange(ind,2) = tab(j,3)/100;
    end
    
    % Plot
    polygon_x = [min(fullrange(:,1)); fullrange(:,1); max(fullrange(:,1))];
    polygon_y = [0; fullrange(:,2); 0];
    patch(polygon_x,polygon_y,colors(i,:),'FaceAlpha',0.4); hold on
    
    semilogx(fullrange(:,1),fullrange(:,2),'-','Color',colors(i,:),'LineWidth',1.75)
    set(gca,'XScale','log')
    ylim([0 1])
    xlim([min(fullrange(:,1)),max(fullrange(:,1))])
    
end


for i=[5,6,7]
    fullrange = ranges{i};
    fullrange(:,2) = zeros(size(fullrange));
    
    subplot(2,6,i)
    
    % Get percentage of each parameters
    tab = tabulate(x(i,:));
    for j=1:length(tab(:,1))
        ind = find(fullrange(:,1)==tab(j,1));
        fullrange(ind,2) = tab(j,3)/100;
    end

    % Plot
    polygon_x = [min(fullrange(:,1)); fullrange(:,1); max(fullrange(:,1))];
    polygon_y = [0; fullrange(:,2); 0];
    patch(polygon_x,polygon_y,colors(i,:),'FaceAlpha',0.4); hold on
    
    plot(fullrange(:,1),fullrange(:,2),'-','Color',colors(i,:),'LineWidth',1.75)
    ylim([0 1])
    xlim([min(fullrange(:,1)),max(fullrange(:,1))])

end


% Save Image
r = 150; % pixels per inch
set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 1050 200]/r);
print(gcf,'-dpdf',sprintf('-r%d',r), ['S14_Plots/' OutputName '_ParamEnrich.pdf']);

    