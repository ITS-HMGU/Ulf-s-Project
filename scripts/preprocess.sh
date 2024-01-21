#!/bin/bash

set -e

module load bcl2fastq2/2.20 cellranger/3.1.0 fastqc/0.11.9
cd /home/fdb589/ulf-citeseq/data/processed

# Create fastq files
cellranger mkfastq --run=/home/fdb589/ulf-citeseq/data/raw/novaseq1/200910_A00642_0101_AHTJW3DRXX/ \
        --id=200910_A00642_0101_AHTJW3DRXX \
        --csv=/home/fdb589/ulf-citeseq/data/sample-sheet.csv \
        --localcores=40

# FASTQC
mkdir fastq
fastqc /home/fdb589/ulf-citeseq/data/processed/200910_A00642_0101_AHTJW3DRXX/outs/fastq_path/HTJW3DRXX/ulf/*.fastq.gz \
        --threads 70 \
        --outdir fastq

# Gene counts
cellranger count --id=200910_A00642_0101_AHTJW3DRXX-5000_cells \
        --fastqs=/home/fdb589/ulf-citeseq/data/processed/200910_A00642_0101_AHTJW3DRXX/outs/fastq_path/HTJW3DRXX/ulf_cdna/ \
        --transcriptome=/nfsdata/data/ref/cellranger-GRCh38-2020/ \
        --localcores=40 \
        --expect-cells=5000

# Concat fastq files
cd /home/fdb589/ulf-citeseq/data/processed/200910_A00642_0101_AHTJW3DRXX/outs/fastq_path/HTJW3DRXX
cat ulf_hto_S5_L00*_R1_001.fastq.gz > ulf_hto_R1.fastq.gz
cat ulf_hto_S5_L00*_R2_001.fastq.gz > ulf_hto_R2.fastq.gz

# cite-seq count
module load anaconda/4.8.2
source activate CITE-seq-Count-1.4.3

# whitelist
# stay in the path: https://github.com/Hoohm/CITE-seq-Count/issues/134
cd /home/fdb589/ulf-citeseq/data/processed/200910_A00642_0101_AHTJW3DRXX/outs/fastq_path/HTJW3DRXX
CITE-seq-Count -R1 ulf_hto_R1.fastq.gz -R2 ulf_hto_R2.fastq.gz \
        -t /home/fdb589/ulf-citeseq/data/tag-list.csv -cbf 1 -cbl 16 -umif 17 -umil 28 -cells 5000 -T 40 \
        -wl /home/fdb589/ulf-citeseq/data/whitelist.txt -o citeseq-count
mv citeseq-count /home/fdb589/ulf-citeseq/data/processed/
