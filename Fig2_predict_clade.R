### meta data load
#metadata.dayn.gs.09282021 <- read.delim("~/Downloads/sep282021_covid19_metadata/covid-evolution/metadata-dayn-gs-09282021.txt", row.names=NULL)
md=metadata.dayn.gs.09282021

library(entropy)
library(data.table)
a1=fread("metadata-dayn-gs-09282021.txt")
a=a[!a$clade=="",]
colnames(a)[1]="time"
a$time=as.numeric(a$time)
a$group=ifelse(a$time<=297,"I",ifelse(a$time<=404,"II",ifelse(a$time<=454,"III",ifelse(a$time<=517,"IV","V"))))

### parameters for GR
clade2='GRY'
clade1='GR'
mdg=subset(a,time<=297)
mdgr=subset(mdg,clade==clade1|clade==clade2)
mdgr <-mdgr[mdgr$pmut<500,] # removal of large values
ggplot(mdgr,aes(pmut))+xlim(0,50)+
  geom_line(stat = 'density',adjust = 2.5) +theme_bw()+theme(axis.text.x = element_text(angle = 45, hjust = 1))
mdgrh=subset(mdgr,pmut>20 & pmut<50)
#run Fig2G
plotentr(mdgrh,122)

### parameters for GK
clade2='G'
clade1='GK'
### data processing
mdg=subset(a,time<=454 & time>404)
mdgk=subset(mdg,clade==clade1|clade==clade2)
mdgk <-mdgk[mdgk$pmut<500,] # removal of large values
ggplot(mdgk,aes(pmut))+
  geom_line(stat = 'density',adjust = 2.5) +theme_bw()+theme(axis.text.x = element_text(angle = 45, hjust = 1))
mdgkh=mdgk[as.numeric(mdgk$pmut)>30,] # small peak
# run Fig2H
plotentr(mdgkh1,429)

### parameters for V(GH, G,  GR ) 
#clade1='GR'
#clade1='G'
clade1='GH'
### data processing
mdd=subset(a,t>=as.Date("2021-08-01"))
mdv=subset(mdd,clade==clade1)
mdv <-mdv[mdv$pmut<500,] # removal of large values
ggplot(mdv,aes(pmut))+xlim(0,100)+
  geom_line(stat = 'density',adjust = 2.5) +theme_bw()+theme(axis.text.x = element_text(angle = 45, hjust = 1))
#mdvh=mdv[as.numeric(mdv$pmut)>39,]
mdv=mdv[order(mdv$pmut,decreasing = T),]
x=data.frame(table(mdv$pmut))
x=x[order(x$Var1,decreasing = T),]
x1=data.frame()
for (i in 2:nrow(x)){
  x1=x[1:i,]
  if (sum(x1[,2])/sum(x[,2])>0.05){
  cutoff=x1[i-1,]$Var1
  print(cutoff)
  break
  }
}
mdvh=mdv[as.numeric(mdv$pmut)>39,]

# 运行函数 run FigS6
plotentr(mdvh,605)


# function
plotentr=function(data,day){
    count=data.frame(table(data$lineage))
    ratio=count$Freq/sum(count$Freq)
    count=data.frame(count,ratio)
#count=count[count$Freq>10,] # Filter out small population

lin=c()
stat=c()

for (l in unique(data$lineage)){
  if (l %in% count$Var1){
  
  e=entropy(data[data$lineage==l,]$pmut, method='ML')
  lin=c(lin,l)
  stat=c(stat,e)
  }
}

## data for required stat
result=data.frame(lin,stat) 
result=result[order(result$stat,decreasing = T),]
length(unique(data$lineage))
colnames(result)=c("Var","entr")

#2020-05-01后与之前的variant count的比值
m1=subset(data,time<day)
m2=subset(data,time>=day)
count1=data.frame(table(m1$lineage))
count2=data.frame(table(m2$lineage))
colnames(count1)=c("Var","Freq1")
colnames(count2)=c("Var","Freq2")
m=merge(count1,count2,by="Var")
#m=m[m$Freq1>10,]
#m=m[m$Freq2>10,]
m$ratio=m$Freq2/m$Freq1
mentr=merge(m,result,by="Var")
#entr=entr[order(entr$entr),]
#entr$lin=factor(entr$lin,levels=c(entr$lin))
mentr$sum=rowSums(mentr[,2:3])
mentr=mentr[order(mentr$sum,decreasing = T),]
if (nrow(mentr)>10) {
  mentr1=mentr[1:10,]
} else {
  mentr1=mentr
}

mm=mentr1[1:3]
colnames(mm)=c("Lineage","g1","g2")
p=melt(mm,id.vars = c("Lineage"),
       variable.name ="Stage",
       value.name = "Count")
p$Lineage=factor(p$Lineage,levels =rev(mentr1$Var))
mentr1$Var=factor(mentr1$Var,levels =rev(mentr1$Var))
en=ggplot(mentr1, aes(x=Var,y=entr,fill=entr))+
  geom_bar(stat = 'identity')+coord_flip()+
  scale_fill_continuous(high='#feb24c', low='#ffffcc')+ 
  #scale_fill_gradientn(colours=c("#2E9FDF","white","#E7B800"),guide="legend")+
  labs(y="Entrophy",x="Lineage")+geom_hline(yintercept =4, linetype = 2, size = 0.3)+
  theme_classic()+guides(fill = F)
ra=ggplot(mentr1, aes(x=Var,y=ratio,fill=ratio))+
  geom_bar(stat = 'identity')+coord_flip()+
  scale_fill_continuous(low = '#e7e1ef', high='#dd1c77')+ 
  #scale_fill_gradientn(colours=c("#2E9FDF","white","#E7B800"),guide="legend")+
  labs(y="Ratio",x="Lineage")+geom_hline(yintercept =1, linetype = 2, size = 0.3)+
  theme_classic()+guides(fill = F)
ba=ggplot(p,mapping = aes(Lineage,Count,fill=Stage))+coord_flip()+
  geom_bar(stat='identity') +labs(x = 'Lineage',y = 'Variant_Count')+
  scale_fill_manual(values = c('#3182bd','#9ecae1'))+theme_classic()+scale_x_discrete(position = "top")+
  scale_x_discrete(position = "top")+scale_y_reverse()+guides(fill = F)
grid.arrange(en,ba,ra, ncol=3)
write.csv(mentr,file=paste0(clade1,"entr_count.csv"))
#write.csv(result,file=paste0(clade1,"entr.csv"))
}






