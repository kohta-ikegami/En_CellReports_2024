#!/bin/bash

if [ $# -lt 2 ] # '-lt' stands for less than 
then
	echo -e "\n\tUsage: `basename $0` [Lig barcode] [RT barcode]\n"
  exit 
fi

lig_bc=$1;
rt_bc=$2;

awk 'BEGIN{i=1;j=1;}
	(NR==FNR) {a[NR]=$0; i++; next;} {b[FNR]=$0; j++; next;} 
	END {
		n=1; m=1;
		while(n < i){
			while(m < j){
				print a[n] b[m]; m++;
			};
			m=1;
			n++;
		}
	}' $lig_bc $rt_bc

exit;

