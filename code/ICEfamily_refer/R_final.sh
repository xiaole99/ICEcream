#! /bin/bash
echo ${1}
cd ${1}
cat split.result.summary.noplasmid.txt |while read line
do
	Rscript /autofs/bal21/xlyin/completegenome/ICEfinder_ICEfamily_refer/familytools/merge.version6.R gbk/${line}.fa2.faa.merge.all.hmmscan.out 1e-5 complete.gbk.icefinder.summary.txt
done >R.log
cat list.arg.out.list.txt|while read line
do
Rscript /autofs/bal21/xlyin/completegenome/ICEfinder_ICEfamily_refer/familytools/blastx_out_treatment_linux_20200828_3.R ${line} 70 80 /autofs/bal21/xlyin/completegenome/ICEfinder_ICEfamily_refer/familytools/structure_20200330_includingmutation.txt 1e-10
done
cd ..
