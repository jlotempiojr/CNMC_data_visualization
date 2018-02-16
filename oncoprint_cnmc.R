
library("ComplexHeatmap")
library("circlize")
library("scales")


#Get gene count in the format:
#Sample_ID  Gene_ID Variant_type
#604T    PIK3CA  SNP;DEL

gene_count<-read.delim("/Users/gaonkark/Documents/CNMC/somatic/gene_count.txt",header=TRUE,stringsAsFactors = FALSE)
colnames(gene_count)<-c("file","gene","count")  
gene_matrix<-acast(gene_count,gene~file)

tiff("/Users/gaonkark/Documents/CNMC/somatic/oncoprint.tiff")
col = c(SNP = "red",DEL= "blue",INS="green")
oncoPrint(gene_matrix, get_type = function(x) strsplit(x, ";")[[1]],
          alter_fun = list(
            SNP = function(x, y, w, h) grid.rect(x, y, w*0.9, h*0.9, gp = gpar(fill = col["SNP"], col = NA)),
            DEL = function(x, y, w, h) grid.rect(x, y, w*0.9, h*0.9, gp = gpar(fill = col["DEL"], col = NA)),
            INS = function(x, y, w, h) grid.rect(x, y, w*0.9, h*0.9, gp = gpar(fill = col["INS"], col = NA)))
            ,col = col)

dev.off()
