#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

mut_f=args[1]

#setwd("~/Downloads/sep282021_covid19_metadata/covid-evolution")
### input: ../sep282021_covid19_metadata/metadata_tsv_2021_09_28/metadata.tsv.pmutation.wg.1.txt
#samples_meta.pmutation <- read.delim("../sep282021_covid19_metadata/metadata_tsv_2021_09_28/metadata.tsv.pmutation.wg.1.txt")
samples_meta=read.delim(mut_f)

loc=data.frame(do.call("rbind", strsplit(as.character(samples_meta$Location), " / ", fixed = TRUE)))
#loc=data.frame(do.call("rbind", strsplit(as.character(loc$X1), " ", fixed = TRUE)))

samples_meta.pmutation$Location <-loc$X1
samples_meta.pmutation$country <-loc$X2

loc=samples_meta.pmutation$Location
clade=samples_meta.pmutation$Clade
t=samples_meta.pmutation$Collection.date
lineage=samples_meta.pmutation$Pango.lineage
country=samples_meta.pmutation$country
age=samples_meta.pmutation$Patient.age
gender=samples_meta.pmutation$Gender
pmut=samples_meta.pmutation$Mut_n
spmut=samples_meta.pmutation$S_mut_n
df=data.frame(loc,t,lineage,clade,country,age,gender,pmut,spmut)
df=df[order(df$t),]

write.table(df,'data_SGV.txt',quote=F,sep='\t')
