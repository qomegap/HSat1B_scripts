#!/usr/bin/env Rscript

library(dplyr, warn.conflicts = FALSE)
library(tidyr)
library(stringr)

#Args
args = commandArgs(trailingOnly=TRUE)
if(length(args) < 3)
{
  stop("Not enough arguments. Please supply 3 arguments.
       Usage: Rstudio track_to_bed inp.bed outm.bed outp.bed
       -inp Input bed from BigBED file
       -outm Output hap1/mat bed file
       -outp Output hap2/pat bed file")
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

#Convert mat/pat to hap1/hap2
df$mp[df$mp == 'mat'] = 'hap1'
df$mp[df$mp == 'pat'] = 'hap2'

df_1 <- df[df$mp == 'hap1',]
df_1 <- df_1[,-2]
df_2 <- df[df$mp == 'hap2',]
df_2 <- df_2[,-2]

#Save
print("Saving!!")
write.table(df_1, outm, sep="\t", col.names=FALSE, row.names = FALSE, append = TRUE, quote = FALSE) 
write.table(df_2, outp, sep="\t", col.names=FALSE, row.names = FALSE, append = TRUE, quote = FALSE) 
