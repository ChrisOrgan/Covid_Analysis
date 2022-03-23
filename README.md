# Coronavirus Evolution

This repository contains data and other files for "Detecting Punctuated 
Evolution in SARS-CoV-2 over the First Year of the Pandemic".

## Contents

- surya_etal_plos_one_data_s1_sars_cov_2
    - Dataset 1 (2020-05-26)
        - Tree
        - 3D scatter plot
        - Node-density artifact test
        - Regressions
            - root-to-tip divergence ~ 1
            - root-to-tip divergence ~ sampling time
            - root-to-tip divergence ~ sampling time + node count
            - root-to-tip divergence ~ sampling time + node count
              (Pagel's lambda estimated)
            - root-to-tip divergence ~ sampling time + node count
              (subsampling x1000 1000 genomes)
            - root-to-tip divergence ~ sampling time + node count
              (subsampling by clade x1000 100-1000 genomes)
            - root-to-tip divergence ~ sampling time + node count + continent
            - root-to-tip divergence ~ sampling time + node count x continent
            - root-to-tip divergence ~ sampling time x node count
        - Variance inflation factors
        - Regression diagnostics
    - Dataset 2 (2020-12-09; pre-vaccination)
        - Lanfear's tree (subsampling x1 15,000 genomes)
        - 3D scatter plot
        - Node-density artifact test
        - Regressions
            - root-to-tip divergence ~ 1
            - root-to-tip divergence ~ sampling time
            - root-to-tip divergence ~ sampling time + node count
            - root-to-tip divergence ~ sampling time + node count
              (subsampling x100 5000 genomes)
            - root-to-tip divergence ~ sampling time + node count
              (subsampling x10 10,000 genomes)
            - root-to-tip divergence ~ sampling time + node count + continent
            - root-to-tip divergence ~ sampling time + node count x continent
            - root-to-tip divergence ~ sampling time x node count
        - Variance inflation factors
        - Regression diagnostics
    - Dataset 3 (2021-03-02; vaccination in progress)
        - Lanfear's tree (subsampling x1 15,000 genomes)
        - 3D scatter plot
        - Node-density artifact test
        - Regressions
            - root-to-tip divergence ~ 1
            - root-to-tip divergence ~ sampling time
            - root-to-tip divergence ~ sampling time + node count
            - root-to-tip divergence ~ sampling time + node count
              (subsampling x100 5000 genomes)
            - root-to-tip divergence ~ sampling time + B.1.1.7
            - root-to-tip divergence ~ sampling time + B.1.1.7 + node count
            - root-to-tip divergence ~ sampling time + B.1.1.7 * node count
            - root-to-tip divergence ~ sampling time * B.1.1.7
            - root-to-tip divergence ~ sampling time * B.1.1.7 + node count
            - root-to-tip divergence ~ sampling time * B.1.1.7 * node count
              (no interaction between time and node)
        - Variance inflation factors
        - Regression diagnostics
- surya_etal_plos_one_data_s2_sarbecovirus
    - Boni et al.'s (2020) edited alignment
    - Tree
    - 3D scatter plot
    - Node-density artifact test
    - Regressions
        - root-to-tip divergence ~ 1
        - root-to-tip divergence ~ sampling time
        - root-to-tip divergence ~ sampling time + node count
        - root-to-tip divergence ~ sampling time x node count
    - Regressions without outliers
        - root-to-tip divergence ~ 1
        - root-to-tip divergence ~ sampling time
        - root-to-tip divergence ~ sampling time + node count
        - root-to-tip divergence ~ sampling time x node count
    - Variance inflation factors
    - Regression diagnostics
- surya_etal_plos_one_data_s3_sars_cov_1
    - Boni et al.'s (2020) edited alignment
    - Tree
    - 3D scatter plot
    - Node-density artifact test
    - Regressions
        - root-to-tip divergence ~ 1
        - root-to-tip divergence ~ sampling time
        - root-to-tip divergence ~ sampling time + node count
        - root-to-tip divergence ~ sampling time x node count
    - Regressions without outliers
        - root-to-tip divergence ~ 1
        - root-to-tip divergence ~ sampling time
        - root-to-tip divergence ~ sampling time + node count
        - root-to-tip divergence ~ sampling time x node count
    - Variance inflation factors
    - Regression diagnostics
