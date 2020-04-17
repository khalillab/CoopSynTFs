
qsub -pe omp 12 -l h_rt=12:00:00 ./npbatch2013 Generate_16h_3Node_NoFB
qsub -pe omp 12 -l h_rt=12:00:00 ./npbatch2013 Generate_16h_3Node_FB1
qsub -pe omp 12 -l h_rt=12:00:00 ./npbatch2013 Generate_16h_3Node_FB2