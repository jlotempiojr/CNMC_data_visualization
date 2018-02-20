args<-commandArgs(TRUE)
snp_count_file<-args[1]
cnv_count_file<-args[2]
sample_key_file<-args[3]
meta_data_file<-args[4]
work_dir<-args[5]

library("ComplexHeatmap")
library("circlize")
library("reshape2")
setwd(work_dir)

#Get gene count in the format:
#Sample_ID  Gene_ID Variant_type
#101    PIK3CA  SNP;DEL

#Get cnv count in the format:
#101  PIK3CA gain

snp_count<-read.delim(snp_count_file,header=FALSE,stringsAsFactors = FALSE,sep="\t")
cnv_count<-read.table(cnv_count_file,header=FALSE,stringsAsFactors = TRUE,sep="\t")
sample_key<-read.delim(sample_key_file,header=TRUE,stringsAsFactors = FALSE,sep=",")[,c(2,5)]
final_clinical_dipg<-read.delim(meta_data_file,sep=",")

colnames(snp_count)<-c("file","gene","snp")  
colnames(cnv_count)<-c("file","gene","cnv")
colnames(sample_key)<-c("cavaticaID","sampleID")
snp_count<-merge(sample_key,snp_count,by.y="file",by.x="sampleID")
cnv_count<-merge(sample_key,cnv_count,by.y="file",by.x="cavaticaID")

merged_dat<-merge(snp_count,cnv_count,by=c("sampleID","cavaticaID","gene"))
merged_dat$onco <- apply( merged_dat[ , c(4,5) ] , 1 , paste , collapse = ";" )
gene_matrix<-acast(merged_dat,gene~sampleID,value.var = "onco")

Anno_sample<-final_clinical_dipg[which(final_clinical_dipg$Sample_ID %in% sample_key$sampleID),c(5,6,8,9,10,11,13,14)]


#sample_col<-rainbow(length(colnames(gene_matrix)))
#names(sample_col)<-colnames(gene_matrix)
ha=HeatmapAnnotation(df=Anno_sample)
#ha = HeatmapAnnotation( df= data.frame(subjectID=colnames(gene_matrix),age=runif(length(colnames(gene_matrix)),min=0,max=10)))
#draw(ha, 1:2)
ha_height = max_text_height(colnames(Anno_sample))
                       
filename<-paste(work_dir,"oncoprint.tiff",sep="/")
tiff(filename)
col = c(SNP = "darkgreen",DEL= "darkgreen",INS="darkgreen", gain="red", loss="blue")
oncoPrint(gene_matrix, get_type = function(x) strsplit(x, ";")[[1]],
          alter_fun = list(
            gain = function(x, y, w, h) grid.rect(x, y, w*0.2, h*0.5, gp = gpar(fill = col["gain"],col = col["gain"])),
            loss = function(x, y, w, h) grid.rect(x, y, w*0.2, h*0.5, gp = gpar(fill = col["loss"],col = col["loss"])),
            SNP = function(x, y, w, h) grid.rect(x, y, w*0.5, h*0.2, gp = gpar(fill = col["SNP"], col = NA)),
            DEL = function(x, y, w, h) grid.rect(x, y, w*0.5, h*0.2, gp = gpar(fill = col["DEL"], col = NA)),
            INS = function(x, y, w, h) grid.rect(x, y, w*0.5, h*0.2, gp = gpar(fill = col["INS"], col = NA)))
            ,col = col,bottom_annotation =ha, bottom_annotation_height = unit(2, "cm") )

 dev.off()




