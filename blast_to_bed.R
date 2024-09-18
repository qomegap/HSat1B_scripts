#!/usr/bin/env Rscript

library(dplyr, warn.conflicts = FALSE)

#Args
args = commandArgs(trailingOnly=TRUE)
if(length(args) < 3)
{
  stop("Not enough arguments. Please supply 3 arguments.
       Usage: Rstudio blast_to_bed inpa.bed inpg.bed out.bed
       -inpa Input Blast Alignment
       -inpg Input GenBank/RefSeq to cromosome guide
       -out Output file")
}
inpa <- args[1] #Alignments
inpg <- args[2] #Guide
out <- args[3]

#Loader
print("Loading...")
options(warn=-1)
guide <- readLines(inpg, warn=FALSE)
df_g <- read.table(text = guide)
gorgor1 <- readLines(inpa)
gorgor1 <- gorgor1[-(0:6)]
df <- read.table(text = gorgor1)
df <- df[,-c(1,3:8,11:12)]

#Cleaning
print("Cleaning data..")
colnames(df) <- c("Subject","end","start")
colnames(df_g) <- c("chr","Subject")
df <- df[,c("Subject","start","end")]

df <- merge(df, df_g)
df <- df[,-1]
df <- df[,c("chr","start","end") ]

#Convert into BED file
print("Convert to bed format...")
df_f <- cbind(df, name=NA, score=NA, strand=NA, thickStart=NA, thickEnd=NA, itemRgb =NA, diff=NA)
df_f$name <- "HSat1B"
df_f$score <- 900
df_f$strand <- "."
df_f[which(df_f$start > df_f$end), c("start", "end")] <- rev(df_f[which(df_f$start > df_f$end), c("start", "end")])
df_f$thickStart <- df_f$start
df_f$thickEnd <- df_f$end
df_f$itemRgb <- "14,0,120"

#Checker
print("Checking negatives...")
df_f$diff <- df_f$thickEnd - df_f$thickStart
df_f <- df_f[,-10]

#Save
print("Saving!!")
write.table(df_f, out, sep="\t", col.names=FALSE, row.names = FALSE, append = TRUE, quote = FALSE) 
