#!/bin/bash
# This is extracted from: https://github.com/JunyueC/sci-RNA-seq3_pipeline/blob/master/sci3_main.sh

# UMI_attach_KI.sh

if [ $# -lt 1 ]; then # '-lt' stands for less than

	echo -e "\n\tUsage: `basename $0` [fastq] [sample_id] [outdir] [cpu] [Lig] [RT] [script dir]\n"

	echo -e "\tThis script is a wrapper script to run UMI_barcode_attach_gzipped_with_dic.py. This is takes a fastq folder, a sample ID list, an output folder, the RT barcode list, the ligation barcode list and core number. Then it extracts the RT and ligation barcode from read1, corrects them to the nearest RT and ligation barcode (with edit distance <= 1), and attaches the RT and ligation barcode and UMI sequence to the read name of read2. Reads with unmatched RT or ligation barcodes are discarded.\n"
	
	echo -e "\t[fastq]         A copy of fastq folder. Fastq files must have been renamed using rename_fastq_KI.sh"	
	echo -e "\t[sample_id]     A simple list of Sample ID. This should much fastq filenames."	
	echo -e "\t[outdir]        Output directory in full path."
	echo -e "\t[cpu]           Num of CPU cores requested in pbs."
	echo -e "\t[Lig]           Ligation barcode pickle2 file. Make using generate_RT_lig_pickle_KI.py."
	echo -e "\t[RT]            RT barcode pickle2 file. Make using generate_RT_lig_pickle_KI.py."
	echo -e "\t[script dir]    sci-RNAseq script folder.\n"

	exit 
fi

# 1) Variables
fastq_folder=${1};
sample_ID=${2};
all_output_folder=${3};
core=${4};
ligation_barcode=${5};
RT_barcode=${6};
script_path=${7};

# define the bin of python (python V2.7)
# python_path="/net/shendure/vol1/home/cao1025/anaconda2/bin/" # <============= I suspect this is not needed.

# load required modules from UW GS cluster
# module load modules modules-init modules-gs
# module load samtools/1.4
# module load STAR/2.5.2b
# module load python/2.7.3
# module load cutadapt/1.8.3
# module load trim_galore/0.4.1

module load python/2.7.5
python_path=$(which python)


now=$(date)
echo "Current time : $now"

############ UMI attach
# This script takes an input folder, a sample ID list, an output folder, the RT barcode list, the ligation barcode list and core number. Then it extracts the RT and ligation barcode from read1, corrects them to the nearest RT and ligation barcode (with edit distance <= 1), and attaches the RT and ligation barcode and UMI sequence to the read name of read2. Reads with unmatched RT or ligation barcodes are discarded.

input_folder=$fastq_folder
output_folder=$all_output_folder/UMI_attach
script=$script_path/UMI_barcode_attach_gzipped_with_dic.py

echo "Attaching barcode and UMI...."
mkdir -p $output_folder
#$python_path/python $script $input_folder $sample_ID $output_folder $ligation_barcode $RT_barcode $core                       
$python_path $script $fastq_folder $sample_ID $output_folder $ligation_barcode $RT_barcode $core                       

echo "Barcode transformed and UMI attached."

exit;
