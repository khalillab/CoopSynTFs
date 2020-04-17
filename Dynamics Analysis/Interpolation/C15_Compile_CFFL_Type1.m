clear all

%% Load Data
load 181119_43_8_interp.mat params func_stor params_meas
fun1 = func_stor;
params1 = params;
params_meas1 = params_meas;

load 181119_2in_interp.mat params func_stor params_meas
fun2 = func_stor;
params2 = params;
params_meas2 = params_meas;

%% Storage Variables;
params = [];
params_meas = [];

ind1_stor = [];
ind2_stor = [];

%% Compile
L = 1;

% Size of third node complex
N_3in = params2(5,:)+params2(6,:);

for i=1:length(params1)
    
    % n, Kp1 of 2nd node complex
    n = params1(3,i);
    Kp1 = params1(2,i);
    
    % Find complex with same n and Kp1
    ind = find((n==N_3in)&(Kp1==params2(2,:)));
    
    for j=1:length(ind)
        
        % Compile parameters
        params(:,L) = [params1(:,i); params2(:,ind(j))];
        params_meas(:,L) = [params_meas1(:,i); params_meas2(:,ind(j))];

        
        % Save indices of interpolations
        ind1_stor(L) = i;
        ind2_stor(L) = ind(j);
        
        L = L+1;
    end
    
end

%% Save Data
save('181119_CFFL_Type1.mat','params','params_meas',...
        'ind1_stor','ind2_stor')
