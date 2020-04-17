

qsub -pe omp 12 -l h_rt=12:00:00 ./npbatch2013 Generate_OnePulse_3Node
qsub -pe omp 12 -l h_rt=16:00:00 ./npbatch2013 Generate_OnePulse_CFFL