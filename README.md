# ICEcream
Integrative and Conjugative Elements Classification and gRaphical gEne Arrangement Method

## How to use
Option 1. Conda 

Installation

mamba create -n ice  -c bioconda -c conda-forge 'python>=3.6' perl-bioperl=1.7.2 prokka biopython aragorn hmmer vmatch blast prodigal pandas 'r-base>=4.2' r-reshape2 dna_features_viewer

Quick start:

download the example folder: 

wget https://figshare.com/ndownloader/files/42457437/example_input.tar.gz

tar xvzf example_input.tar.gz

conda activate ice

ice --input example_input --temp your_temp_folder --output your_outputfolder 


Option 2. download source code

download the github folder to you local server

navigate to the downloaded folder

cd ICEcream/ICEcream

bash ICEcream.sh --input <input_folder> --temp <temp_path> --output <output_path>

## Introduction
To analyze Integrative and Conjugative Elements (ICEs) and Integrative and Mobilizable Elements (IMEs) more efficiently, the ICEcream pipeline was developed to achieve the following goals: 1) to identify ICE and IME loci from genomes via ICEfinder. In this step, ICEs were initially classified into AICEs or T4SS-type ICEs. 2) to classify identified T4SS-type ICEs into one of 26 families by profiling the occurrence and arrangements of conjugation elements. Concurrently, ARGs were annotated by aligning against the SARG v3.0 database 3) to visualize ICEs and ARGs using the python library DNAFeaturesViewer (Fig. 1). 

The performance of the classification function of ICEcream was of high quality, with 19 families being predicted at over 88% precision and over 88% recall 

![ICEcream methodology](https://github.com/xiaole99/ICEcream/blob/main/Figure/methodology.png)
Fig 1. Technical flow of ICEcream


## Copyright
Dr. Xiaole Yin, Prof. Tong Zhang

## Citation
1. Xiaole Yin, ...,  Tong Zhang,
Integrative and conjugative elements shape the diversity and mobility of antibiotic resistance genes. Submitted.
2. Meng Liu, ..., Hong-Yu Ou, 2019.
ICEberg 2.0: an updated database of bacterial integrative and conjugative elements, Nucleic Acids Research, 47 (D1),p.D660–D665 (ICEfinder)
3. Xiaole Yin, ..., Tong Zhang, ARGs-OAP v3.0: Antibiotic resistance gene database curation and analysis pipeline optimization. under review. (antibiotic resistance database)


## Contact
yinlele99@gmail.com
