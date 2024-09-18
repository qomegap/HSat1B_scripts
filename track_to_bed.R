#!/usr/bin/env Rscript

library(dplyr, warn.conflicts = FALSE)
library(tidyr)
library(stringr)
library(argparse)

#Args
args = commandArgs(trailingOnly=TRUE)
if(length(args) < 3)
{
  stop("Not enough arguments. Please supply 3 arguments.
       Usage: Rstudio track_to_bed inp.bed outm.bed outp.bed
       -inp Input bed from BigBED file
       -outm Output mat bed file
       -outp Output pat bed file")
}
inp <- args[1]
outm <- args[2]
outp <- args[3]

#Loader
print("Loading..")
options(warn=-1)
bed <- readLines(inp, warn=FALSE)
df <- read.table(text = bed)


#Cleaning
print("Cleaning data..")
colnames(df) <- c("chr","start","end","name","score","strand","thickStart","thickEnd","itemRgb")
df$itemRgb <- "14,0,120"
df <- df %>% separate(chr, c('chr', 'mp'))


#Filter
print("Filtering..")
if (!any(df=="HSat1B"))
    stop("No HSat1B")

df <- df %>%
  filter(str_detect(name, "HSat1B"))

df_m <- df[df$mp == 'mat',]
df_m <- df_m[,-2]
df_p <- df[df$mp == 'pat',]
df_p <- df_p[,-2]

#Save
print("Saving!!")
write.table(df_m, outm, sep="\t", col.names=FALSE, row.names = FALSE, append = TRUE, quote = FALSE) 
write.table(df_p, outp, sep="\t", col.names=FALSE, row.names = FALSE, append = TRUE, quote = FALSE) 
