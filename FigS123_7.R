library(entropy)
library(data.table)
library(ggplot2)

#Fig S1 plot
c=fread("Fig1c_rrate_mutation_circulating_clade_nmut_lineage-09282021.txt",header = T)
c=c[-1,]
cols=c("#E64B35", "#4DBBD5", "#009F86", "#445B8C", "#F39A7E", "#8390B4", "#90D1C2","#DC0000", "#836750", "#B09B84")
cmelt <- melt(c,id.vars = c("V1"),
              variable.name ="Days",
              value.name = "Mutation")
colnames(cmelt)=c("clade","Days","Mutation")
cmelt$Days=as.integer(cmelt$Days)
cmelt=merge(cmelt,d,by="Days")
cmelt$Data=as.Date(cmelt$Data)
ggplot(cmelt, aes(x = Data, y = Mutation, fill = clade)) +
  geom_stream(color = 1, lwd = 0.25,type = c("ridge")) +
  scale_fill_manual(values = cols) +theme(panel.grid =element_blank())+theme_minimal()+
  theme(legend.position = "bottom",legend.box = "horizontal",axis.text.x = element_text(angle = 45, hjust = 1)) +
  guides(fill= guide_legend(ncol = 10))+xlab("Date")+scale_x_continuous(breaks = c(as.Date("2020-01-01"),as.Date("2020-10-23"),as.Date("2021-02-07"),as.Date("2021-03-29"),as.Date("2021-05-31"),as.Date("2021-09-20")))

#data for Fig S2 
a=fread("metadata-dayn-gs-09282021.txt")
a=a[!a$clade=="",]
colnames(a)[1]="time"
a$group=ifelse(a$time<=297,"I",ifelse(a$time<=404,"II",ifelse(a$time<=454,"III",ifelse(a$time<=517,"IV","V"))))

a12=subset(a,time<=404)
gry=subset(a12,clade=="GRY")
ta=data.frame(table(gry$group,gry$lineage))
colnames(ta)=c("Stage","Lineage","Count")
x=c("B.1.1.7","Q.1","Q.2","Q.3","Q.4","Q.5","Q.6","Q.7","Q.8")
tal=ta[ta$Lineage %in% x,]
#tal=ta[!ta$Freq==0,]

#Fig S2 plot 
pa=ggplot(tal,mapping = aes(Lineage,Count,fill=Stage))+
  geom_bar(stat='identity',position='fill') +labs(x = 'Lineage',y = 'Variant_Count')+
  theme(axis.title =element_text(size = 16),axis.text =element_text(size = 14, color = 'black'))+
  scale_fill_manual(values = c("#FFFFD2","#F88FC6"))+theme_bw()+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

p=ggplot(tal,aes(Lineage,Count,fill=Stage))+
  geom_bar(stat='identity',width = 0.7,position='dodge')+theme_classic()+ylab("Variant_Count")+
  scale_fill_manual(values = c("#FFFFD2","#F88FC6"))+
  geom_text(aes(label =Count),size=4)+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
pb=gg.gap(plot=p,segments = c(100,100000),ylim = c(0,110000),tick_width = c(20,3000))
grid.arrange(pa,pb,ncol=2)

#data for Fig S3
a34=subset(a,time<=517 & time>404)
gk=subset(a34,clade=="GK")
ta=data.frame(table(gk$group,gk$lineage))
colnames(ta)=c("Stage","Lineage","Count")
x=c("B.1.617.2",as.character(unique(tal$Lineage)[grep("AY",unique(tal$Lineage))]))
tal=ta[ta$Lineage %in% x,]
#tal=ta[!ta$Freq==0,]

#Fig S3 plot 
pa=ggplot(tal,mapping = aes(Lineage,Count,fill=Stage))+
  geom_bar(stat='identity',position='fill') +labs(x = 'Lineage',y = 'Variant_Count')+
  theme(axis.title =element_text(size = 16),axis.text =element_text(size = 14, color = 'black'))+
  scale_fill_manual(values = c("#D1B1D6","#FFC68F"))+theme_bw()+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

p=ggplot(tal,aes(Lineage,Count,fill=Stage))+
  geom_bar(stat='identity',width = 0.7,position='dodge')+theme_classic()+ylab("Variant_Count")+
  scale_fill_manual(values = c("#D1B1D6","#FFC68F"))+
  geom_text(aes(label =Count),size=4)+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
pb=gg.gap(plot=p,segments =list(c(700,1000),c(2000,18000)) ,ylim = c(0,22000),tick_width = c(150,400,1500),rel_heights=c(1,0,0.5,0,0.5))
grid.arrange(pa,pb,ncol=2)

#data prepare for Fig S7
a5=subset(a,group=="V")
a5b=subset(a5,lineage=="B.1.630")
tb=as.data.frame(table(a5b$country),stringsAsFactors = F)
tb=tb[order(tb$Freq,decreasing=F),]
colnames(tb) <- c('Country', 'Freq')
percentage <- scales::percent(tb$Freq / sum(tb$Freq))
labs <- paste0(tb$Country,'(', percentage, ')')#设置标签名
tb$Country=factor(tb$Country,levels=tb$Country)
#plot Fig S7
p.pie=ggplot(tb, aes(x = "", y = Freq, fill = Country)) + 
  geom_bar(stat = "identity",width = 1) + 
  labs(x = "", y = "", title = "") +
  coord_polar(theta = "y")  +
  theme(axis.ticks = element_blank())+
  scale_fill_manual(values=c('#a6cee3','#1f78b4','#b2df8a','#33a02c','#fb9a99','#e31a1c','#fdbf6f','#ff7f00','#cab2d6','#6a3d9a','#ffff99'),labels = labs)+theme_minimal()
ggsave(plot=p.pie,filename="Total_pie.pdf",width=7, height=7)