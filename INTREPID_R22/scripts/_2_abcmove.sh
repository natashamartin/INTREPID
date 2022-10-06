#!/bin/bash



# Define a list of string variable
# stringList=KG,MM,BY,UA,US,RU,PK,TZ
stringList=AF,AM,AU,GR,PK
# Use comma as separator and apply as pattern
for val in ${stringList//,/ }; do
	#outFile=${FASTA%.fasta*}.blastn.result.txt
	#blastn -db "$database" -word_size "$wordSize" -evalue "$evalue" -num_threads "$numThreads" -max_target_seqs "$max_target_seqs" -outfmt "$outputFormat" -query "$FASTA" -out "$outFile"
	mkdir ./ABC_outputs_lastgen/
	mkdir ./ABC_outputs_lastgen/$val
	cp ../_intrepid_22a*/ABC_outputs/$val/*lastGen.mat  ./ABC_outputs_lastgen/$val/


done


