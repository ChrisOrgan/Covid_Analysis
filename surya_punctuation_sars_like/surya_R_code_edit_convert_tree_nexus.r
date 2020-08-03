# Written by Kevin Surya, 2020.
# This code is part of the coronavirus-macroevolution project.


library(phytools)  # v0.7.20


# Read tree ----
tree <- read.newick(file = "nextstrain_groups_blab_sars-like-cov_tree_v2.nwk")

# Enclose tip labels in single quotation marks ----
tree$tip.label <- gsub("'", "", tree$tip.label)
tree$tip.label <- sQuote(tree$tip.label)

# Remove all human SARS-CoV-1 and SARS-CoV-2 genomes except for two 
#   representatives: Tor2 (Marra et al. 2003) and Wuhan-Hu-1 (Wu et al. 2020)
out <- sQuote(c("TW3", "TW1", "CUHK_AG03", "TW8", "TW7", "GDH_BJH01",
                "GZ0401", "GZ0402", "PC4_136", "Sweden/01/2020",
                "Nepal/61/2020", "Wuhan/WIV05/2019", "Wuhan/IVDC-HB-04/2020",
                "Wuhan/WIV04/2019", "Wuhan/IVDC-HB-01/2019",
                "Japan/KY-V-029/2020", "Wuhan/IPBCAMS-WH-01/2019",
                "USA/IL1/2020", "USA/AZ1/2020", "USA/TX1/2020"))
tree_edit <- drop.tip(phy = tree, tip = out)
## tree_edit
## 
## Phylogenetic tree with 32 tips and 31 internal nodes.
## 
## Tip labels:
##         'bat_SL_CoVZXC21', 'bat_SL_CoVZC45', 'pangolin/Guangxi/P1E/2017', 'pangolin/Guangxi/P5L/2017', 'pangolin/Guangxi/P4L/2017', 'pangolin/Guangxi/P5E/2017', ...
## 
## Rooted; includes branch lengths.

# Write tree in the NEXUS format ----
writeNexus(
  tree = tree_edit,
  file = "nextstrain_groups_blab_sars-like-cov_tree_v3.nex"
)
