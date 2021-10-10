from load import *

#from scipy import stats
def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        return False




f='../ROC/gk.roc.txt'
s_data=ReadFile.main(f,0,'\t')
print (len(s_data))

L=[]
for line in s_data[1:len(s_data)]:
	pre=line[4]
	#print (pre)
	if pre in ['AY.4','B.1.617.2']:
		if pre != 'B.1.1.7':
			y1=1
			y=1
			L.append([y1,y])
	if pre in ['B.1.214.2']:
		if pre != 'B.1.1.7':
			y1=1
			y=0
			L.append([y1,y])
	if pre not in ['AY.4','B.1.617.2','B.1.214.2']:
		if line[5] == 'GK':
			y1=0
			y=1
			if pre != 'B.1.1.7':
				L.append([y1,y])
		if line[5] != 'GK':
			y1=0
			y=0
			if pre != 'B.1.1.7':
				L.append([y1,y])
print (len(L))
y1=[]
y=[]
for line in L:
	y1.append(float(line[0]))
	y.append(float(line[1]))
	if line[0] != line[1]:print (line)
import numpy as np
import matplotlib.pyplot as plt
from itertools import cycle

from sklearn import svm, datasets
from sklearn.metrics import roc_curve, auc
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import label_binarize
from sklearn.multiclass import OneVsRestClassifier
from scipy import interp
from sklearn.metrics import roc_auc_score

fpr = dict()
tpr = dict()
roc_auc = dict()
# Compute micro-average ROC curve and ROC area
fpr["micro"], tpr["micro"], _ = roc_curve(y1,y)
roc_auc["micro"] = auc(fpr["micro"], tpr["micro"])
print (roc_auc["micro"])
#Plot of a ROC curve for a specific class

plt.figure()
lw = 2
plt.plot(fpr["micro"], tpr["micro"], color='darkorange',
         lw=lw, label='ROC curve (area = %0.2f)' % roc_auc["micro"])
plt.plot([0, 1], [0, 1], color='navy', lw=lw, linestyle='--')
plt.xlim([0.0, 1.0])
plt.ylim([0.0, 1.05])
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.title('Delta')
plt.legend(loc="lower right")
#plt.show()
plt.savefig("Delta.pdf")




