clear all

%% Load Data

load 181119_2in_interp.mat params func_stor params_meas

fun1 = func_stor;
params1 = params;
params_meas1 = params_meas;

fun2 = func_stor;
params2 = params;
params_meas2 = params_meas;

%% Storage Variables;
params = [];
params_meas = [];

ind1_stor = [];
ind2_stor = [];


%% Reduce parameter space (because CFFL2 space is huge)

% Remove 1 Kt from each (4)
% Remove 1 Kp from each (4)

% keep_ind = find((params_meas1(1,:)~=0.143)&&(params_meas1(2,:)~=0.143));

% if (params1(1,i)~=0.0087)&&(params1(1,i)~=0.0654)&&(params1(1,i)~=0.1020)&&(params1(2,i)~=0.0159)&&(params1(3,i)~=0.0023)&&(params1(4,i)~=0.0159)



%% Compile

L = 1;

% Size of 2nd and 3rd node complex
N1_Tot = params1(5,:) + params1(6,:);
N2_Tot = params2(5,:) + params2(6,:);


for i=1:length(params1)
    
    % Reduce Second Node Space
    if (params_meas1(1,i)~=0.0065)&&(params_meas1(1,i)~=0.030)&&...
            (params_meas1(2,i)~=27.3)&&(params_meas1(3,i)~=0.218)&&...
            (params_meas1(3,i)~=0.415)&&(params_meas1(4,i)~=27.3)

        % Kps of 2nd node complex
        Kp1 = params1(2,i);
        Kp2 = params1(4,i);

        % Match Kps of 3rd node complex
        ind = find((N1_Tot(i)==N2_Tot)&(Kp1==params2(2,:))&(Kp2==params2(4,:)));

        for j=1:length(ind)
            
            % Reduce Third Node Space
            if (params_meas2(1,ind(j))~=0.0065)&&(params_meas2(1,ind(j))~=0.030)&&...
                    (params_meas2(3,ind(j))~=0.218)&&(params_meas2(3,ind(j))~=0.415)

                % Compile parameters
                params(:,L) = [params1(:,i); params2(:,ind(j))];
                params_meas(:,L) = [params_meas1(:,i); params_meas2(:,ind(j))];

                % Save indices of interpolations
                ind1_stor(L) = i;
                ind2_stor(L) = ind(j);

                L = L+1;
            
            end
            
        end
    end
end


%% Save Data
save('181119_CFFL_Type2.mat','params','params_meas',...
        'ind1_stor','ind2_stor')