import time,string,os,sys
import ReadFile
import WriteFileAll
import glob
import numpy as np
import math
import re


#sys.path.insert(0, '/Volumes/Promise_RAID/Py_toolbox')

class OurList(list):
    def join(self, s):
        return s.join(self)

def count_mutation(f):
	data=ReadFile.main(f,0,'\t')
	L=[]
	mtype=[]
	ndel=0
	nstop=0
	for line in data:
		
		wg=line[-5]
		if wg.find('True')>-1:
			mut=line[-8].split('(')
			if len(mut) > 1:
				mut=mut[1].split(')')[0]
				col=mut.split(',')
				for tmp in col:
					pn=tmp.split('_')[0]
					if len(tmp.split('_')) > 1:
						mn=tmp.split('_')[1]
						#res = re.split('(\d+)', mn)
						#if mn.find('del')>-1:print (mn)
						if mn.find('del')>-1: ndel += 1
						if mn.find('stop')>-1: nstop += 1

					if pn not in L:
							L.append(pn)		
	result={}
	for tmp in L:
		result[tmp]=0
	
	for line in data:
		mut=line[-8].split('(')
		if len(mut) > 1:
				mut=mut[1].split(')')[0]
				col=mut.split(',')
				wg=line[-5]
				if wg.find('True')>-1:
					for tmp in col:
						pn=tmp.split('_')[0]
						result[pn] += 1
	print ('DEL: ',ndel)
	print ('Stop: ',nstop)
	Lw=[]
	Lw.append(['DEL:',ndel])
	Lw.append(['Stop:',nstop])
	Lw.append(['Protein Coding:',91382343-nstop-ndel])
	Lw.append(['By protein:'])
	for tmp in result:
		print (result[tmp])
		Lw.append([tmp,result[tmp]])
	print (len(L))
	out=f+'.FigS1.txt'
	WriteFileAll.main(out,Lw,'\t')

def open_file(f):
	data=ReadFile.main(f,0,'\t')
	#meta_data=ReadFile.main(mf,0,'\t')
	print (data[0]+['Mut_n','S_mut_n'])
	Lc=[data[0]+['Mut_n','S_mut_n']]
	for line in data:
		col=line[-8].split(',')
		wg=line[-5]
		if wg.find('True')>-1:
		#print (line[-8])
		#print (len(col))
			num=0

			for tmp in col:
				if tmp.find('Spike') > -1:
					num += 1
			#print (num)
			#if line[0] == 'Virus name':
				#Lc.append(line+['Mut_n','S_mut_n'])
			if line[0] != 'Virus name':
				Lc.append(line+[len(col),num])
		#if wg.find('True')==-1:
			#print (line)
	#print (Lc)

	out=f+'.pmutation.wg.1.txt'
	WriteFileAll.main(out,Lc,'\t')



def mkdir(directory):
    if not os.path.exists(directory):
        os.makedirs(directory)




