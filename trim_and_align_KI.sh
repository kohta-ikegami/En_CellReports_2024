#!/bin/bash
# This is extracted from: https://github.com/JunyueC/sci-RNA-seq3_pipeline/blob/master/sci3_main.sh

# trim_and_align.sh

if [ $# -lt 1 ]; then # '-lt' stands for less than

	echo -e "\n\tUsage: `basename $0` [umi fastq dir] [sample_id] [outdir] [star index] [cpu] [script dir]\n"

	echo -e "\tThis is takes UMI-attached fastq read2 files, trim reads, and align with STAR.\n"
	
	echo -e "\t[umi fastq dir] UMI-attached fastq dir produced by UMI_attach_KI.sh"	
	echo -e "\t[sample_id]     A simple list of Sample ID. This should much fastq filenames."	
	echo -e "\t[outdir]        Output directory in full path."
	echo -e "\t[star index]    STAR index dir."	
	echo -e "\t[cpu]           Num of CPU cores requested in pbs."
	echo -e "\t[script dir]    sci-RNAseq script folder.\n"

	exit 
fi


# 1) Variables

umi_fastq=${1};
sample_ID=${2};
all_output_folder=${3};
index=${4};
core=${5};
script_folder=${6};

# define the location of the R script for multi-core processing
R_script=$script_folder/sci3_bash_input_ID_output_core.R
script_path=$script_folder

# 2) Modules
module load R/3.2.0
module load STAR/2.7.9

################# Trimming the read2
echo
echo "Start trimming the read2 file..."
echo $(date)

#UMI_attached_R2=$all_output_folder/UMI_attach
UMI_attached_R2=$umi_fastq;
trimmed_fastq=$all_output_folder/trimmed_fastq
bash_script=$script_path/sci3_trim_KI.sh

Rscript $R_script $bash_script $UMI_attached_R2 $sample_ID $trimmed_fastq $core

############align the reads with STAR, filter the reads based on q > 30, and remove duplicates based on UMI sequence and tagmentation site

#define the output folder for mapping
input_folder=$trimmed_fastq
STAR_output_folder=$all_output_folder/STAR_alignment
filtered_sam_folder=$all_output_folder/filtered_sam

#align read2 to the index file using STAR
echo "Start alignment using STAR..."
echo $(date)

echo input folder: $input_folder
echo sample ID file: $sample_ID
echo index file: $index
echo output_folder: $STAR_output_folder

#make the output folder
mkdir -p $STAR_output_folder

#remove the index from the memory
STAR --genomeDir $index --genomeLoad Remove

#start the alignment
for sample in $(cat $sample_ID); do echo Aligning $sample;STAR --runThreadN $core --outSAMstrandField intronMotif --genomeDir $index --readFilesCommand zcat --readFilesIn $input_folder/$sample*gz --outFileNamePrefix $STAR_output_folder/$sample --genomeLoad LoadAndKeep; done
#remove the index from the memory
STAR --genomeDir $index --genomeLoad Remove
echo "All alignment done."

exit
