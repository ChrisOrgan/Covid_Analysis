This full alignment (msa_0601.fasta) is based on 35213 submissions to EpiCoV.
Both duplicate and low-quality sequences (>5% NNNNs) have been removed, using only complete sequences (length >29000 bp). The resulting alignment of 32405 sequences is created using mafft https://doi.org/10.1093/molbev/mst010 with the following command:

mafft --thread -1 --nomemsave  gisaid_cov_sequences.fasta > msa_0601.fasta