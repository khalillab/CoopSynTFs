clear all

%% Load Data
load 181119_2in_interp.mat params func_stor params_meas
fun1 = func_stor;
params1 = params;
params_meas1 = params_meas;

load 181119_42_10_interp.mat params func_stor params_meas
fun2 = func_stor;
params2 = params;
params_meas2 = params_meas;

%% Storage Variables;
params = [];
params_meas = [];

func1_stor = {};
func2_stor = {};

ind1_stor = [];
ind2_stor = [];

%% Compile
L = 1;
for i=1:length(params1)
    
    % Size and Kp2 of 2nd node complex
    n = params1(5,i) + params1(6,i);
    Kp2 = params1(4,i);
    
    % Find 3rd node complexes with same n and Kp2
    ind = find((n==params2(3,:))&(Kp2==params2(2,:)));
    
    for j=1:length(ind)
        
        % Compile parameters
        params = [params [params1(:,i); params2(:,ind(j))]];
        params_meas = [params_meas [params_meas1(:,i); params_meas2(:,ind(j))]];

%         % Store functions
%         func1_stor{L} = fun1{i};
%         func2_stor{L} = fun2{ind(j)};
        
        % Save indices of interpolations
        ind1_stor(L) = i;
        ind2_stor(L) = ind(j);
        
        L = L+1;
    end
    
end

%% Save Data
save('181119_Thermo_FB2.mat','params','params_meas',...
    'ind1_stor','ind2_stor')

%     'func1_stor','func2_stor',...
