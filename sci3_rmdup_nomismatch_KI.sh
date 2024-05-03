
input_folder=$1
sample=$2
output_folder=$3
mismatch=$4
python_script=$5

#python="/net/shendure/vol1/home/cao1025/anaconda2/bin/python2.7"
#python_script="/net/shendure/vol1/home/cao1025/analysis_script/sci3/rm_dup_barcode_UMI_no_mismatch.py"

module load python/2.7.5
python_path=$(which python)

echo Filtering sample: $sample

$python_path $python_script $input_folder/$sample.sam $output_folder/$sample.sam $mismatch

echo Filtering $sample done.