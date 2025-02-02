#!/bin/bash
# This is based on this: https://github.com/JunyueC/sci-RNA-seq3_pipeline/blob/master/sci3_main.sh

# gene_count.sh

if [ $# -lt 6 ]; then # '-lt' stands for less than

	echo -e "\n\tUsage: `basename $0` [sam_splitted] [barcode_sample] [gtf] [cpu] [script] [outdir]\n"

	echo -e "\t[sam_splitted]     \"sam_splitted\" dir generated by filter_sam_KI.sh."	
	echo -e "\t[barcode_sample]    barcode_samples.txt generated by filter_sam_KI.sh."	
	echo -e "\t[gtf]               gtf file."
	echo -e "\t[cpu]               Num of CPU cores requested in pbs."
	echo -e "\t[script]            sci-RNAseq script folder."
	echo -e "\t[outdir]            Output dir.\n"

	exit 
fi

# 1) Variables
input_folder=${1};
barcode_sample=${2};
gtf_file=${3};
core=${4};
script_folder=${5};
all_output_folder=${6};

# 2) Modules
module load python/2.7.5
python_path=$(which python)

now=$(date)
echo "Current time : $now"

################# gene count
# count reads mapping to genes

output_folder=$all_output_folder
script=$script_folder/sciRNAseq_count.py

echo "Start the gene count...."
$python_path $script $gtf_file $input_folder $barcode_sample $core

echo "Make the output folder and transfer the files..."
mkdir -p $output_folder
cat $input_folder/*.count > $output_folder/count.MM
rm $input_folder/*.count
cat $input_folder/*.report > $output_folder/report.MM
rm $input_folder/*.report
mv $input_folder/*_annotate.txt $output_folder/
echo "All output files are transferred~"

now=$(date)
echo "Current time : $now"