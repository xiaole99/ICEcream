#! /bin/bash
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
	/autofs/bal21/xlyin/completegenome/ICEfinder_ICEfamily_final/tools/hmmscan --tblout gbk/${line}.fa2.faa.icefinder.hmmscan.out --cpu 20 /autofs/bal21/xlyin/completegenome/ICEfinder_ICEfamily_final/data/ICE.hmm.db gbk/${line}.fa2.faa
	grep -v "#" gbk/${line}.fa2.faa.icefinder.hmmscan.out|tr -s ' ' '\t' >gbk/${line}.fa2.faa.icefinder.hmmscan.modified.out
	hmmscan --tblout gbk/${line}.fa2.faa.YXL.hmmscan.out --cpu 20 /autofs/bal21/xlyin/completegenome/ICEfinder_ICEfamily_refer/conjugation/YXL_26family.hmm gbk/${line}.fa2.faa
	grep -v "#" gbk/${line}.fa2.faa.YXL.hmmscan.out|tr -s ' ' '\t' >gbk/${line}.fa2.faa.YXL.hmmscan.modified.out
	cat gbk/${line}.fa2.faa.icefinder.hmmscan.modified.out gbk/${line}.fa2.faa.YXL.hmmscan.modified.out >gbk/${line}.fa2.faa.merge.all.hmmscan.out
done >family.log
