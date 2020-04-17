clear all

%% Load Data
load 181119_43_8_TFonly_FB1.mat params func_stor params_meas
fun1 = func_stor;
params1 = params;
params_meas1 = params_meas;

load 181119_Set_42_10.mat params func_stor params_meas

% 2nd node FB parameters
fun2 = func_stor;
params2 = params;
params_meas2 = params_meas;

% 3rd node parameters
fun3 = func_stor;
params3 = params;
params_meas3 = params_meas;


%% Storage Variables
params = [];
params_meas = [];

func1_stor = {};
func2_stor = {};
func3_stor = {};

ind1_stor = [];
ind2_stor = [];
ind3_stor = [];

%% Compile
L = 1;
for i=1:length(params1)
    for j=1:length(params2)
        
        % Size and PDZ affinity of 2nd node 42-10 config
        n = params2(3,j);
        Kp = params2(2,j);

        % Find assemblies at 3rd node with same n and Kp
        ind = find((n==params3(3,:))&(Kp==params3(2,:)));

        for k=1:length(ind)
            
            % Compile parameters
            params = [params [params1(:,i); params2(:,j); params3(:,ind(k))]];
            params_meas = [params_meas [params_meas1(:,i); params_meas2(:,j); params_meas3(:,ind(k))]];
           
%             % Store interpolations
%             func1_stor{L} = fun1{i};
%             func2_stor{L} = fun2{j};
%             func3_stor{L} = fun3{ind(k)};
            
            % Store indices of interpolations
            ind1_stor(L) = i;
            ind2_stor(L) = j;
            ind3_stor(L) = ind(k);            
            
            L = L+1;
        end
    
    end
    
end

%% Save Data
save('181119_Thermo_FB1.mat','params', 'params_meas', ...
    'ind1_stor','ind2_stor','ind3_stor');

%     'func1_stor','func2_stor','func3_stor', ...
