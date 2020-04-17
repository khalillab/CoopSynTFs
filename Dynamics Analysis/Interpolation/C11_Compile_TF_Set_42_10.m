clear all

%% Load Data
load 181119_42_10_TFonly_2_5.mat params func_stor params_meas
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
func_stor = {};

%% Compile
params = [params1 params2];
params_meas = [params_meas1 params_meas2];
func_stor = [fun1 fun2];

%% Save Data
save('181119_Set_42_10.mat','params','func_stor','params_meas')
