
input_folder=$1
sample=$2
output_folder=$3
barcode_file=$4
cutoff=$5
python_script=$6

mismatch=1
#python="/net/shendure/vol1/home/cao1025/anaconda2/bin/python2.7"
#python_script="/net/shendure/vol1/home/cao1025/analysis_script/sci3/sam_split.py"

module load python/2.7.5
python_path=$(which python)

$python_path $python_script $input_folder/$sample.sam $barcode_file $output_folder $cutoff
echo splitting sample done: $sample