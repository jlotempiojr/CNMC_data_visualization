args<-commandArgs(TRUE)
gene_count_file<-args[1]

gene_count<-read.delim(gene_count_file,header=FALSE,sep=)

#file should be in format
#file_name\tgene_name\tcount
#remove genes with mutations present only in 1 sample
#levels(gene_count$count)<- c("0","1") 0=mutation absent ;1= mutation present

colnames(gene_count)<-c("file","gene","count")
E<-acast(gene_count,file~gene,value.var = "count")

# perform a fisher exact test for each pairs of gene and saves the oddsRatio and p-value
res <- NULL
for(i in 1:ncol(E)){
  for(j in i:ncol(E)){
    if(i!=j){
      f <- fisher.test(E[,i],E[,j]) 
      res <- rbind(res,cbind(geneA=colnames(E)[i],geneB=colnames(E)[j],oddsRatio=f$estimate,pvalue=f$p.value))
    }   
  }
}

theme_Publication <- function(base_size=16, base_family="Arial") {
  library(grid)
  library(ggthemes)
  (theme_foundation(base_size=base_size, base_family=base_family)
    + theme(plot.title = element_text(face = "bold",
                                      size = rel(1), hjust = 0.5),
            text = element_text(family="Arial"),
            panel.background = element_rect(colour = NA),
            plot.background = element_rect(colour = NA),
            panel.border = element_rect(colour = NA),
            axis.title = element_text(face = "bold",size = rel(0.85)),
            axis.title.y = element_text(angle=90,vjust =2,size=rel(0.85)),
            axis.title.x = element_text(vjust = -0.2,size=rel(0.85)),
            axis.text = element_text(size=12,color="black",face="bold"), 
            axis.line = element_line(colour="black",size=0.7),
            axis.ticks = element_line(),
            panel.grid.major = element_line(colour="#f0f0f0"),
            panel.grid.minor = element_blank(),
            legend.key = element_rect(colour = NA),
            legend.position = "right",
            legend.direction = "vertical",
            legend.key.size= unit(0.8, "cm"),
            legend.margin = margin(6,6,6,6),
            legend.title = element_text(face="italic"),
            plot.margin=unit(c(10,5,5,5),"mm"),
            strip.background=element_rect(colour="#f0f0f0",fill="#f0f0f0"),
            strip.text = element_text(face="bold")
    ))
  
}


# some formatting
rownames(res)<-c(1:nrow(res))
res <- as.data.frame(res)
res$geneA <- factor(res$geneA)
res$geneB <- factor(res$geneB)
res$oddsRatio <- as.numeric(as.character(res$oddsRatio))
res$pvalue <- as.numeric(as.character(res$pvalue))

# use p.adjust to correct for multi testing using a FDR
res <- cbind(res,fdr=p.adjust(res$pvalue,"fdr"))

# change the FDR in labels for plotting
res$stars <- cut(res$fdr, breaks=c(-Inf, 0.001, 0.05, 0.01, Inf), label=c("***", "**", "*", ""))

# plot with ggplot 2
require(ggplot2)
require(cowplot) # not necessary but the plot is nicer
p <- ggplot(res, aes(geneA, geneB)) + geom_tile(aes(fill = log(oddsRatio))) + scale_fill_gradient2(midpoint=1) + geom_text(aes(label=stars), color="black", size=5)+theme_Publication()+theme(axis.text.x = element_text(angle = 60, hjust = 1))+ggtitle("Mutual exclusivity between genes")

p
 


