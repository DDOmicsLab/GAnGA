#!/bin/bash

mkdir -p short_reads
cd short_reads

mkdir -p B_longum
cd B_longum
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR132/017/SRR13205517/SRR13205517_2.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR132/017/SRR13205517/SRR13205517_1.fastq.gz
cd ..

mkdir -p E_coli
cd E_coli
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR177/003/SRR1770413/SRR1770413_2.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR177/003/SRR1770413/SRR1770413_1.fastq.gz
cd ..

mkdir -p K_pneumonaie
cd K_pneumoniae
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR404/007/SRR4046827/SRR4046827_2.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR404/007/SRR4046827/SRR4046827_1.fastq.gz

cd ../../


mkdir -p long_reads
cd long_reads

mkdir -p B_longum
cd B_longum
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR246/078/SRR24651278/SRR24651278_1.fastq.gz
cd ..

mkdir -p E_coli
cd E_coli
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR333/043/SRR33397843/SRR33397843_1.fastq.gz
cd ../

mkdir -p K_pneumoniae
cd K_pneumoniae     
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR333/035/SRR33323135/SRR33323135_1.fastq.gz

cd ../../
