# HSat1B_scripts
Scripts to analyze different data from HSa1tB in primates

Scripts usage:

track_to_bed.R
Usage: Rscript track_to_bed inp.bed outm.bed outp.bed
       -inp Input bed from BigBED file
       -outm Output hap1/mat bed file
       -outp Output hap2/pat bed file

blast_to_bed.R
Usage: Rscript blast_to_bed inpa.bed inpg.bed out.bed
       -inpa Input Blast Alignment
       -inpg Input GenBank/RefSeq to cromosome guide
       -out Output file
