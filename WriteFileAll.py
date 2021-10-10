

def main(FileName, L, Sep):
        
        fw=open(FileName,'w')
        L1=[]
        for k in range (len(L)):
            temp=L[k]
           
            for l in range (len(temp)):
                temp1=temp[l]
                if(l !=len(temp)-1):
                    fw.write('%s%s'%(temp1,Sep))
                if(l==len(temp)-1):
                    fw.write('%s'%(temp1))
            
            fw.write('\n')
        fw.close()              
                                                
if __name__ == '__main__':
        main()
