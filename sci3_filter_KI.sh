
input_folder=$1
sample=$2
output_folder=$3
samcore=$4

echo Filtering sample: $sample
samtools view -bh -q 30 -F 4 $input_folder/$sample*.sam|samtools sort -@ $samcore -|samtools view -h ->$output_folder/$sample.sam
echo Filtering $sample done.