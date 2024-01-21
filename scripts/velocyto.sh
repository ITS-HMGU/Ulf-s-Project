#!/bin/bash

set -e

module load anaconda/4.8.2
source activate velocyto

# download mask
# https://genome.ucsc.edu/cgi-bin/hgTables?hgsid=611454127_NtvlaW6xBSIRYJEBI0iRDEWisITa&clade=mammal&org=Human&db=0&hgta_group=allTracks&hgta_track=rmsk&hgta_table=rmsk&hgta_regionType=genome&position=&hgta_outputType=gff&hgta_outFileName=GRCh38_rmsk.gtf

velocyto run10x \
  -m /home/fdb589/ulf-citeseq/data/raw/GRCh38_rmsk.gtf \
  --samtools-threads 40 \
  /home/fdb589/ulf-citeseq/data/processed/200910_A00642_0101_AHTJW3DRXX-5000_cells \
  /nfsdata/data/ref/cellranger-GRCh38-2020/genes/genes.gtf | tee -a velocyto.log
