

qsub -pe omp 12 -l h_rt=12:00:00 ./npbatch2013 Generate_FreqFilter_3Node
qsub -pe omp 12 -l h_rt=24:00:00 ./npbatch2013 Generate_FreqFilter_3Node_FB2
qsub -pe omp 12 -l h_rt=24:00:00 ./npbatch2013 Generate_FreqFilter_CFFL_NoFB
qsub -pe omp 12 -l h_rt=24:00:00 ./npbatch2013 Generate_FreqFilter_CFFL_FB2