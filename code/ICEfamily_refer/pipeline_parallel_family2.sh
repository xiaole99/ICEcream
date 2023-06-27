#! /bin/bash
python scripts/GbffParser_YXL.py -i gbk -f .gbk > parser.log
cat split.result.summary.noplasmid.txt |while read line
do
	/autofs/bal21/xlyin/completegenome/ICEfinder_ICEfamily_refer/familytools/prodigal -p meta -i gbk/${line}.fa -a gbk/${line}.fa_prodigal.faa
	if [ -s gbk/${line}.faa ]
	then
		python /autofs/bal21/xlyin/completegenome/ICEfinder_ICEfamily_refer/familytools/amendORF.py gbk/${line}.faa gbk/${line}.fa_prodigal.faa
		cat gbk/${line}.faa gbk/${line}.faa_append.faa >gbk/${line}.fa2.faa
	else
		python /autofs/bal21/xlyin/completegenome/ICEfinder_ICEfamily_refer/familytools/amendORF2.py gbk/${line}.fa
	fi
	/autofs/bal21/xlyin/completegenome/ICEfinder_ICEfamily_final/tools/hmmscan --tblout gbk/${line}.fa2.faa.icefinder.hmmscan.out --cpu 1 /autofs/bal21/xlyin/completegenome/ICEfinder_ICEfamily_final/data/ICE.hmm.db gbk/${line}.fa2.faa
	grep -v "#" gbk/${line}.fa2.faa.icefinder.hmmscan.out|tr -s ' ' '\t' >gbk/${line}.fa2.faa.icefinder.hmmscan.modified.out
	hmmscan --tblout gbk/${line}.fa2.faa.YXL.hmmscan.out --cpu 1 /autofs/bal21/xlyin/completegenome/ICEfinder_ICEfamily_refer/conjugation/YXL_26family.hmm gbk/${line}.fa2.faa
	grep -v "#" gbk/${line}.fa2.faa.YXL.hmmscan.out|tr -s ' ' '\t' >gbk/${line}.fa2.faa.YXL.hmmscan.modified.out
	cat gbk/${line}.fa2.faa.icefinder.hmmscan.modified.out gbk/${line}.fa2.faa.YXL.hmmscan.modified.out >gbk/${line}.fa2.faa.merge.all.hmmscan.out
#	Rscript /autofs/bal21/xlyin/completegenome/ICEfinder_ICEfamily_refer/familytools/merge.version6.R gbk/${line}.fa2.faa.merge.all.hmmscan.out 1e-5 complete.gbk.icefinder.summary.txt
done >family.log
find gbk -type f -not -empty| grep '.fa2.faa$' >list.protein.txt
cat list.protein.txt|while read line;do blastp -db /autofs/bal21/xlyin/completegenome/ICEfinder_ICEfamily_refer/SARG_20200618_with_multicomponent.fasta -query ${line} -out ${line}.tab -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore slen qlen" -max_target_seqs 5; done >>arg.log
find gbk -type f -not -empty |grep '.faa.tab' >list.arg.out.list.txt
#cat list.arg.out.list.txt|while read line; do Rscript /autofs/bal21/xlyin/completegenome/ICEfinder_ICEfamily_refer/familytools/blastx_out_treatment_linux_20200828.R ${line} 70 80 /autofs/bal21/xlyin/completegenome/ICEfinder_ICEfamily_refer/familytools/structure_20200330_includingmutation.txt 1e-10; done
