from load import *
#from scipy import stats
import math
def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        return False

threshold=1.5
s_data='../metadata-dayn-gs-09282021.txt'
s_data=ReadFile.main(s_data,0,'\t')
header=s_data[0]
day_start=1
day_end=220
days=range(1,650) #[[1,220],[220,250],[250,300],[300,375],[375,450],[450,520],[520,600],[600,630]]
#header[4]='rers'
mut_col=8 # mut at the protein level
#variants=["B.1.1.7","B.1.617.2","B.1.612"]
s_data_array=np.array(s_data[1:len(s_data)])
variants,indices=np.unique(np.array(s_data_array[:,4]), return_index=True)
#print (clade)
Lw=[['']+variants.tolist()]
for day_range in days:
    s_data_date=[]
    for line in s_data_array:
        if float(line[0]) == float(day_range):
            s_data_date.append(line)
    s_data_date=np.array(s_data_date)
    print (s_data_date.shape)
    #clade,indices=np.unique(np.array(s_data_date[:,4]), return_index=True)
    #geo,indices=np.unique(np.array(s_data_array[:,1]), return_index=True)
    tmp=[str(day_range)]
    #print (clade)
    if len(s_data_date) > 0:
        for each in variants:
                s_data_clade=s_data_date[s_data_date[:,4]==each,:]
                total=sum( [float(x) for x in s_data_clade[:,-2]])
                tmp.append(float(len(s_data_clade))/float(len(s_data_date)))
        print (tmp)
        Lw.append(tmp)
#print (L)
Lw=np.array(Lw)
Lw=np.transpose(Lw)
fw='../rate_mutation_circulating_clade_proportion-09282021.txt'
WriteFileAll.main(fw,Lw,'\t')






