% Collate all 2 input thermodynamic simulations

folder = '2D_Surfaces/'

out_stor = zeros(2500,8100);

%% Iterate through all files
mat = dir([folder '*.mat'])

for q = 1:length(mat)
    
    clear surf_stor start finish params params_meas
    
    % Load file
    filename = [folder mat(q).name];
    load(filename);
    
    % Store into one file
    out_stor(:,start:finish) = surf_stor(:,start:finish);
    
end

surf_stor = out_stor;

%% Save Mat file
save([folder '181119_2in_thermo_all.mat'],'params','params_meas',...
    'surf_stor','TF1range','TF2range');

%% Make sure all files were compiled
find(out_stor==0)