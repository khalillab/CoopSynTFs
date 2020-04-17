qsub ./npbatch Thermo2Interp_TF_only_438
qsub ./npbatch Thermo2Interp_TF_only_438_2
qsub ./npbatch Thermo2Interp_TF_only_4210
qsub ./npbatch Thermo2Interp_TF_plusClamp_438
qsub ./npbatch Thermo2Interp_TF_plusClamp_4210


qsub -pe omp 12 -l h_rt=12:00:00 ./npbatch "TwoInput_Thermo( '181119_2in_thermo', 1, 1000 )"
qsub -pe omp 12 -l h_rt=12:00:00 ./npbatch "TwoInput_Thermo( '181119_2in_thermo', 1001, 2000 )"
qsub -pe omp 12 -l h_rt=12:00:00 ./npbatch "TwoInput_Thermo( '181119_2in_thermo', 2001, 3000 )"
qsub -pe omp 12 -l h_rt=12:00:00 ./npbatch "TwoInput_Thermo( '181119_2in_thermo', 3001, 4000 )"
qsub -pe omp 12 -l h_rt=12:00:00 ./npbatch "TwoInput_Thermo( '181119_2in_thermo', 4001, 5000 )"
qsub -pe omp 12 -l h_rt=12:00:00 ./npbatch "TwoInput_Thermo( '181119_2in_thermo', 5001, 6000 )"
qsub -pe omp 12 -l h_rt=12:00:00 ./npbatch "TwoInput_Thermo( '181119_2in_thermo', 6001, 7000 )"
qsub -pe omp 12 -l h_rt=12:00:00 ./npbatch "TwoInput_Thermo( '181119_2in_thermo', 7001, 8000 )"
qsub -pe omp 12 -l h_rt=12:00:00 ./npbatch "TwoInput_Thermo( '181119_2in_thermo', 8001, 8100 )"
