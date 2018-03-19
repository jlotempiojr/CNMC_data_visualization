#! /usr/bin/Rscript 

#######################################################################################################
# Minfi QC Plots

# The following script reads .idat format data and produces QC plots and an inferred sex distibution
# Objects created in secion 1 can be used in other minfi experiments
# Last updated by Jonathan LoTempio Jr, March 18, 2018

#######################################################################################################

# Install packages
source("https://bioconductor.org/biocLite.R")
biocLite("minfi")
biocLite("IlluminaHumanMethylationEPICmanifest")
biocLite("IlluminaHumanMethylation450kanno.ilmn12.hg19")
biocLite("shinyMethyl")

install.packages("shiny")
install.packages("RColorBrewer")

# Load required packages 
library(minfi)
library(IlluminaHumanMethylationEPICmanifest)
library(IlluminaHumanMethylationEPICanno.ilm10b2.hg19)
library(shiny)
library(shinyMethyl)
library(RColorBrewer)

# Name your folder and add manifest.csv for all lanes in all chips
# Make a separate folder for each chip named for that chip ID

# 1.1 Read your data from folder, example folder name ODIPG_Meth
setwd("/Users/jonathanlotempio/Desktop/ODIPG_Meth")
methDir <- getwd()

# 1.2 This reads the manifest csv from the chip and creats a data array
methTargets <- read.metharray.sheet(methDir)

# 1.2.1 This checks the basename of the data within previous array
sub(methDir, "", methTargets$Basename)

# 1.3 This reads the experiment into data class RGChannelSet 
methRGset <- read.metharray.exp(targets = methTargets)

# 1.4.1 OR For SWAN normalization
SWANMethylSet <- preprocessSWAN(methRGset)

# 1.5 This reads the experiment into data class GenomicMethylSet
map_SWANMethylSet <- mapToGenome(SWANMethylSet)

# 2.1 Uses Genomic Methyl Set | Generate a QC file with plot
QC <- getQC(map_SWANMethylSet)
jpeg('qc_scatter.jpg')
plotQC(QC, badSampleCutoff = 10.5)
dev.off()

# 2.2 visualize QC as bean plot
jpeg('qc_bean.jpg')
densityBeanPlot(MethylSet, sampGroups = NULL, sampNames = NULL, main = NULL, pal = brewer.pal(8, "Dark2"), numPositions = 10000)
dev.off()

# 3.1 Uses Genomic Methyl Set | Estimate the sex of an individual based on their methylation profile, export to csv
sex <- getSex(object = map_MethylSet, cutoff = -2)
write.csv(sex, "Methyl_Sex_Check.csv")

# complete
print("QC complete")