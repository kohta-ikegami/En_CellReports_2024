#!/bin/bash

# rename_fastq_KI.sh

if [ $# -lt 1 ]; then # '-lt' stands for less than

	echo -e "\n\tUsage: `basename $0` [a COPY!! of fastq_dir] [sample_id]\n"

	echo -e "\tThis script will rename fastq files to work with sci-RNA-seq3 pipeline\n"	
	echo -e "\t[fastq]         A COPY of fastq folder."	
	echo -e "\t[sample_id]     Sample ID list."	

	exit 
fi


input_folder=${1};
sample_ID=${2};

for sample in $(cat $sample_ID); 
	do echo changing name $sample; 
		mv $input_folder/*_read1_*$sample.fastq.gz $input_folder/$sample.R1.fastq.gz; 
		mv $input_folder/*_read2_*$sample.fastq.gz $input_folder/$sample.R2.fastq.gz;
	done

exit;