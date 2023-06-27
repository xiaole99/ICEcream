#! /bin/bash
cat ${1}|while read familyfolder
do
echo ${familyfolder}
cd ${familyfolder}
if [ -s complete.gbk.icefinder.summary.txt ]
then
cat split.result.summary.noplasmid.txt |while read line
do
        Rscript /autofs/bal21/xlyin/completegenome/ICEfinder_ICEfamily_refer/familytools/merge.version6.R gbk/${line}.fa2.faa.merge.all.hmmscan.out 1e-5 complete.gbk.icefinder.summary.txt
done > R.log
else
echo 'complete.gbk.icefinder.summary.txt is empty'
fi
find gbk -type f -not -empty| grep '.fa2.faa$' >list.protein.txt
cat list.protein.txt|while read line;do blastp -db /autofs/bal21/xlyin/completegenome/ICEfinder_ICEfamily_refer/SARG_20200618_with_multicomponent.fasta -query ${line} -out ${line}.tab -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore slen qlen" -max_target_seqs 5; done >>arg.log
find gbk -type f -not -empty |grep '.faa.tab' >list.arg.out.list.txt
cd ..
done
