#! /bin/bash

# input1: input folder containing .gbk files for ICEfinder
# input2: temporary folder for ICEfinder
# input3: output folder for ICEfinder

inputF=${1}
tempF=${2}
outputF=${3}

if [[ -d ${tempF} || -d ${outputF} ]]
then
     echo 'The temporary folder or the output folder already exist, please delte it'
else
mkdir ${tempF}
mkdir ${outputF}
python scripts/GbffParser_YXL.py -i ${inputF} -f .gbk > ${outputF}/parser.log 
perl ICEfinder_modified4.pl -i ${inputF} -t ${tempF} -o ${outputF}  > ${outputF}/icefinder.log 
grep 'ERROR' ${outputF}/icefinder.log |rev|cut -d '/' -f 1 |rev|sed 's/.ptt file!//g' > ${outputF}/icefinder_first_error.txt
wc -l ${outputF}/icefinder_first_error.txt
mkdir ${outputF}/prokka
mkdir ${outputF}/prokka_out
cat ${outputF}/icefinder_first_error.txt|while read line ; do cp ${tempF}/${line}/${line}.fna ${outputF}/prokka; done
ls ${outputF}/prokka/|wc -l
cat ${outputF}/icefinder_first_error.txt|while read line; do prokka --outdir ${outputF}/prokka_out --force --prefix ${line} --cpus 20 ${outputF}/prokka/${line}.fna ; done >${outputF}/prokka.log

perl ICEfinder_modified4.pl -i ${outputF}/prokka_out -t ${outputF}/prokka_tmp -o ${outputF}/prokka_icefinder  > ${outputF}/icefinder.log.prokka

cat ${outputF}/*/*_summary.txt >> ${outputF}/complete.gbk.icefinder.summary.txt
wc -l ${outputF}/complete.gbk.icefinder.summary.txt
cat ${outputF}/prokka_icefinder/*/*_summary.txt >>${outputF}/complete.gbk.icefinder.summary.txt
wc -l ${outputF}/complete.gbk.icefinder.summary.txt

cat ${inputF}/split.result.summary.noplasmid.txt |while read line
do
	ICEfamily_refer/familytools/prodigal -p meta -i ${inputF}/${line}.fa -a ${inputF}/${line}.fa_prodigal.faa
	if [ -f ${inputF}/${line}.faa ]
	then
		python ICEfamily_refer/familytools/amendORF.py ${inputF}/${line}.faa ${inputF}/${line}.fa_prodigal.faa
		cat ${inputF}/${line}.faa ${inputF}/${line}.faa_append.faa >${inputF}/${line}.fa2.faa
	else
		python ICEfamily_refer/familytools/amendORF2.py ${inputF}/${line}.fa
	fi
	tools/hmmscan --tblout ${inputF}/${line}.fa2.faa.icefinder.hmmscan.out --cpu 20 data/ICE.hmm.db ${inputF}/${line}.fa2.faa
	grep -v "#" ${inputF}/${line}.fa2.faa.icefinder.hmmscan.out|tr -s ' ' '\t' >${inputF}/${line}.fa2.faa.icefinder.hmmscan.modified.out
	hmmscan --tblout ${inputF}/${line}.fa2.faa.YXL.hmmscan.out --cpu 20 ICEfamily_refer/conjugation/YXL_26family.hmm ${inputF}/${line}.fa2.faa
	grep -v "#" ${inputF}/${line}.fa2.faa.YXL.hmmscan.out|tr -s ' ' '\t' >${inputF}/${line}.fa2.faa.YXL.hmmscan.modified.out
	cat ${inputF}/${line}.fa2.faa.icefinder.hmmscan.modified.out ${inputF}/${line}.fa2.faa.YXL.hmmscan.modified.out >${inputF}/${line}.fa2.faa.merge.all.hmmscan.out
	Rscript ICEfamily_refer/familytools/merge.version6.R ${inputF}/${line}.fa2.faa.merge.all.hmmscan.out 1e-5 ${outputF}/complete.gbk.icefinder.summary.txt $outputF
done >${outputF}/family.log

find ${inputF} -type f -not -empty| grep '.fa2.faa$' > ${outputF}/list.protein.txt
cat ${outputF}/list.protein.txt|while read line
do 
blastp -db ICEfamily_refer/SARG_20200618_with_multicomponent.fasta -query ${line} -out ${outputF}/${line}.tab -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore slen qlen" -max_target_seqs 5
done >>${outputF}/arg.log
find ${inputF} -type f -not -empty |grep '.faa.tab' > ${outputF}/list.arg.out.list.txt
mkdir $outputF/ARG
cat ${outputF}/list.arg.out.list.txt|while read line
do
Rscript ICEfamily_refer/familytools/blastx_out_treatment_linux_20200828.R ${line} 70 80 ICEfamily_refer/familytools/structure_20200330_includingmutation.txt 1e-10 $outputF
done
fi
