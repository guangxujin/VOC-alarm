from load import *

#from scipy import stats
def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        return False




s_data='../data_mut_rate.txt'
s_data=ReadFile.main(s_data,0,'\t')
print (len(s_data))
date='../days_to_num.csv'
d_data=ReadFile.main(date,0,',')
L=[]
Lw=[s_data[0]]
for line in s_data[1:len(s_data)]:
	day=line[2]
	for k in range (len(d_data)):
		if day == d_data[k][0]:
			dn=k+1
			line[0]=dn
			Lw.append(line)

#print (L)
fw='../data_mut_rate-dayn.txt'
WriteFileAll.main(fw,Lw,'\t')



