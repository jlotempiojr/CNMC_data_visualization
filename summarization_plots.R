final_clinical_dipg<-read.delim("~/Downloads/OPEN_DIPG.Sheet1.csv",sep=",")

tiff("~/Documents/CNMC/sample_age.tiff")
A<-ggplot(data=subset(final_clinical_dipg, Grade_dat %in% c("2","3","4")), aes( as.character(Grade_dat),as.numeric(Age_dat),fill=Grade_dat))+geom_boxplot()+ xlab(label = "Grade") +ylab(label = "Age")+theme(axis.text.x  = element_text(angle=90, vjust=0.5, size=12), axis.text.y=element_text(size=12))+stat_compare_means()

B<-ggplot(data=subset(final_clinical_dipg,Location_dat %in% c("Midline","Brainstem")), aes( as.character(Location_dat ),as.numeric(Age_dat),fill=Location_dat))+geom_boxplot()+ xlab(label = "Location") +ylab(label = "Age")+theme(axis.text.x  = element_text(angle=90, vjust=0.5, size=12), axis.text.y=element_text(size=12))+stat_compare_means()

C<-ggplot(data=subset(final_clinical_dipg,Histone %in% c("H3.1_K27M", "H3.2_K27M", "H3.3_G34R", "H3.3_K27M","Wild-type" )), aes( as.character(Histone ),as.numeric(Age_dat),fill=Histone))+geom_boxplot()+ xlab(label = "Histone") +ylab(label = "Age")+theme(axis.text.x  = element_text(angle=90, vjust=0.5, size=12), axis.text.y=element_text(size=12))+stat_compare_means()

grid.arrange(A,B,C,nrow=2)
dev.off()

tiff("~/Documents/CNMC/location_histone.tiff")
D<-ggplot(data=subset(final_clinical_dipg,Location_dat %in% c("Brainstem","Hemispheric","Midline")), aes(Location_dat,fill=Histone))+geom_bar()+xlab("Location")
dev.off()

#png("~/Downloads/clinical_OPEN_DIPG.png",height = 800,width = 800)
#nodes <- c( LETTERS[1:9] )
#edges <- list( B= list( A= 457 ), C= list( A= 198 ),D=list(B=215,C=135),E=list(B=224,C=25),F=list(B=18,C=38),G=list(D=39,F=23),H=list(D=69,E=39),I=list(D=209,E=183,F=27))
#r <- makeRiver( nodes, edges, node_xpos= c( 1,1.25,1.25,1.5,1.5,1.5,1.75,1.75,1.75 ),node_ypos = c(4,-8,10,-10,12,1,12,1,-10),
#                node_labels= c( A= "Subject (n=705)", B= "Pre-treatment(n=457)", C= "Post-treatment(n=198)",D="Brainstem(n=350)",E="Midline(n=258)",F="Thalamus(n=64)",G="Grade 2(n=62)",H="Grade 3(n=108)",I="Grade 4(n=419)"),
#                node_styles= list( A= list( col= "yellow" ) ))
#plot( r,srt=90,lyt=1)
#text(1.5, 5, "457", cex=.8, font=2)

#dev.off()

#png("~/Downloads/demograph_OPEN_DIPG.png",height = 700, width = 800)
#nodes <- c( LETTERS[1:5] )
#edges <- list( B= list( A= 298 ), C= list( A= 317 ),D=list(B=262,C=288),E=list(B=36,C=29))
#r <- makeRiver( nodes, edges, node_xpos= c( 1,1.25,1.25,1.5,1.5 ),node_ypos = c(4,-8,10,-10,12),
#                node_labels= c( A= "Subject (n=705)", B= "Female(n=298)", C= "Male(n=317)",D="Lessthan_15(n=590)",E="Morethan_15(n=83)"),
#                node_styles= list( A= list( col= "yellow" )) )
#plot( r,srt=90,lyt=1)
#text(1.5, 5, "457", cex=.8, font=2)





anno<-melt(table(final_clinical_dipg[,c(i,7)]))
colnames(anno)<-c("Anno","Location_dat","value")

for (i in c(5,6,8,9,10,11,13,14)){
  K<-melt(table(final_clinical_dipg[,c(i,7)]))
  colnames(K)<-c("Anno","Location_dat","value")
  print(K)
  anno<-rbind(anno,K)
  print(anno)
}

tiff("~/Documents/CNMC/subject_dist.tiff",height = 700, width = 500)
ggplot(as.data.frame(subset(anno, Anno != "<NA>" & Anno != "")),aes(x=Location_dat,y=as.factor(Anno),size=value,color=as.factor(Anno)))+geom_point()+xlab(label = NULL)+ylab(label = NULL)+scale_size_continuous(range = c(1,10))+theme(axis.text.x  = element_text(angle=90, vjust=0.5, size=12), axis.text.y=element_text(size=12))

dev.off()
