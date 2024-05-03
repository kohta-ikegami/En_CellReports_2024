
input_folder=$1
sample=$2
output_folder=$3

#module load python/2.7.3
#module load cutadapt/1.8.3
#module load trim_galore/0.4.1

module load python/2.7.5
module load cutadapt/2.1.0
module load trimgalore/0.4.2

echo Trimming sample: $sample
trim_galore $input_folder/$sample*.gz -a AAAAAAAA --three_prime_clip_R1 1 -o $output_folder

#module unload python/2.7.3
module unload python/2.7.5

echo Trimming $sample done.

exit

