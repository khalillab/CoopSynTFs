clear all

%% Load Data
load 181119_Set_43_8.mat params func_stor params_meas
fun1 = func_stor;
params1 = params;
params_meas1 = params_meas;

load 181119_Set_42_10.mat params func_stor params_meas
fun2 = func_stor;
params2 = params;
params_meas2 = params_meas;

%% Storage Variables
params = [];
params_meas = [];

func1_stor = {};
func2_stor = {};

ind1_stor = [];
ind2_stor = [];

%% Compile
L = 1;
for i=1:length(params1)
    
    % 43_8 assembly size
    n = params1(3,i);
    
    % Find configs where 42_10 assembly = 43_8 assembly
    ind = find(n==params2(3,:));
    
    for j=1:length(ind)
        
        % Compile parameters
        params = [params [params1(:,i); params2(:,ind(j))]];
        params_meas = [params_meas [params_meas1(:,i); params_meas2(:,ind(j))]];
        
       
        % Save interpolations
        func1_stor{L} = fun1{i};
        func2_stor{L} = fun2{ind(j)};
        
        % Save indices of interpolations
        ind1_stor(L) = i;
        ind2_stor(L) = ind(j);
                
        L = L+1;
        
    end
    
end

%% Save Data
save('181119_Thermo_3N_NoFB.mat','params','params_meas', ...
    'func1_stor','func2_stor', ...
    'ind1_stor','ind2_stor')
