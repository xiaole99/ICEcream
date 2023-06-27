#! /bin/bash
perl ICEfinder_local_yxl3.pl split.result.summary.noplasmid.txt > icefinder.log 
grep 'ERROR' icefinder.log |cut -d '/' -f 3 >icefinder_first_error.txt
wc -l icefinder_first_error.txt
mkdir prokka
mkdir prokka_out
cat icefinder_first_error.txt|while read line; do cp tmp/${line}/${line}.fna prokka; done
ls prokka/|wc -l
cat icefinder_first_error.txt|while read line; do prokka --outdir prokka_out --force --prefix ${line} --cpus 20 prokka/${line}.fna ; done >prokka.log
mv gbk gbk0
mkdir gbk
mv prokka_out/*.gbk gbk
ls gbk >list.gbk.txt
mv result result_1
mkdir result
mv tmp tmp_1
mkdir tmp
perl ICEfinder_local_yxl3.pl list.gbk.txt > icefinder.log.prokka
mv gbk gbk_prokka
mv gbk0 gbk
cat result_1/*/*_summary.txt >>complete.gbk.icefinder.summary.txt
wc -l complete.gbk.icefinder.summary.txt
cat result/*/*_summary.txt >>complete.gbk.icefinder.summary.txt
wc -l complete.gbk.icefinder.summary.txt
