library(reshape2)
library(ggplot2)
library(ggpubr)
library(tidyverse)
library(ggstream)
library(cowplot)
Sys.setenv(LANGUAGE = "en") #显示英文报错信息
options(stringsAsFactors = FALSE)
a=fread("metadata-dayn-gs-09282021.txt")
a=a[!a$clade=="",]
#a=subset(a,pmut<100)
a1=subset(a,pmut<100)
pmutd=sapply(unique(a1$t), function(x){
  y=subset(a1,t==x)
  mean(y$pmut)
  #quantile(y$pmut,0.5)
})
names(pmutd)=unique(a1$t)
pmutd=data.frame(pmutd)
pmutd$time=unique(a1$t)
pmutd$time=as.Date(pmutd$time)
#Fig 1A plot
pa=ggplot(pmutd,aes(time,pmutd))+
  geom_point(size=0.5)+xlab("Date")+ylab("Mutation")+
  theme_classic()+scale_x_continuous(breaks = c(as.Date("2020-01-01"),as.Date("2020-10-23"),as.Date("2021-02-07"),as.Date("2021-03-29"),as.Date("2021-05-31"),as.Date("2021-09-20")))+
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        axis.text.y = element_text(colour="grey20",size=12,angle=0,hjust=1,vjust=0,face="plain"),  
        axis.title.x = element_text(colour="grey20",size=12,angle=0,hjust=.5,vjust=0,face="plain"),
        axis.title.y = element_text(colour="grey20",size=16,angle=90,hjust=.5,vjust=.5,face="plain"))


#Fig 1B_calculate p
df1 <- read.delim("data_mut_rate-dayn.txt")
df1$clade=factor(df1$clade,levels=unique(df1$clade))
df1[df1$clade=="NA",'clade']="Unknown"
df1$x=rownames(df1)
df1=df1[order(df1$t),]
data=df1
data$x=1:length(data[,1])
#loessMod50 <- loess(pmut ~ X, data=data) # 50% smoothing span
loessMod50 <- loess(pmut ~ X, data=data,span=0.5,degree = 2L) # 50% smoothing span
smoothed50 <- predict(loessMod50)
data$p<-smoothed50
#Fig 1B plot
data$t=as.Date(data$t)
pb=ggplot(data,aes(t,p))+
  geom_point(size=0.5)+xlab("Date")+ylab("Pace of increased SGV")+
  geom_vline(xintercept =as.numeric(as.Date("2020-10-23")), linetype = 2, size = 0.3)+
  geom_vline(xintercept =as.numeric(as.Date("2021-02-07")), linetype = 2, size = 0.3)+
  geom_vline(xintercept =as.numeric(as.Date("2021-03-29")), linetype = 2, size = 0.3)+
  geom_vline(xintercept =as.numeric(as.Date("2021-05-31")), linetype = 2, size = 0.3)+
  theme_classic()+scale_x_continuous(breaks = c(as.Date("2020-01-01"),as.Date("2020-10-23"),as.Date("2021-02-07"),as.Date("2021-03-29"),as.Date("2021-05-31"),as.Date("2021-09-20")))+
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        axis.text.y = element_text(colour="grey20",size=8,angle=0,hjust=1,vjust=0,face="plain"),  
        axis.title.x = element_text(colour="grey20",size=12,angle=0,hjust=.5,vjust=0,face="plain"),
        axis.title.y = element_text(colour="grey20",size=16,angle=90,hjust=.5,vjust=.5,face="plain"))

#Fig 1C plot
b=fread("Fig1b_rate_mutation_circulating_clade_proportion-09282021.txt",header = T)
b=b[-1,]
cols=c("#E64B35", "#4DBBD5", "#009F86", "#445B8C", "#F39A7E", "#8390B4", "#90D1C2","#DC0000", "#836750", "#B09B84")
bmelt <- melt(b,id.vars = c("V1"),
              variable.name ="Days",
              value.name = "Proportion")
colnames(bmelt)=c("clade","Days","Proportion")
bmelt$Days=as.integer(bmelt$Days)
d=read.csv("days_to_num.csv")
colnames(d)=c("Data","Days")
d$Days=1:733
bmelt=merge(bmelt,d,by="Days")
bmelt$Data=as.Date(bmelt$Data)
pc=ggplot(bmelt, aes(x = Data, y = Proportion, fill = clade)) +
  geom_stream(color = 1, lwd = 0.25,type = c("proportional")) +
  scale_fill_manual(values = cols) +theme(panel.grid =element_blank())+theme_minimal()+
  theme(legend.position = "bottom",legend.box = "horizontal",axis.text.x = element_text(angle = 45, hjust = 1)) +
  guides(fill= guide_legend(ncol = 10))+xlab("Date")+scale_x_continuous(breaks = c(as.Date("2020-01-01"),as.Date("2020-10-23"),as.Date("2021-02-07"),as.Date("2021-03-29"),as.Date("2021-05-31"),as.Date("2021-09-20")))
#plot_grid(pb,pa,pc,ncol = 2,align = 'hv',rel_heights=c(1,1.35))
save(data,bmelt,cmelt,file="Fig1.rda")

#data prepare for Fig 1D,E 
a=fread("metadata-dayn-gs-09282021.txt")
a=a[!a$clade=="",]
colnames(a)[1]="time"
a$group=ifelse(a$time<=297,"I",ifelse(a$time<=404,"II",ifelse(a$time<=454,"III",ifelse(a$time<=517,"IV","V"))))
a12=subset(a,time<=404)
gry=subset(a12,clade=="GRY")

a34=subset(a,time<=517 & time>404)
gk=subset(a34,clade=="GK")

#Fig 1D plot (GRY bar)
tgry=data.frame(table(gry$group))
colnames(tgry)=c("Stage","Count")
#barplot
p=ggplot(tgry,aes(x=Stage,y=Count,fill=Stage))+
  geom_bar(stat='identity',alpha=0.5)+theme_classic()+ylab("Variant_Count")+
  scale_fill_manual(values = c("#ffff99","#f0027f"))+
  geom_text(aes(label =Count),size=6)
p1=gg.gap(plot=p,segments = c(100,100000),ylim = c(0,112000),tick_width = c(30,3000))

#Fig 1E plot (GK bar)
tgk=data.frame(table(gk$group))
colnames(tgk)=c("Stage","Count")
#barplot
p=ggplot(tgk,aes(x=Stage,y=Count,fill=Stage))+
  geom_bar(stat='identity',width = 0.7,alpha=0.5)+theme_classic()+ylab("Variant_Count")+
  scale_fill_manual(values = c("#984ea3","#ff7f00"))+
  geom_text(aes(label =Count),size=6)
p2=gg.gap(plot=p,segments = c(1110,40000),ylim = c(0,52000),tick_width = c(300,3000))


