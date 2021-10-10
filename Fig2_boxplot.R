load("Fig1.rda")
x1=c("G","GH","GK","GV","GR","GRY")
cols=c("#E64B35", "#4DBBD5", "#009F86", "#445B8C", "#F39A7E", "#8390B4", "#90D1C2",
       "#DC0000", "#836750", "#B09B84")

#data for Fig 2C
x="alpha"
bb=subset(bmelt,clade=="G" |clade=="GH"|clade=="GK"|clade=="GR"|clade=="GRY"|clade=="GV")
a=subset(bb,Days>182 & Days<298)
a$group=ifelse(a$Data<as.Date("2020-08-01"),"2020-07",ifelse(a$Data<as.Date("2020-09-01"),"2020-08",ifelse(a$Data<as.Date("2020-10-01"),"2020-09","2020-10")))
#table(a$group,a$clade)
xtick=c(as.Date("2020-07-01"),as.Date("2020-08-01"),as.Date("2020-09-01"),as.Date("2020-10-01"),as.Date("2020-10-23"))
#run Fig 2C
ppbox(a)

#data for Fig 2G
x="delta"
a=subset(bb,Data>as.Date("2021-02-07") & Data<=as.Date("2021-03-29"))
a$group=ifelse(a$Data<as.Date("2021-03-01"),"2021-02","2021-03")
#table(a$group,a$clade)
xtick=c(as.Date("2021-02-07"),as.Date("2021-03-01"),as.Date("2021-03-29"))
#run Fig 2G
ppbox(a)

#data for Fig 2K
x="V"
a=subset(bb,Data>as.Date("2021-05-31"))
a$group=ifelse(a$Data<as.Date("2021-07-01"),"2021-06",ifelse(a$Data<as.Date("2021-08-01"),"2021-07",ifelse(a$Data<as.Date("2021-09-01"),"2021-08","2021-09")))
#table(a$group,a$clade)
xtick=c(as.Date("2021-06-01"),as.Date("2021-07-01"),as.Date("2021-08-01"),as.Date("2021-09-01"),as.Date("2021-09-20"))
#run Fig 2K
ppbox(a)

ppbox=function(data){
  #趋势图
  p1=ggplot(data, aes(x = Data, y = Proportion, group=clade, color=clade))+
    geom_point(size=0) +
    scale_color_manual(values = cols)+stat_smooth(method = "loess")+
    theme_classic()+
    theme(legend.position = "bottom",legend.box = "horizontal",axis.text.x = element_text(angle = 45, hjust = 1), axis.title.x = element_blank()) +
    guides(color = guide_legend(nrow = 1))+scale_x_continuous(breaks = xtick)
  ggsave(paste0(x,"_Fig2A.pdf"), width = 3, height = 4.2)
  #boxplot
   pp1=list()
for (i in x1) {
  pp=subset(data,clade==i)
  method<-ifelse(length(unique(pp$group))==2,"t.test","anova")
  pp1[[i]]=ggplot(pp, aes(x=group,y=Proportion,fill=group))+
    geom_boxplot()+
    scale_fill_manual(values = c('#edf8e9','#bae4b3','#74c476','#238b45'))+ 
    #scale_fill_gradientn(colours=c("#2E9FDF","white","#E7B800"),guide="legend")+
    labs(y="Proportion",x="Month")+theme_classic()+theme(axis.text.x = element_text(angle = 45, hjust = 1)) +ggtitle(i)+stat_compare_means(method=method)+guides(fill = F)
  #print(pp1)
}
pp2=plot_grid(plotlist=pp1, nrow=2)
ggsave(paste0(x,"box_Fig2A.pdf"), width = 6, height = 4.2)
}


#算均值及p
stat1=data.frame()
for(i in unique(a$clade)){
  x=subset(a,clade==i)
  n=aov(Proportion~group,x)
  p=summary(n)[[1]][["Pr(>F)"]][1]
  for(j in unique(a$group)){
    y=subset(x,group==j) 
    m=mean(y$Proportion)
    stat1=rbind(stat1,data.frame(clade=i,group=j,pro=m,p=p))
  }
}
#p=data.frame(stat1[,c(1,4)][!duplicated(stat1$clade),])

