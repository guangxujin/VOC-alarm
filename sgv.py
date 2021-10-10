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
s_data='../data_SGV.txt'
s_data=ReadFile.main(s_data,0,'\t')
header=s_data[0]
#header[4]='rers'
mut_col=8 # mut at the protein level
Lw=[[""]+header]
s_data_array=np.array(s_data[1:len(s_data)])
clade,indices=np.unique(np.array(s_data_array[:,4]), return_index=True)
geo,indices=np.unique(np.array(s_data_array[:,1]), return_index=True)
for each in clade:
        s_data_clade=s_data_array[s_data_array[:,4]==each,:]
        for c in geo:
                    s_data=s_data_clade[s_data_clade[:,1]==c,:]
                    pace=7
                #if (len(s_data)) > pace:
                    time,indices=np.unique(np.array(s_data[:,2]), return_index=True)
                    #print (each,time,indices)
                    if len(indices) <pace:
                        pace=len(indices)
                    if len(indices) > pace:
                            k=0
                            #mr_data=s_data[indices[k*pace]:indices[(k+1)*pace],5]
                            mr_data=s_data[indices[k*pace]:indices[(k+1)*pace],mut_col]
                            t=s_data[indices[k*pace],2]
                            m0=np.mean(np.array(mr_data,dtype=float))
                            #print (len(indices))
                            #print (s_data.shape)
                            for k in range (1,(len(indices)//pace)-1):
                                if (k+1)*pace <= len(indices):
                                        mr_data=s_data[indices[k*pace]:indices[(k+1)*pace],mut_col]

                                        t=s_data[indices[k*pace],2]
                                        m1=np.mean(np.array(mr_data,dtype=float))
                                        if float(m0)==0 or float(m1)/float(m0)==0: 
                                            r=0
                                        if float(m0)>0 and float(m1)/float(m0)>0:
                                             #print (float(m1)/float(m0))
                                             #r=math.log(float(m1)/float(m0),2)
                                             r=float(m1)/float(m0)-1
                                        mr_line=s_data[indices[(k+1)*pace],:]
                                        if r > threshold:
                                            r=threshold
                                        if r < -threshold:
                                            r=-threshold
                                        mr_line[mut_col]=r
                                        Lw.append(mr_line)
                                        m0=m1
                                if (k+1)*pace > len(indices):
                                        mr_data=s_data[indices[k*pace]:len(indices),mut_col]
                                        t=s_data[indices[k*pace],2]
                                        m1=np.mean(np.array(mr_data,dtype=float))
                                        if float(m0)==0 or float(m1)/float(m0)==0: 
                                            r=0
                                        if float(m0)>0 and float(m1)/float(m0)>0:
                                            #r=math.log(float(m1)/float(m0),2)
                                            r=float(m1)/float(m0)-1
                                        mr_line=s_data[indices[(k+1)*pace],:]
                                        if r > threshold:
                                            r=threshold
                                        if r < -threshold:
                                            r=-threshold
                                        mr_line[mut_col]=r
                                        Lw.append(mr_line)
                                        m0=m1
                                print (r)
#print (L)
fw='../data_mut_rate.txt'
WriteFileAll.main(fw,Lw,'\t')






