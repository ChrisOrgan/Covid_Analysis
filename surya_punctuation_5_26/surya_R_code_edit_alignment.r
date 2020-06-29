# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(ape)  # v5.3


# Read alignment ----
dna <- read.FASTA(
  file = "msa_trimmed_filtered_masked_clustered_edited_iqtree.fasta"
)

# Edit sequence names ----
dna_edit <- dna
names(dna_edit) <- gsub("/", "_", names(dna_edit))
# names(dna_edit) <- gsub("\", "_", names(dna_edit))
# names(dna_edit) <- gsub(" ", "_", names(dna_edit))
names(dna_edit) <- gsub("\\|", "_", names(dna_edit))

# Write alignment in the FASTA format ----
write.FASTA(
  dna_edit,
  file = "msa_trimmed_filtered_masked_clustered_edited_iqtree_v2.fasta"
)

# Write sequence names ----
seq_names <- data.frame(names(dna), names(dna_edit))
write.table(
  seq_names,
  file = "surya_R_output_sequence_names.txt",
  quote = FALSE,
  sep = "\t",
  row.names = FALSE,
  col.names = FALSE
)
