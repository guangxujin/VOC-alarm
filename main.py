from load import *

###### @author 
###### Guangxu Jin, wake forest school of medicine.
###### Hongyu Zhao, wake forest school of medicine.
######


####input and output

input_f="../metadata_tsv_2021_09_28/metadata.tsv" ### metadata downloaded from GISAID, only input needed
open_file(input_f) ### mutation number
count_mutation(input_f) ### statistic of mutations

mut_f="../metadata_tsv_2021_09_28/metadata.tsv.pmutation.wg.1.txt" ### output from open_file
os.system('Rscript metadata.R '+mut_f)
### output data_SGV.txt

os.system('python date_num_metadata.py') ### change date to num in metadata
### output is the input of Fig.1A

os.system('python sgv.py') ### calculate pace of sgv increase.

os.system('python date_num.py') ### change date to num in sgv data.

os.system('python sgv_clade_nmut_byday.py') ### calculate sgv at the clade level for each day.

os.system('python sgv_clade_proportion_byday.py') ### calculate variant proportion for each day.
### output is the input of Fig.1B

### Prediction steps and entropy analysis, see fig R codes.
###Fig1code.R
###Fig2_boxplot.R
###Fig2_predict_clade.R
###FigS123_7.R
###
###

###Prediction AUC-ROC
os.system('python ROC.py')
os.system('python ROC_delta.py')


