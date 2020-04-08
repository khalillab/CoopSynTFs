% Collate all 2 input thermodynamic simulations

folder = '2TF_Surface_Segments/'

temp_stor = zeros(576,8100);

%% Iterate through all files
mat = dir([folder '*.mat'])

for q = 1:length(mat)
    
    clear out_stor start finish params_approx params_meas
    
    % Load file
    filename = [folder mat(q).name];
    load(filename);
    
    % Store into one file
    temp_stor(:,start:finish) = out_stor(:,start:finish);
    
end

out_stor = temp_stor;

%% Save Mat file
save('181119_2TF_Surfaces_withClamp','params_approx','params_meas',...
    'out_stor','TF1','TF2');

%% Make sure all files were compiled
find(out_stor==0)