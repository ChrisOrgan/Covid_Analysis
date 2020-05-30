<img src="https://raw.githubusercontent.com/suryakevin/suryakevin.github.io/master/izanami.svg" width=20% height=20%>

# Readme

## Coronavirus Macroevolution

- [x] SARS-CoV-2: Punctuation (4/16)
- [x] SARS-CoV-2: Punctuation (5/06; equitable global subsampling)
- [x] SARS-CoV-2: Punctuation (4/30; non-subsampled)
- [ ] SARS-Cov-2: Speciation ~ time + continent
- [ ] SARS-CoV-2: Geographic radiation
- [ ] SARS-CoV-2: Dispersal ~ mutation rate
- [x] SARS-like CoV: Punctuation

### The Mode of SARS-CoV-2 Evolution

- **Publication notes**
    - **Action list**
        - To indirectly check how differences in genome quality impact our 
          results, we will bootstrap the `Nextstrain` tree and re-do the 
          analyses without the three outliers with long terminal branch lengths.
            - To further screen for outliers, we will scan the multiple 
              sequence alignment.
        - We decided to re-do our regression analyses using a non-subsampled 
          SARS-CoV-2 tree, built from high-quality genomes.
            - One weakness of the analyses with the subsampled tree is that we 
              could miss areas of variation that we don't find in the 
              subsampled tree.
            - We expect the result from the re-analyses to match our previous 
              one. If not, then we have to figure out why, but the above 
              paragraph is one of the most likely explanations.
            - *Tanner's phylogenetic inference workflow*
                - Remove bat and pangolin sequences.
                - Remove sequences with coverage that is less than 29,400 base 
                  pairs (bps).
                - Remove sequences without an associated sampling date.
                - Align sequences using `MAFFT` v7.429 (`--auto`; Katoh and 
                  Standley 2013).
                - Mask positions identified by De Maio et al. (2020) using 
                  their VCF file.
                - Build tree in `IQ-TREE` (`-st DNA -m HKY -G`; Minh et al. 
                  2020) using the HKY substitution model and the gamma model of 
                  rate heterogeneity (four categories).
                    - Root the tree to the Wuhan-Hu-1 genome.
                    - We know that some positions in the genome are quite 
                      conserved, while others seem to be diverse. We need to 
                      model this rate heterogeneity to get better estimates of 
                      the molecular branch lengths.
                    - Plus, failure to capture the rate heterogeneity may 
                      result in a tree that suffers from the node-density 
                      artifact.
                - In a second pipeline, filter out identical sequences with 
                  `CD-HIT` (Fu et al. 2012).
                    - It is common to have identical or duplicate viral 
                      sequences because of clonal replication.
                    - We want to investigate the effect of having duplicate 
                      data.
                - And then, build a second tree with the same `IQ-TREE` 
                  settings.
                - Tanner base these workflow steps on De Maio et al. (2020).
    - **Central view**
        - We should state the central view of our project explicitly (as a 
          question upfront and an answer at the end), that transmission does 
          nothing to coronavirus evolution.
            - Mark Pagel also brings up the assumption of other things equal 
              but also says that this limitation should not daunt us.
    - **Conclusion**
        - We need to state our conclusions with more nuance.
            - How can we predict SARS-CoV-2 evolution once drugs and vaccines 
              are rolled out? Perhaps, we should read Gandon et al. (2001).
    - **Expectation**
        - Mark Pagel suggests that the Red-Queen-like evolution may be better 
          thought of as 'stabilizing selection' — i.e., viruses that transmit 
          the most have the lowest rates of evolution. He further states that 
          even though we find no evidence for this mode of evolution, it goes 
          with our theme that the coronavirus is evolving gradually.
        - When describing the gradualism, we should showcase how the rate of 
          evolution under this scenario is uniform across the tree.
     - **Discussion**
        - Why isn't there more variability in the rate of SARS-CoV-2 genomic 
          evolution?
            - We found gradualism either because we are looking at a 
              genome-wide mode of evolution, or because there is a push of 
              constant selection from immense population size.
     - **Methods**
        - Mention the *R<sup>2</sup>* of the regression model that we used for 
          the phylogenetic predictions.
        - We need to acknowledge that most of the genomes at GISAID come from 
          symptomatic patients.
            - Tanner will provide a reference.
    - **Significance**
        - Based on Charles Chapus's comment, our study should also benefit 
          researchers who are trying to trace infectious events.
    - **Cover letter**
        - Viral phylodynamics is the study of how epidemiological, 
          immunological, and evolutionary processes shape viral phylogenies 
          (Volz et al. 2013). This field has focused on how transmission 
          dynamics impact viral genetic variation.
            - Our study is of importance to the phylodynamics community.
    - **Interpretation**
        - Pennell et al. (2014) argue that the correlation between the total 
          path length and node count can alternatively be interpreted as 
          evidence that genetic divergence promotes speciation. It is possible 
          that the more mutations a viral lineage accumulates, the more 
          transmissible it becomes.
            - Mark Pagel also brings up the alternative interpretation above, 
              that coronaviruses with different rates of evolution have 
              different transmission probabilities.
            - These comments focus on the fact that regression does not test 
              for the direction of causality.
            - *Reply:* We base the regression approach on a reasonable set of a 
              priori expectations, and that such test tells us if the evidence 
              is consistent with our alternative hypotheses.
                - Note that reviewers may use Pennell et al.'s (2014) criticism 
                  as a reason to invalidate our approach and reject our paper.
            - *Reply:* We find the mode of SARS-CoV-2 and SARS-like 
              betacoronavirus evolution to be gradual, not punctuated or, 
              Red Queen-like. Therefore, we can rule out all possible 
              interpretations that come with regressions that show positive or 
              negative slopes.
        - Pennell et al. (2014) also suggest yet another alternative where 
          divergence and speciation are linked through a third confounding 
          variable such as shorter generation times, higher fecundity, and or 
          increased genetic variation.
            - *Reply:* Venditti and Pagel (2014) note that the correlation 
              between divergence and speciation can hold even when controlling 
              for background differences among species, such as generation 
              times or adaptive radiation of some lineages, that might affect 
              rates of evolution independently of a punctuational effect.
            - *Reply:* We can rule out all possible interpretations that come 
              with positive or negative slopes.
        - Rabosky (2012) found that the punctuated model can be supported even 
          when the mode of evolution is gradual so long as rates of speciation 
          and evolution covary.
            - *Reply:* Mark Pagel and we interpret the punctuation regression 
              model differently than what Rabosky (2012) portrays: Punctuated 
              equilibrium does not equal punctuated trait evolution.
            - *Reply:* We can rule out all possible interpretations that come 
              with positive or negative slopes.
        - Lastly, Pennell et al. (2014) point out that we can also interpret 
          the correlation as evidence that higher evolvability decreases 
          extinction risk.
            - *Reply:* We can rule out all possible interpretations that come 
              with positive or negative slopes.
        - Is punctuated SARS-CoV-2 genomic evolution a signature of positive 
          selection associated with transmissions into new hosts (Pybus and 
          Rambaut 2009)? Or is it the strong effect of the genetic drift 
          because of a founder effect (Mayr 1954)?
            - Regardless of which interpretation is correct, we didn't find 
              evidence for both.
    - **Background**
        - Read https://nextstrain.org/narratives/ncov/sit-rep/2020-05-15?n=5 
          regarding the SARS-CoV-2 evolutionary rate.
            - Bell et al. found that the evolutionary rate of SARS-CoV-2 is 
              typical for a coronavirus.
- ***We have not updated the part below since 5/10/2020.***
- Here, we investigate the mode of SARS-CoV-2 genomic evolution and compare it 
  to its tempo.
    - The mutation rate of SARS-CoV-2 has so far been slower than that of 
      SARS-CoV (Jia et al. 2020), the seasonal flu (see Rambaut's statement in 
      Kupferschmidt 2020), and RNA viruses generally (Corum and Zimmer 2020).
        - SARS-CoV-2, unexpected for a relatively large RNA virus, possesses 
          proofreader proteins.
    - Once they jumped into and spread among humans, has SARS-CoV-2 been 
      evolving in a punctuational manner, so that a large proportion of their 
      genomic divergences occurred during transmission events?
        - Mutation rates may elevate at net transmission events as the viruses 
          infect new hosts.
    - The null hypothesis is that they have been evolving gradually.
    - To test for punctuated evolution (see Webster et al. 2003; Pagel et al. 
      2006), we use phylogenetic generalized least squares (PGLS) to regress 
      the total phylogenetic path lengths of the genomes (distances from the 
      root of a phylogenetic tree to the tips) on the net number of 
      transmissions (nodes in a tree).
    - We expect the net number of transmissions along SARS-CoV-2 lineages to 
      correlate with (slope > 0) and explain the variation in accumulated 
      mutations (*R<sup>2</sup>* > 0), controlling for shared ancestry.
    - First, we download a molecular tree of SARS-CoV-2 (*n* = 3,958 genomes) 
      from `Nextstrain` (Sagulenko et al. 2017; Hadfield et al. 2018; 
      https://nextstrain.org/ncov).
        - Downloaded on: 4/16/2020, 8:33:41 AM
        - The genomes come from various authors and labs, deposited at `GISAID` 
          (Shu and McCauley 2017; https://www.gisaid.org/).
        - Bioinformatic notes (see https://github.com/nextstrain/ncov):
            - Site numbering and genome structure use Wuhan-Hu-1/2019 (GenBank 
              Accession number: MN908947; Wu et al. 2020) as the reference.
            - The phylogeny is rooted relative to early samples from Wuhan.
            - There were single nucleotide polymorphisms (SNPs) present in the 
              nCoV samples in the first and last few bases of the alignment 
              that were masked as likely sequencing artifacts.
                - Insertions, deletions, and differences at the ends of the 
                  genome are more likely to be errors (https://nextstrain.org/narratives/ncov/sit-rep/2020-03-05?n=5).
            - How does the `Nextstrain` team model the rate of molecular 
              evolution (e.g., substitution model, across-site rate variation, 
              clock model, and heterotachy)?
                - Start reading https://github.com/nextstrain/ncov/blob/master/docs/running.md 
                  and https://github.com/nextstrain/ncov/blob/master/docs/workflow_structure.md
            - The branch lengths are in the unit of the expected number of 
              substitutions per site.
        - Read about the metadata at https://github.com/nextstrain/ncov/blob/master/docs/metadata.md
    - The way the `Nextstrain` tree encodes nodes comprising tips with zero 
      terminal branch lengths inflates the number of nodes in the tree.
        - The tree has an additional node for each of the 161 genomes sampled 
          from patients exposed in a location different from the sampling one.
        - First, using `FigTree` 1.4.4 (Rambaut 2017), we save the tree in a 
          Newick format with the tip labels enclosed within single quotes, and 
          without the problematic node labels.
        - Second, we use the `R` 3.6.2 (R Core Team 2019) package `phytools` 
          0.7-20 (Revell 2012) to convert the Newick tree into a NEXUS format.
            - The problem is most practically solved in the NEXUS format.
        - Third, using regex in `Notepad++` 7.5.8, we fix the encodings.
            - Example:
                - Problematic: `(1000:0,(1001:0):5);`
                - Correct: `(1000:0,1001:5);`
                - Regex (search): `\(([0-9][0-9][0-9][0-9]):0\)`
                    - The backslashes escape the parentheses in front of them.
                    - The unescaped parentheses set the digits they enclose as 
                      a single group.
            - Regex (replace): `\1`
                - The replacement is the group designated above.
    - We check the tree using `ape` 5.3 (Paradis and Schliep 2019).
        - The tree is rooted despite the `R` output.
    - Using `ape`, we extract the total path lengths (diagonals of the 
      variance-covariance matrix) and the number of internal nodes along the 
      paths.
    - Using the maximum likelihood (ML) algorithm in `BayesTraits` 3.0.1 (Pagel 
      1999; http://www.evolution.rdg.ac.uk/BayesTraitsV3.0.1/BayesTraitsV3.0.1.html), 
      we estimate the parameters of the regression model above.
        - PGLS accounts for the shared inheritance of branch lengths.
        - Our PGLS model assumes that the tree is correct.
        - To check phylogenetic signal, we run two analyses, one with Pagel's 
          *λ* (Pagel 1999) set to one, and another to near-zero (1 x 10^-6^).
            - We expect *λ* = 1 because the data come from the tree itself.
        - We use default ML search settings.
        - We execute two ML runs for each model and compare the results 
          (total: four runs).
    - We evaluate the significance of the slope parameter using a 
      likelihood-ratio (LR) test against an intercept-only model.
        - LR = 2 x [lnLh(better fitting model) – lnLh(worse fitting model)]
        - LR > 2 represents positive evidence (Raftery 1995).
    - We further assess significance using *P* values.
        - We calculate the *t* value (absolute slope / standard error), and the 
          proportion of the null *t* distribution (df = 3,957 [*n* - 1]) 
          greater than the observed *t*.
    - We repeat the analyses above using the `R` packages `ape` and `nlme` 
      3.1-147 (Pinheiro et al. 2019), which employ a restricted maximum 
      likelihood (REML) algorithm.
    - We also run a sensitivity analysis using a tree scaled to the unit of 
      mutations/year (i.e., rate tree).
        - The question shifts to: How does the speed of SARS-CoV-2 mutations 
          change through time?
        - We acquire and edit the `Nextstrain` timetree the same way as with 
          the molecular tree.
            - Genomes with unknown sampling dates were filtered out.
            - Temporal resolution assumes a nucleotide substitution rate of 
              8 × 10^-4^ substitutions per site per year 
              (https://github.com/nextstrain/ncov; http://virological.org/t/phylodynamic-analysis-176-genomes-6-mar-2020/356).
            - The branch lengths are in years.
            - We set negative branch lengths to zero.
        - Using `ape` and `phytools`, we then create a rate tree with branch 
          lengths in mutations/year (molecular branch length / time branch 
          length).
            - To avoid division by zero, we set zero time branch lengths to an 
              arbitrarily small value (1 x 10^-6^).
                - Regardless of the value we choose, the rate on the branches 
                  above will be underestimated.
            - We then assess the distribution of rates in `R` and `FigTree`.
                - Two internal branches are outliers.
                    - One leads to a clade comprising two genomes from Iceland 
                      and England.
                    - Another leads to a clade containing one Wales and four 
                      Scotland genomes.
                - Such extremely high rates likely resulted from undersampling.
            - With `ape`, we remove the two branches and their descendants from 
              the rate tree (final *n* = 3,951 genomes).
    - There is very little evidence to suggest that SARS-CoV-2 genomes evolved 
      in a punctuated manner (slope = -0.063 ± 0.0038, *P* < 0.0001; 
      *R<sup>2</sup>* = 0.064; LR [vs. an intercept-only model] = 263.79).
        - The ML replicates produce practically identical results.
        - `R` results: slope = -0.20 ± 0.0060, *P* < 0.0001; 
          *R<sup>2</sup>* = -0.186; LR [vs. an intercept-only model] = 974.76.
            - The conclusion is the same.
            - The *R<sup>2</sup>* of a model is negative if the fit is worse 
              than that of an intercept-only model.
        - Rate tree results: slope = 4.55 ± 0.70, *P* < 0.0001; 
          *R<sup>2</sup>* = 0.011; LR [vs. an intercept-only model] = 42.18).
            - Note that the *R<sup>2</sup>* is low.
            - For every additional net transmission event, the cumulative 
              mutation rate increases by only four units; the slope is 
              relatively shallow.
    - We check whether an artifact of phylogeny reconstruction, the 
      node-density effect (Webster et al. 2003; Venditti et al. 2006), biases 
      our punctuation tests.
        - The node-density effect is the underestimation of branch lengths in 
          tree regions with fewer taxa.
        - We executed the *δ* test, which tests for a curvilinear relationship 
          between the number of nodes (*n*) and path length (*x*).
            - Equation: *n* = *β* *x<sup>δ</sup>*
                - *β:* rate of change between the number of nodes and path 
                       length
            - We expect *δ* > 1 when the node-density effect is present.
        - We use `R` packages `ape` and `nlme` to estimate *δ* by fitting a 
          PGLS log-log regression.
            - We fix Pagel's *λ* to one.
        - Since the number of nodes is a count data, it should have been more 
          appropriate to use a generalized linear mixed model (GLMM) like a 
          phylogenetic Poisson regression.
            - Log-transforming Poisson data introduces bias (O'Hara and Kotze 
              2010).
        - But, Venditti et al. (2006) state that the regression equation with 
          node count as the response tends to be more accurate than the one 
          with path length.
    - The *δ* test suggests that the node-density effect is absent
      (*δ* = -0.046).
        - The rate tree is also free of this artifact (*δ* = -0.017).
    - We create scatterplots with the curvilinear fit lines using `Cairo` 
      1.5-12 (Urbanek and Horner 2019), `ggplot2` 3.3.0 (Wickham 2009), 
      `ggthemes` 4.2.0 (Arnold 2019), and `svglite` 1.2.3 (Wickham et al. 2019).
    - We create and save scatter plots of the punctuation regressions using the 
      `R` packages `Cairo`, `ggplot2`, `ggthemes`, `htmlwidgets` 1.5.1 
      (Vaidyanathan et al. 2019), `plotly` 4.9.2.1 (Sievert 2018), and 
      `svglite`.
        - We do not observe any influential outliers.
    - We run regression diagnostics by plotting the residuals against fitted 
      values, and histograms of the residuals using the packages `ggExtra` 0.9 
      (Attali and Baker 2019), `ggplot2`, `ggthemes`, and `svglite`.
        - The residuals vs. fitted values plot indicates a violation of the 
          residual homogeneity of variance.
            - The plot shows funneling, but we expect this pattern given that 
              SARS-CoV-2 diversifies around the Earth from only one origin 
              (Wuhan).
            - The violation is more severe for the rate tree analysis.
        - The histogram shows that the residual distribution is somewhat 
          right-skewed.
            - The skew seems more severe for the rate tree analysis.
    - We bolster our assessment of normality with the Shapiro-Wilk test 
      (Shapiro and Wilk 1965).
        - The test suggests that two residual distributions above are 
          non-normal (*P* < 0.0001).
    - We plot trees using `Cairo`, `ggimage` 0.2.8 (Yu 2020), `ggtree` 1.14.6 
      (Yu et al. 2017; 2020), `phytools`, and `svglite`.
    - At this stage, we find that SARS-CoV-2 genomes are most likely evolving 
      gradually (slope ≈ 0), with much of the mutations occurring in between 
      net transmission events, as depicted in the tree.
        - The tempo and mode of SARS-CoV-2 evolution may be linked.
        - We will not be expecting jumps in the accumulation of mutations and 
          that drugs and vaccines (e.g., Amanat and Kramer 2020; Gao et al. 
          2020; Jin et al. 2020; Le et al. 2020; Lei et al. 2020; Sheahan et 
          al. 2020; Wang et al. 2020c; Yin et al. 2020) under development will 
          still work in the future.
            - Mutations in viruses can be deleterious (e.g., Muth et al. 2018).
    - We check for Simpson's paradox (Blyth 1972), whether only parts of the 
      tree exhibit evidence of punctuation.
        - We fit a regression model where we allow different fit lines for 
          different continents (Africa, Asia, Europe, North America, Oceania, 
          and South America).
            - Geographic distribution:
                - Africa: 81 (2.04%)
                - Asia: 559 (14.12%)
                - Europe: 2,041 (51.57%)
                - North America: 1,024 (25.87%)
                - Oceania: 210 (5.31%)
                - South America: 43 (1.09%)
            - To obtain the standard errors for the intercept and slope of all 
              lines, we fit the model five more times, each with a different 
              reference.
        - We compare the separate-slopes model above with the single-slope and 
          equal-slopes ones using the Bayesian Information Criterion (BIC; 
          Schwarz 1978) and select the one with the lowest BIC value.
            - BIC = ln(*n*)*k* - 2ln(*Lh*)
                - *n:* the number of taxa (sample size)
                - *k:* the number of parameters estimated by the model
                - *Lh:* the maximized value of the likelihood function
            - ΔBIC = BIC of a model - BIC of the model with the lowest value
                - A ΔBIC lower than two is barely worth mentioning; between two 
                  and five represents positive evidence for the model with the 
                  lowest value; between five and ten a strong one; and a 
                  convincing one for a ΔBIC greater than ten (Raftery 1995).
        - The separate-slopes model (*R<sup>2</sup>* = 0.81) is more likely 
          than the single-slope (ΔBIC = 6,161.6) and the equal-slopes ones 
          (ΔBIC = 3,847.75).
        - There is indeed evidence for Simpson's paradox, with three lines 
          having positive slopes (Africa, Asia, and North America), and the 
          other three negative (Europe, Oceania, and South America).
            - All *P* values are less than 0.01.
            - The lines seem off because they are phylogenetically-corrected.
            - Note that all continents have multiple introductions.
            - The sample size for three continents (Africa, Oceania, and South 
              America) is relatively small.
            - In all cases, the residuals are relatively large.
            - While the residuals vs. fitted values plot does not indicate 
              heteroscedasticity, it does show a positive relationship.
                - Within each continent, data points with low and high number 
                  of nodes have high residuals.
                - In other words, each line is predicting the tails of the 
                  distribution poorly.
                - The fitted values for almost all South American genomes are 
                  highly negative, and thereby nonsensical.
                    - If the analyses with the newer tree still prove 
                      predicting South American genomes to be difficult, we 
                      will drop them and re-fit the model.
            - As before, the residual distribution is non-normal (Shapiro-Wilk 
              *P* < 0.0001).
        - We interpret the separate-slope regression results with care.
    - No published studies have interpreted negative slopes in a punctuation 
      regression test.
        - Here are some thoughts to help interpret negative slopes:
            - A negative-slope scenario is Red Queen-like (Van Valen 1973; 
              Stenseth and Smith 1984; Liow et al. 2011) in that the amount of 
              evolution follows biotic interactions within hosts more than 
              transmission events (abiotic changes).
            - Viral transmission is allopatric.
            - Sampled viruses could either be in the middle of a coevolutionary 
              arms race with the host's immune system or at the end (i.e., 
              winning, and so ended up killing the host).
            - But, COVID-19 symptoms do not develop immediately.
                - The median incubation period is 5.1 days; 97.5% will develop 
                  symptoms within 11.5 days (Lauer et al. 2020).
            - The viruses may be able to linger and replicate easily before 
              being barraged by immune reactions.
            - We may not need to invoke acceleration along longer branches.
            - There may simply be a threshold separating a stage of low and 
              high, constant evolution.
            - Viruses that reside within a host have to experience the Red 
              Queen game.
            - Whereas lineages that frequently jump may have a lower chance of 
              being engaged in the game, and so have evolved less.
    - The results above hint that the mode of SARS-CoV-2 evolution differs 
      between continents, which is either punctuated or Red Queen-like.
        - The reasons behind this difference may be attributable to sampling 
          bias, transmission prevention efforts, and epidemiological parameters 
          such as population size and density.
        - In a large population, selection acting on both humans and viruses 
          tend to be stronger than drift.
        - When selection is high, we expect the rate of evolution to increase 
          as viruses jump into new hosts, hence the evidence for punctuated 
          evolution.
            - We use Kendall's rank correlation (Kendall 1938) to test whether 
              the slope estimates from the separate-slopes model positively 
              correlate with continent population sizes.
                - This nonparametric test only requires the independence 
                  assumption.
                - We collect 2020 population size estimates from the 
                  United Nations World Population Prospects
                  (https://population.un.org/wpp/Download/Standard/Population/).
                    - Following `Nextstrain` designation, we treat Central 
                      America and the Caribbean as part of North America.
                    - So, we subtract 43,532,374 Caribbean people and 
                      179,670,186 Central Americans from South America and add 
                      them to North America.
                - We use an additional `R` package, `ggrepel` 0.8.2 (Slowinski 
                  2020), when creating the scatter plot.
            - There is little evidence for a positive relationship, but this 
              result may be because of the small sample size (*τ* = 0.47; 
              *P* = 0.1361).
            - The plot shows somewhat of a positive relationship, with South 
              America likely being an outlier.
            - We further incorporate population size in the separate-slopes 
              regression model.
                - We double the ML tries to 20 because of a slight instability 
                  in log-likelihood estimates.
            - The model is less likely than the separate-slopes model 
              (ΔBIC = 1,232.31).
                - The standard errors for the intercept-related terms are 
                  heavily-inflated.
                    - Population size and the continent dummy variables are 
                      redundant.
            - We also try fitting models comprising of the number of nodes and 
              population size as the only predictors, with and without an 
              interaction term.
            - These models are less likely than the separate-slopes model, 
              despite having eight fewer parameters 
              (ΔBIC [without interaction] = 4,786.87; 
              ΔBIC [with interaction] = 3,300.63).
                - Still, these models are more likely than the single-slope one 
                  (ΔBIC [without interaction] = 1,374.73; 
                  ΔBIC [with interaction] = 2,860.97).
                - The strength of this model is that it directly assesses 
                  whether the mode of evolution varies with population size at 
                  the continent level.
                - The lines in the plot make more sense than before, with the 
                  separate-slopes model.
                    - We calculate the slope for each continent using the 
                      equation (*m* = [*y<sub>2</sub>* - *y<sub>1</sub>*] / 
                      [*x<sub>2</sub>* - *x<sub>1</sub>*]).
                - There is a perfect positive concordance (*τ* = 15 [out of 15 
                  possible pairings], *P* = 0.001389) between the slope and 
                  population size, matching our expectations.
                - The regression diagnostics show less of assumption violations 
                  than the separate-slopes model.
                    - The residuals vs. fitted values plot still shows a 
                      funneling pattern (i.e., heteroscedasticity), especially 
                      with the Asian genomes.
                        - There is still a positive relationship.
                        - The residuals for the Asian genomes are higher 
                          relative to those from other continents.
                        - Some of the Asian fitted values are also 
                          unrealistically negative.
                        - The mode of SARS-CoV-2 evolution in Asia might have 
                          changed over time.
                    - The residuals are more normally-distributed than that of 
                      the separate-slopes model, but not enough 
                      (Shapiro-Wilk *P* < 0.0001).
            - Another potential factor is the speed of transmission, which may 
              or may not correlate with the population size.
                - Start reading Salje et al. (2017).
                - Population size is a factor when calculating the rate of 
                  transmission, and perhaps, positively associated with 
                  virulence (Galvani 2003).
                    - Virulence is the extent of parasite-induced reduction in 
                      host fitness (fertility and, particularly, mortality).
    - Despite having a higher BIC score than the separate-slopes model, the 
      model with an interaction between the number of nodes and population size 
      is easily interpretable and more reliable based on regression diagnostics.
    - Here is our synthesis at this stage.
        - The mode of SARS-CoV-2 evolution seems to depend on the human 
          population size.
        - In smaller populations, viral lineages that stay within the same 
          human host for a prolonged period tend to have evolved more than 
          those that frequently diversify.
        - This pattern is reminiscent of the Red Queen.
        - Evolution follows biotic interactions (coevolutionary arms race 
          within the human body) more than abiotic changes (host changes or 
          transmission events).
        - At the intermediate population size level, the mode of mutation can 
          be gradual.
        - The number of accumulated mutations does not match the number of net 
          transmission events.
        - And in the largest population, which happens to be in the continent 
          where SARS-CoV-2 originated, we see evidence of punctuated evolution.
        - Mutation rates tend to jump during transmission events.
        - Perhaps, as the host population size increases, selection becomes 
          stronger than drift.
        - Viruses that move into a new host (i.e., a new environment) may 
          experience more intense selective pressure.
    - Non-random sampling regarding time and, specifically, location affects 
      how we interpret our results.
    - We download more up-to-date trees from `Nextstrain` (*n* = 4,645 genomes).
        - Downloaded on: 5/6/2020, 5:26:12 PM
        - Newer notes:
            - Although the genetic relationships among sampled viruses are 
              quite clear, there is considerable uncertainty surrounding 
              estimates of specific transmission dates and in the 
              reconstruction of geographic spread.
            - There are thousands of complete genomes available now, and this 
              number increases by hundreds of every day.
            - The `Nextstrain` visualization can only handle ~3000 genomes in a 
              single view for performance and legibility reasons.
            - Because of this, the `Nextstrain` team have to subsample 
              available genome data.
                - Their primary global analysis subsamples to 120 genomes per 
                  admin division per month.
            - This approach will result in a more equitable global sequence 
              distribution.
            - But, it hides samples available from regions that are doing lots 
              of sequencing.
        - Geographic distribution:
            - Africa: 121 (2.60%)
            - Asia: 913 (19.66%)
            - Europe: 1,992 (42.89%)
            - North America: 1,311 (28.22%)
            - Oceania: 190 (4.09%)
            - South America: 118 (2.54%)
    - Regarding the rate tree, we remove an extremely long internal branch and 
      its descendants (one France and seven Democratic Republic of Congo [DRC] 
      genomes; final *n* = 4,637).
    - We re-do our punctuation tests with the newer trees.
        - There is very little evidence to suggest that SARS-CoV-2 genomes 
          evolved in a punctuated manner (slope = 0 ± 0.000000035, *P* = 0.99; 
          *R<sup>2</sup>* = -2.67; LR [vs. an intercept-only model] = -81.86).
            - The negative *R<sup>2</sup>* makes sense because the punctuation 
              regression above collapses to an intercept-only model.
            - `BayesTraits` seem to have an issue estimating the intercepts.
                - Pagel's *λ* estimation is not the issue.
                - We decide to switch to using `R` for the remainder of the 
                  analyses.
            - `BayesTraits` results: slope = -0.000000000003, *P* = N/A; 
              *R<sup>2</sup>* = 0.000000000002; 
              LR [vs. an intercept-only model] = 0.13.
            - Rate tree results: slope = -0.0006 ± 0.000016, *P* < 0.0001; 
              *R<sup>2</sup>* = -7.82; 
              LR [vs. an intercept-only model] = 1,215.98.
            - The conclusions from `BayesTraits` and rate tree results are the 
              same.
        - There is little evidence that the models with continents as dummy 
          variables are more likely than the intercept-only one given the extra 
          parameters (ΔBIC [equal-slopes] = 230.96; 
          ΔBIC [separate-slopes] = 439.88).
            - We do not fit the same models multiple times while changing the 
              reference continent, to conserve computational times.
        - There is also little evidence that the models with the population 
          size variable are more likely than the intercept-only one 
          (ΔBIC [without interaction] = 123.68; 
          ΔBIC [with interaction] = 210.71).
        - Also, all models with *λ* = 0 are significantly less likely than 
          those with *λ* = 1 (mean ΔBIC [`R` results] = 54,633.88).
        - The *δ* test suggests that the node-density effect is absent
          (*δ* = -0.032).
            - For the rate tree, we have to estimate *λ* because *β* is 
              infinite when *λ* = 1.
            - The rate tree is also free of this artifact (*δ* = -0.041).
        - The residuals for the intercept-only and rate tree regression models 
          are not normally distributed (Shapiro-Wilk *P* < 0.0001).
    - The results from the newer tree analyses indicate that our previous 
      inferences might have been misled by sampling biases.
    - SARS-CoV-2 likely accumulates mutations gradually at the global and 
      continental scale, irrespective of the population size.
    - As a sensitivity analysis, we also re-do our punctuation tests with a 
      non-subsampled tree from `Nextstrain` (*n* =  12,397 genomes; 
      https://nextstrain.org/ncov/non-subsampled/2020-04-30).
        - Cassia Wagner kindly shares the tree with us.
        - Note that this tree was made as a sanity check for the `Nextstrain` 
          team, and not for further analyses.
            - The `Nextstrain` team typically excludes sequences with known 
              sequencing errors, and so the tree contains genomes with inflated 
              amounts of mutations.
            - They did not refine branch lengths on this build.
        - Downloaded on: 5/10/2020, 1:44:14 PM
        - Geographic distribution:
            - Africa: 100 (0.81%)
            - Asia: 863 (6.96%)
            - Europe: 6,735 (54.33%)
            - North America: 3,256 (26.26%)
            - Oceania: 1,325 (10.69%)
            - South America: 118 (0.95%)
        - We do not do the rate tree analyses because the `Nextstrain` team did 
          not infer a corresponding timetree.
        - [...]
- A follow-up question is whether only parts of the tree, where cross-continent 
  dispersal is rampant, exhibit signatures of punctuated evolution.

### SARS-like Betacoronaviruses Have Been Evolving Gradually

- ***We have not updated this part since 5/10/2020.***
- Has the evolution of the broader SARS-like betacoronaviruses also been 
  gradual?
    - While the spike gene likely has undergone selection either before or 
      after zoonotic transfers into humans (e.g., Andersen et al. 2020), we do 
      expect selection to be necessarily genome-wide.
    - We generally repeat the punctuation analyses as we do with the SARS-CoV-2 
      genomes.
    - We download a molecular tree of 52 SARS-like betacoronavirus genomes from 
      `Nextstrain` (https://nextstrain.org/groups/blab/sars-like-cov).
        - Downloaded on: 4/16/2020, 7:19:55 PM
        - See bioinformatic notes at https://github.com/blab/sars-like-cov.
        - Virus type distribution:
            - SARS-CoV: 12
            - SARS-CoV-2: 12
            - SARS-like CoV: 28
        - Host distribution:
            - Bat: 22 (natural reservoir; Xu et al. 2020)
            - Civet: 3
            - Human: 20
            - Pangolin: 6
        - A potential bias is that researchers and labs sequence SARS-like 
          betacoronavirus genomes more frequently at the onset and during a 
          pandemic.
        - There is no corresponding timetree.
    - We plot the data to explore candidate regression models.
    - We fit two additional regressions with virus types (SARS-CoV, SARS-CoV-2, 
      and SARS-like CoV) as dummy variables.
    - We compare the three models using the BIC, and select the one with the 
      lowest BIC value.
    - The model with the lowest BIC value is the one with a single regression 
      fit line (BIC = -510.55; lowest ΔBIC = 4.31).
    - There is very little evidence to suggest that SARS-like betacoronavirus 
      genomes evolved in a punctuated manner (slope = 0.0000044 ± 0.000028; 
      *P* value = 0.438; *R<sup>2</sup>* = 0.00049).
    - However, regression diagnostics indicate violations of the residual 
      homogeneity of variance and normality assumptions.
    - The *δ* test suggests that the node-density effect is present 
      (*δ* = 9.46), but because we do not find punctuation, this artifact does 
      not bias our analysis.
    - Taken together, SARS-like betacoronaviruses have most likely been 
      evolving gradually, before and during the two pandemics.

### SARS-CoV-2 Transmissions through Space and Time

- Here, we analyze, under a phylogenetic framework, how SARS-CoV-2 net 
  transmissions vary across geographic regions and through time.
    - We acknowledge multiple factors that could cause the net transmission 
      rate to differ between continents.
        - Variables that can cause heterogeneity
            - Population size and density (Cobey 2020)
            - Public health (see Richardson et al. 2020 and Zhou et al. 2020b 
              regarding underlying health conditions)
            - Transmission prevention efforts (e.g., handwashing, face covering 
              [Anfinrud et al. 2020; Leung et al. 2020], social distancing, 
              lockdown, enforcement, travel restrictions [Chinazzi et al. 
              2020], healthcare [Cobey 2020], etc.)
            - Sampling effort and or capability
            - Sequencing effort and or capability
            - Reporting of cases
                - Note that the number of undiagnosed cases is likely higher 
                  than reported (Vogel 2020).
        - Because coding continents as dummy variables is a crude approach, we 
          do not expect heterogeneity between continents to exceed that of 
          within.
        - On the other hand, using countries as proxies to geographic variation 
          would result in an overly complicated model (i.e., too many country 
          variables).
        - Latitude/Longitude data may be an ideal alternative 
          (https://github.com/nextstrain/ncov/blob/master/config/lat_longs.tsv).
        - Another bias is that some SARS-CoV-2 genomes came from patients with 
          different exposure and sampling locations.
    - To assess geographic sampling bias, we can regress the number of sampled 
      genomes in a country against the number of reported cases, accounting for 
      continents, and shared branch lengths.
    - While we can test for a slowdown or an acceleration in transmission 
      (*sensu* Sakamoto et al. 2016), we have to recognize multiple factors:
        - Variables that promote transmission
            - Introduction to new environments
            - The rise of key mutations
            - Relaxed selection
            - Sampling frequency
            - Sequencing frequency
        - Variables that impede transmission
            - Filling of ecological niches
            - The rise of deleterious mutations
            - Transmission prevention efforts (e.g., handwashing, face 
              covering, social distancing, lockdown, enforcement, healthcare, 
              etc.)
        - Variables that may either promote or impede transmission
            - Seasonal change (Cobey 2020; Cohen 2020)
    - The lists of factors above are not exhaustive.
    - We can compare our results with *R<sub>0</sub>* estimates.
        - The average *R<sub>0</sub>* value is 2.2-6.47 (briefly reviewed in 
          Wang et al. 2020b).
            - *R<sub>0</sub>* is the transmission rate divided by the rate at 
              which people recover or die (Cobey 2020).
    - To test for variations in net transmission across continents and days, we 
      regress the log-transformed number of nodes along phylogenetic paths 
      against time, accounting for continents, and shared branch lengths.
        - Because node count likely follows a Poisson distribution rather than 
          a normal one, we use phylogenetic Poisson regression 
          (see https://bookdown.org/roback/bookdown-bysh/ch-poissonreg.html).
            - The `R` package `phylolm` 2.6 (Ho and Ané 2014) unfortunately 
              cannot handle zero branch lengths.
            - `ape`'s generalized estimating equations (GEE) method may be the 
              ideal option (Paradis and Claude 2002).
                - GEE accounts for phylogeny in the form of a correlation 
                  matrix.

## Brief Literature Review

- **Holmes (2003)**  
    summarized the general structure of SARS-associated coronavirus virion
- **Andersen et al. (2020)**  
    reviewed hypotheses on the origin of SARS-CoV-2, particularly on whether 
    selection occurred before or after the zoonotic transfer into humans
- **Anfinrud et al. (2020)**  
    demonstrated how mouth covering could reduce the emission of droplets
- **Damas et al. (2020)**  
    analyzed vertebrate ACE2, covering sequence and structure conservation, 
    susceptibility to SARS-CoV-2, possible SARS-CoV-2 intermediates, and site- 
    and lineage-specific selective pressures
- **Gorbalenya et al. (2020)**  
    named SARS-CoV-2
- **Richardson et al. (2020)**  
    reported that many COVID-19 patients hospitalized in the New York City area 
    have underlying health conditions like hypertension, obesity, and diabetes
- **van Doremalen et al. (2020)**
    evaluated the stability of SARS-CoV-2 and SARS-CoV-1 in aerosols and on 
    various surfaces, and estimated their decay rates
- **Wang et al. (2020a)**  
    summarized all three major coronaviruses outbreaks
- **Wu et al. (2020a)**  
    analyzed the SARS-CoV-2 genome from one of the likely patient zeroes
- **Wu et al. (2020b)**  
    showed that SARS-CoV-2 viral RNA could persists in fecal samples longer 
    than in respiratory ones
- **Wu et al. (2020c)**  
    championed wastewater surveillance to help estimate the prevalence of 
    SARS-CoV-2 in a population
- **Xiao et al. (2020)**  
    hypothesized that SARS-CoV-2 originated from the recombination of pangolin 
    and bat CoV-like viruses
- **Xu et al. (2020)**  
    briefly reviewed the origin and transmission of SARS-CoV-2
- **Zhang et al. (2020):**  
    proposed pangolin as a possible natural reservoir of SARS-CoV-2
- **Zhou et al. (2020a):**  
    analyzed the SARS-CoV-2 genomes from five of the likely patient zeroes

## References

- Amanat F., Krammer F. 2020. SARS-CoV-2 vaccines: Status report. Immunity.
- Andersen K.G., Rambaut A., Lipkin W.I., Holmes E.C., Garry R.F. 2020. ***The 
    proximal origin of SARS-CoV-2***. Nat. Med. 26:450–452.
- Anfinrud P., Stadnytskyi V., Bax C.E., Bax A. 2020. Visualizing 
    speech-generated oral fluid droplets with laser light scattering. N. 
    Engl. J. Med.
- Attali D., Baker C. 2019. ggExtra: Add marginal histograms to "ggplot2", and 
    more "ggplot2" enhancements. R package.
- Arnold J.B. 2019. ggthemes: Extra themes, scales and geoms for "ggplot2." R 
    package.
- Blyth C.R. 1972. On Simpson’s paradox and the sure-thing principle. J. Am. 
    Stat. Assoc. 67:364–366.
- Chinazzi M., Davis J.T., Ajelli M., Gioannini C., Litvinova M., Merler S., 
    Piontti A.P. y, Mu K., Rossi L., Sun K., Viboud C., Xiong X., Yu H., 
    Halloran M.E., Longini I.M., Vespignani A. 2020. The effect of travel 
    restrictions on the spread of the 2019 novel coronavirus (COVID-19) 
    outbreak. Science. 368:395–400.
- Cobey S. 2020. ***Modeling infectious disease dynamics.*** Science. 
    368:713–714.
- Cohen J. 2020. Why do dozens of diseases wax and wane with the seasons—and 
    will COVID-19? Available from https://www.sciencemag.org/news/2020/03/why-do-dozens-diseases-wax-and-wane-seasons-and-will-covid-19.
- Corum J., Zimmer C. 2020. How Coronavirus Mutates and Spreads. The New York 
    Times.
- Damas J., Hughes G.M., Keough K.C., Painter C.A., Persky N.S., Corbo M., 
    Hiller M., Koepfli K.-P., Pfenning A.R., Zhao H., Genereux D.P., Swofford 
    R., Pollard K.S., Ryder O.A., Nweeia M.T., Lindblad-Toh K., Teeling E.C., 
    Karlsson E.K., Lewin H.A. 2020. Broad host range of SARS-CoV-2 predicted by 
    comparative and structural analysis of ACE2 in vertebrates. 
    bioRxiv.:2020.04.16.045302.
- De Maio N., Walker C., Borges R., Weilguny L., Slodkowicz G., Goldman N. 
    2020. Issues with SARS-CoV-2 sequencing data. Available from 
    http://virological.org/t/issues-with-sars-cov-2-sequencing-data/473.
- Fu L., Niu B., Zhu Z., Wu S., Li W. 2012. CD-HIT: accelerated for clustering 
    the next-generation sequencing data. Bioinformatics. 28:3150–3152.
- Galvani A.P. 2003. Epidemiology meets evolutionary ecology. Trends Ecol. 
    Evol. 18:132–139.
- Gandon S., Mackinnon M.J., Nee S., Read A.F. 2001. Imperfect vaccines and the 
    evolution of pathogen virulence. Nature. 414:751–756.
- Gao Q., Bao L., Mao H., Wang L., Xu K., Yang M., Li Y., Zhu L., Wang N., Lv 
    Z., Gao H., Ge X., Kan B., Hu Y., Liu J., Cai F., Jiang D., Yin Y., Qin C., 
    Li J., Gong X., Lou X., Shi W., Wu D., Zhang H., Zhu L., Deng W., Li Y., Lu 
    J., Li C., Wang X., Yin W., Zhang Y., Qin C. 2020. Development of an 
    inactivated vaccine candidate for SARS-CoV-2. Science.
- Gorbalenya A.E., Baker S.C., Baric R.S., de Groot R.J., Drosten C., Gulyaeva 
    A.A., Haagmans B.L., Lauber C., Leontovich A.M., Neuman B.W., Penzar D., 
    Perlman S., Poon L.L.M., Samborskiy D.V., Sidorov I.A., Sola I., Ziebuhr 
    J., Coronaviridae Study Group of the International Committee on Taxonomy of 
    Viruses. 2020. ***The species Severe acute respiratory syndrome-related 
    coronavirus 2: Classifying 2019-nCoV and naming it SARS-CoV-2.*** Nat. 
    Microbiol. 5:536–544.
- Hadfield J., Megill C., Bell S.M., Huddleston J., Potter B., Callender C.,
    Sagulenko P., Bedford T., Neher R.A. 2018. Nextstrain: Real-time tracking 
    of pathogen evolution. Bioinformatics. 34:4121–4123.
- Ho L.S.T., Ané C. 2014. A linear-time algorithm for Gaussian and non-Gaussian 
    trait evolution models. Syst. Biol. 63:397–408.
- Holmes K.V. 2003. ***SARS-associated coronavirus***. N. Engl. J. Med. 
    348:1948–1951.
- Jia Y., Shen G., Zhang Y., Huang K.-S., Ho H.-Y., Hor W.-S., Yang C.-H., Li 
    C., Wang W.-L. 2020. ***Analysis of the mutation dynamics of SARS-CoV-2 
    reveals the spread history and emergence of RBD mutant with lower ACE2 
    binding affinity***. bioRxiv.:2020.04.09.034942.
- Jin Z., Zhao Y., Sun Y., Zhang B., Wang H., Wu Y., Zhu Y., Zhu C., Hu T., Du 
    X., Duan Y., Yu J., Yang X., Yang X., Yang K., Liu X., Guddat L.W., Xiao 
    G., Zhang L., Yang H., Rao Z. 2020. Structural basis for the inhibition of 
    SARS-CoV-2 main protease by antineoplastic drug carmofur. Nat. Struct. Mol. 
    Biol. 1–4.
- Katoh K., Standley D.M. 2013. MAFFT Multiple sequence alignment software 
    version 7: Improvements in performance and usability. Mol. Biol. Evol. 
    30:772–780.
- Kendall M.G. 1938. A new measure of rank correlation. Biometrika. 30:81–93.
- Kupferschmidt K. 2020. Mutations can reveal how the coronavirus moves—but 
    they're easy to overinterpret. Available from https://www.sciencemag.org/news/2020/03/mutations-can-reveal-how-coronavirus-moves-they-re-easy-overinterpret.
- Lauer S.A., Grantz K.H., Bi Q., Jones F.K., Zheng Q., Meredith H.R., Azman 
    A.S., Reich N.G., Lessler J. 2020. The incubation period of coronavirus 
    disease 2019 (COVID-19) from publicly reported confirmed cases: Estimation 
    and application. Ann. Intern. Med. 172:577–582.
- Le T.T., Andreadakis Z., Kumar A., Román R.G., Tollefsen S., Saville M., 
    Mayhew S. 2020. The COVID-19 vaccine development landscape. Nat. Rev. Drug 
    Discov. 19:305–306.
- Lei C., Qian K., Li T., Zhang S., Fu W., Ding M., Hu S. 2020. Neutralization 
    of SARS-CoV-2 spike pseudotyped virus by recombinant ACE2-Ig. Nat. Commun. 
    11:1–5.
- Leung N.H.L., Chu D.K.W., Shiu E.Y.C., Chan K.-H., McDevitt J.J., Hau B.J.P., 
    Yen H.-L., Li Y., Ip D.K.M., Peiris J.S.M., Seto W.-H., Leung G.M., Milton 
    D.K., Cowling B.J. 2020. Respiratory virus shedding in exhaled breath and 
    efficacy of face masks. Nat. Med. 1–5.
- Liow L.H., Valen L.V., Stenseth N.C. 2011. Red Queen: From populations to 
    taxa and communities. Trends Ecol. Evol. 26:349–358.
- Mayr E. 1954. Change of genetic environment and evolution. In: Huxley J., 
    Hardy A.C., Ford E.B., editors. Evolution as a Process. London, U.K.: Allan 
    & Unwin. p. 157–180.
- Minh B.Q., Schmidt H.A., Chernomor O., Schrempf D., Woodhams M.D., von 
    Haeseler A., Lanfear R. 2020. IQ-TREE 2: New models and efficient methods 
    for phylogenetic inference in the genomic era. Mol. Biol. Evol. 
    37:1530–1534.
- Muth D., Corman V.M., Roth H., Binger T., Dijkman R., Gottula L.T., 
    Gloza-Rausch F., Balboni A., Battilani M., Rihtarič D., Toplak I., 
    Ameneiros R.S., Pfeifer A., Thiel V., Drexler J.F., Müller M.A., Drosten C. 
    2018. Attenuation of replication by a 29 nucleotide deletion in 
    SARS-coronavirus acquired during the early stages of human-to-human 
    transmission. Sci. Rep. 8:1–11.
- O'Hara R.B., Kotze D.J. 2010. Do not log-transform count data. Methods Ecol. 
    Evol. 1:118–122.
- Pagel M. 1999. Inferring the historical patterns of biological evolution. 
    Nature. 401:877–884.
- Pagel M., Venditti C., Meade A. 2006. Large punctuational contribution of 
    speciation to evolutionary divergence at the molecular level. Science. 
    314:119–121.
- Paradis E., Claude J. 2002. Analysis of comparative data using generalized 
    estimating equations. J. Theor. Biol. 218:175–185.
- Paradis E., Schliep K. 2019. ape 5.0: An environment for modern phylogenetics 
    and evolutionary analyses in R. Bioinformatics. 35:526–528.
- Pennell M.W., Harmon L.J., Uyeda J.C. 2014. Is there room for punctuated 
    equilibrium in macroevolution? Trends Ecol. Evol. 29:23–32.
- Pinheiro J., Bates D., DebRoy S., Sarkar D., R Core Team. 2019. nlme: Linear 
    and nonlinear mixed effects models. R package.
- Pybus O.G., Rambaut A. 2009. Evolutionary analysis of the dynamics of viral 
    infectious disease. Nat. Rev. Genet. 10:540–550.
- R Core Team. 2019. R: A language and environment for statistical computing. 
    Vienna, Austria: R Foundation for Statistical Computing.
- Rabosky D.L. 2012. Positive correlation between diversification rates and 
    phenotypic evolvability can mimic punctuated equilibrium on molecular 
    phylogenies. Evolution. 66:2622–2627.
- Rambaut A. 2017. FigTree-version 1.4.4, a graphical viewer of phylogenetic 
    trees.
- Raftery A.E. 1995. Bayesian model selection in social research. Sociol. 
    Methodol. 25:111–163.
- Revell L.J. 2012. phytools: An R package for phylogenetic comparative biology 
    (and other things). Methods Ecol. Evol. 3:217–223.
- Richardson S., Hirsch J.S., Narasimhan M., Crawford J.M., McGinn T., Davidson 
    K.W., Barnaby D.P., Becker L.B., Chelico J.D., Cohen S.L., Cookingham J., 
    Coppa K., Diefenbach M.A., Dominello A.J., Duer-Hefele J., Falzon L., 
    Gitlin J., Hajizadeh N., Harvin T.G., Hirschwerk D.A., Kim E.J., Kozel 
    Z.M., Marrast L.M., Mogavero J.N., Osorio G.A., Qiu M., Zanos T.P. 2020. 
    Presenting characteristics, comorbidities, and outcomes among 5700 patients 
    hospitalized with COVID-19 in the New York City area. JAMA.
- Sagulenko P., Puller V., Neher R.A. 2017. TreeTime: Maximum-likelihood 
    phylodynamic analysis. Virus Evol. 4.
- Sakamoto M., Benton M.J., Venditti C. 2016. Dinosaurs in decline tens of 
    millions of years before their final extinction. Proc. Natl. Acad. Sci. 
    U.S.A. 113:5036–5040.
- Salje H., Lessler J., Berry I.M., Melendrez M.C., Endy T., Kalayanarooj S., 
    A-Nuegoonpipat A., Chanama S., Sangkijporn S., Klungthong C., 
    Thaisomboonsuk B., Nisalak A., Gibbons R.V., Iamsirithaworn S., Macareo 
    L.R., Yoon I.-K., Sangarsang A., Jarman R.G., Cummings D.A.T. 2017. Dengue 
    diversity across spatial and temporal scales: Local structure and the 
    effect of host population size. Science. 355:1302–1306.
- Schwarz G. 1978. Estimating the dimension of a model. Ann. Stat. 6:461–464.
- Shapiro S.S., Wilk M.B. 1965. An analysis of variance test for normality 
    (complete samples). Biometrika. 52:591–611.
- Sheahan T.P., Sims A.C., Zhou S., Graham R.L., Pruijssers A.J., Agostini 
    M.L., Leist S.R., Schäfer A., Dinnon K.H., Stevens L.J., Chappell J.D., Lu 
    X., Hughes T.M., George A.S., Hill C.S., Montgomery S.A., Brown A.J., 
    Bluemling G.R., Natchus M.G., Saindane M., Kolykhalov A.A., Painter G., 
    Harcourt J., Tamin A., Thornburg N.J., Swanstrom R., Denison M.R., Baric 
    R.S. 2020. An orally bioavailable broad-spectrum antiviral inhibits 
    SARS-CoV-2 in human airway epithelial cell cultures and multiple 
    coronaviruses in mice. Sci. Transl. Med. 12.
- Shu Y., McCauley J. 2017. GISAID: Global initiative on sharing all influenza 
    data – from vision to reality. Euro Surveill. 22.
- Sievert C. 2018. plotly for R.
- Slowinski K. 2020. ggrepel: Automatically position non-overlapping text 
    labels with "ggplot2." R package.
- Stenseth N.C., Smith J.M. 1984. Coevolution in ecosystems: Red Queen 
    evolution or stasis? Evolution. 38:870–880.
- Urbanek S., Horner J. 2019. Cairo: R graphics device using cairo graphics 
    library for creating high-quality bitmap (PNG, JPEG, TIFF), vector (PDF, 
    SVG, PostScript) and display (X11 and Win32) output. R package.
- Vaidyanathan R., Xie Y., Allaire J.J., Chang J., Russell K. 2019. 
    htmlwidgets: HTML widgets for R. R package.
- van Doremalen N., Bushmaker T., Morris D.H., Holbrook M.G., Gamble A., 
    Williamson B.N., Tamin A., Harcourt J.L., Thornburg N.J., Gerber S.I., 
    Lloyd-Smith J.O., de Wit E., Munster V.J. 2020. Aerosol and surface 
    stability of SARS-CoV-2 as compared with SARS-CoV-1. N. Engl. J. Med. 
    382:1564–1567.
- Van Valen L. 1973. A new evolutionary law. Evol. Theory. 1:1–30.
- Venditti C., Meade A., Pagel M. 2006. Detecting the node-density artifact in 
    phylogeny reconstruction. Syst. Biol. 55:637–643.
- Venditti C., Pagel M. 2014. Plenty of room for punctuational change. Trends 
    Ecol. Evol. 29:71–72.
- Vogel G. 2020. Antibody surveys suggesting vast undercount of coronavirus 
    infections may be unreliable. Available from https://www.sciencemag.org/news/2020/04/antibody-surveys-suggesting-vast-undercount-coronavirus-infections-may-be-unreliable.
- Volz E.M., Koelle K., Bedford T. 2013. Viral phylodynamics. PLOS Comput. 
    Biol. 9:e1002947.
- Wang C., Horby P.W., Hayden F.G., Gao G.F. 2020a. A novel coronavirus 
    outbreak of global health concern. Lancet. 395:470–473.
- Wang H., Wang Z., Dong Y., Chang R., Xu C., Yu X., Zhang S., Tsamlag L., 
    Shang M., Huang J., Wang Y., Xu G., Shen T., Zhang X., Cai Y. 2020b. 
    ***Phase-adjusted estimation of the number of Coronavirus Disease 2019 
    cases in Wuhan, China***. Cell Discov. 6:1–8.
- Wang C., Li W., Drabek D., Okba N.M.A., van Haperen R., Osterhaus A.D.M.E., 
    van Kuppeveld F.J.M., Haagmans B.L., Grosveld F., Bosch B.-J. 2020c. A 
    human monoclonal antibody blocking SARS-CoV-2 infection. Nat. Commun. 
    11:1–6.
- Webster A.J., Payne R.J.H., Pagel M. 2003. Molecular phylogenies link rates 
    of evolution and speciation. Science. 301:478–478.
- Wickham H. 2009. ggplot2: Elegant graphics for data analysis. New York: 
    Springer-Verlag.
- Wickham H., Henry L., Luciani T.J., Decorde M., Lise V. 2019. svglite: An 
    "SVG" graphics device. R package.
- Wu F., Zhao S., Yu B., Chen Y.-M., Wang W., Song Z.-G., Hu Y., Tao Z.-W., 
    Tian J.-H., Pei Y.-Y., Yuan M.-L., Zhang Y.-L., Dai F.-H., Liu Y., Wang 
    Q.-M., Zheng J.-J., Xu L., Holmes E.C., Zhang Y.-Z. 2020a. ***A new 
    coronavirus associated with human respiratory disease in China***. Nature. 
    579:265–269.
- Wu Y., Guo C., Tang L., Hong Z., Zhou J., Dong X., Yin H., Xiao Q., Tang Y., 
    Qu X., Kuang L., Fang X., Mishra N., Lu J., Shan H., Jiang G., Huang X. 
    2020b. Prolonged presence of SARS-CoV-2 viral RNA in faecal samples. 
    Lancet Gastroenterol. Hepatol. 5:434–435.
- Wu F., Xiao A., Zhang J., Gu X., Lee W.L., Kauffman K., Hanage W., Matus M., 
    Ghaeli N., Endo N., Duvallet C., Moniz K., Erickson T., Chai P., Thompson 
    J., Alm E. 2020c. SARS-CoV-2 titers in wastewater are higher than expected 
    from clinically confirmed cases. medRxiv.:2020.04.05.20051540.
- Xiao K., Zhai J., Feng Y., Zhou N., Zhang X., Zou J.-J., Li N., Guo Y., Li 
    X., Shen X., Zhang Z., Shu F., Huang W., Li Y., Zhang Z., Chen R.-A., Wu 
    Y.-J., Peng S.-M., Huang M., Xie W.-J., Cai Q.-H., Hou F.-H., Liu Y., Chen 
    W., Xiao L., Shen Y. 2020. ***Isolation and characterization of 
    2019-nCoV-like coronavirus from Malayan pangolins***. 
    bioRxiv.:2020.02.17.951335.
- Xu Y. 2020. ***Unveiling the origin and transmission of 2019-nCoV***. Trends 
    Microbiol. 28:239–240.
- Yin W., Mao C., Luan X., Shen D.-D., Shen Q., Su H., Wang X., Zhou F., Zhao 
    W., Gao M., Chang S., Xie Y.-C., Tian G., Jiang H.-W., Tao S.-C., Shen J., 
    Jiang Y., Jiang H., Xu Y., Zhang S., Zhang Y., Xu H.E. 2020. Structural 
    basis for inhibition of the RNA-dependent RNA polymerase from SARS-CoV-2 by 
    remdesivir. Science.
- Yu G., Smith D.K., Zhu H., Guan Y., Lam T.T.-Y. 2017. ggtree: An r package 
    for visualization and annotation of phylogenetic trees with their 
    covariates and other associated data. Methods Ecol. Evol. 8:28–36.
- Yu G., Lam T.T.-Y., Zhu H., Guan Y. 2018. Two methods for mapping and 
    visualizing associated data on phylogeny using ggtree. Mol. Biol. Evol. 
    35:3041–3043.
- Yu G. 2020. ggimage: Use Image in "ggplot2." R package.
- Zhang T., Wu Q., Zhang Z. 2020. ***Probable pangolin origin of SARS-CoV-2 
    associated with the COVID-19 outbreak***. Curr. Biol. 30:1346-1351.e2.
- Zhou P., Yang X.-L., Wang X.-G., Hu B., Zhang L., Zhang W., Si H.-R., Zhu Y., 
    Li B., Huang C.-L., Chen H.-D., Chen J., Luo Y., Guo H., Jiang R.-D., Liu 
    M.-Q., Chen Y., Shen X.-R., Wang X., Zheng X.-S., Zhao K., Chen Q.-J., 
    Deng F., Liu L.-L., Yan B., Zhan F.-X., Wang Y.-Y., Xiao G.-F., Shi Z.-L. 
    2020a. ***A pneumonia outbreak associated with a new coronavirus of 
    probable bat origin***. Nature. 579:270–273.
- Zhou F., Yu T., Du R., Fan G., Liu Y., Liu Z., Xiang J., Wang Y., Song B., Gu 
    X., Guan L., Wei Y., Li H., Wu X., Xu J., Tu S., Zhang Y., Chen H., Cao B. 
    2020b. Clinical course and risk factors for mortality of adult inpatients 
    with COVID-19 in Wuhan, China: A retrospective cohort study. Lancet. 
    395:1054–1062.

## *Nature* Coronavirus Collection

- **[Coronavirus][]**
- **[Coronavirus research updates: An antibody blocks the new coronavirus and 
     an older relative][]**
- **[Coronavirus: the first three months as it happened][]**
- [China coronavirus: Six questions scientists are asking][]
- [How sewage could reveal true scale of coronavirus outbreak][]
- [Did pangolins spread the China coronavirus to people?][]
- [Why snakes probably aren't spreading the new China virus][]
- [How much is coronavirus spreading under the radar?][]
- [The coronavirus pandemic in five powerful charts][]

[Coronavirus]: https://www.nature.com/collections/hajgidghjb
[Coronavirus research updates: An antibody blocks the new coronavirus and an 
 older relative]: https://doi.org/10.1038/d41586-020-00502-w
[Coronavirus: the first three months as it happened]:
    https://doi.org/10.1038/d41586-020-00154-w
[China coronavirus: Six questions scientists are asking]:
    https://doi.org/10.1038/d41586-020-00166-6
[How sewage could reveal true scale of coronavirus outbreak]:
    https://doi.org/10.1038/d41586-020-00973-x
[Did pangolins spread the China coronavirus to people?]:
    https://doi.org/10.1038/d41586-020-00364-2
[Why snakes probably aren't spreading the new China virus]:
    https://doi.org/10.1038/d41586-020-00180-8
[How much is coronavirus spreading under the radar?]:
    https://doi.org/10.1038/d41586-020-00760-8
[The coronavirus pandemic in five powerful charts]:
    https://doi.org/10.1038/d41586-020-00758-2

## *Science* Coronavirus Collection

- **[Coronavirus: Research, Commentary, and News][]**

[Coronavirus: Research, Commentary, and News]: https://www.sciencemag.org/coronavirus-research-commentary-and-news?utm_source=newsletters&utm_medium=newsletter&utm_campaign=coronavirus600x190-24027&et_rid=681382821&et_cid=3261778#

## Other Resources

- **[LitCOVID][]**
- **[Nextstrain][]**
- **[Nextstrain: Genomic analysis of COVID-19. Situation report 2020-05-15][]**
- **[Nextstrain: Genomic epidemiology of novel coronavirus][]**
- **[Nextstrain: Genetic diversity of betacoronaviruses including novel 
     coronavirus (nCoV)][]**
- **[Nextstrain: Phylogeny of SARS-like betacoronaviruses including novel 
     coronavirus SARS-CoV-2][]**
- **[Johns Hopkins University & Medicine Coronavirus Resource Center][]**
- **[2019 Novel Coronavirus COVID-19 (2019-nCoV) Data Repository by Johns 
     Hopkins CSSE][]**
- **[NCBI Virus][]**
- [From Bats to Human Lungs, the Evolution of a Coronavirus][]
- [Bad News Wrapped in Protein: Inside the Coronavirus Genome][]
- [How Coronavirus Mutates and Spreads][]
- [Watching For Mutations in the Coronavirus][]
- [The Coronavirus Is Mutating. What Does That Mean for a Vaccine?][]
- [First 'Significant' Coronavirus Mutation Discovered In Preliminary Study][]
- [How coronavirus spreads through a population and how we can beat it][]
- [Why you're unlikely to get the coronavirus from runners or cyclists][]
- [Covid-19 Arrived in Seattle. Where It Went From There Stunned the 
   Scientists][]
- [TWiV Special: Coronavirus update with Mark Denison, MD][]
- [Phylodynamic Analysis | 176 genomes | 6 Mar 2020][]
- [nCoV-2019 codon usage and reservoir (not snakes v2)][]
- [COVID-19 Projections][]
- [Molecular dating using heterochronous data and substitution model 
   averaging][]

[LitCOVID]: https://www.ncbi.nlm.nih.gov/research/coronavirus
[Nextstrain]: https://nextstrain.org
[Nextstrain: Genomic analysis of COVID-19. Situation report 2020-05-15]:
    https://nextstrain.org/narratives/ncov/sit-rep/2020-05-15
[Nextstrain: Genomic epidemiology of novel coronavirus]:
    https://nextstrain.org/ncov
[Nextstrain: Genetic diversity of betacoronaviruses including novel coronavirus 
 (nCoV)]: https://nextstrain.org/groups/blab/beta-cov
[Nextstrain: Phylogeny of SARS-like betacoronaviruses including novel 
 coronavirus SARS-CoV-2]: https://nextstrain.org/groups/blab/sars-like-cov
[Johns Hopkins University & Medicine Coronavirus Resource Center]:
    https://coronavirus.jhu.edu
[2019 Novel Coronavirus COVID-19 (2019-nCoV) Data Repository by Johns Hopkins 
 CSSE]: https://github.com/CSSEGISandData/COVID-19
[NCBI Virus]: https://www.ncbi.nlm.nih.gov/labs/virus/vssi/#
[From Bats to Human Lungs, the Evolution of a Coronavirus]:
    https://www.newyorker.com/science/elements/from-bats-to-human-lungs-the-evolution-of-a-coronavirus#intcid=recommendations_the-new-yorker-right-rail-popular_bb51f0e8-6f2e-4099-b947-1bed209b9498_popular4-1
[Bad News Wrapped in Protein: Inside the Coronavirus Genome]:
    https://www.nytimes.com/interactive/2020/04/03/science/coronavirus-genome-bad-news-wrapped-in-protein.html
[How Coronavirus Mutates and Spreads]:
    https://www.nytimes.com/interactive/2020/04/30/science/coronavirus-mutations.html
[Watching For Mutations in the Coronavirus]:
    https://blogs.sciencemag.org/pipeline/archives/2020/04/21/watching-for-mutations-in-the-coronavirus
[The Coronavirus Is Mutating. What Does That Mean for a Vaccine?]:
    https://www.nytimes.com/interactive/2020/04/16/opinion/coronavirus-mutations-vaccine-covid.html
[First 'Significant' Coronavirus Mutation Discovered In Preliminary Study]:
    https://www.newsweek.com/coronavirus-mutation-study-covid-19-1497745
[How coronavirus spreads through a population and how we can beat it]:
    https://www.theguardian.com/world/datablog/ng-interactive/2020/apr/22/see-how-coronavirus-can-spread-through-a-population-and-how-countries-flatten-the-curve
[Why you're unlikely to get the coronavirus from runners or cyclists]:
    https://www.vox.com/future-perfect/2020/4/24/21233226/coronavirus-runners-cyclists-airborne-infectious-dose
[Covid-19 Arrived in Seattle. Where It Went From There Stunned the Scientists]:
    https://www.nytimes.com/2020/04/22/us/coronavirus-sequencing.html?referringSource=articleShare&fbclid=IwAR0UvG4vtcdIH6BhltsMI08W75RGTgdCaqaKZV_4jNePBnvyiD-dZXBLaCE
[TWiV Special: Coronavirus update with Mark Denison, MD]:
    https://podcasts.apple.com/us/podcast/this-week-in-virology/id300973784?i=1000469609855
[Phylodynamic Analysis | 176 genomes | 6 Mar 2020]:
    http://virological.org/t/phylodynamic-analysis-176-genomes-6-mar-2020/356
[nCoV-2019 codon usage and reservoir (not snakes v2)]:
    http://virological.org/t/ncov-2019-codon-usage-and-reservoir-not-snakes-v2/339
[COVID-19 Projections]: https://covid19.healthdata.org/united-states-of-america
[Molecular dating using heterochronous data and substitution model averaging]:
    https://taming-the-beast.org/tutorials/Molecular-Dating-Tutorial

## Notes

### Punctuated SARS-CoV-2 Gene Evolution?

### Do Mutations in the Proofreader Gene Increase Evolvability?

### Convergent SARS-CoV-2 Mutations

- Using the consistency index (CI), we can test for the degree of convergence 
  in SARS-CoV-2 mutations, which may indicate independent adaptations.
    - We can also calculate the CI in each continent, which can inform us how 
      adaptations differ between continents.

### SARS-CoV-2 in Cruise Ships

- SARS-CoV-2 genomic diversity might have declined following transmissions into 
  cruise ships (i.e., founder effect), which may be equivalent to islands in 
  the theory of island biogeography (MacArthur and Wilson 1967).

### The Coevolution of Coronavirus Spike Gene and Vertebrate ACE2

- Do non-conservative mutations in the coronavirus *S* gene explain those in 
  the vertebrate ACE2?
- Possibly, not all mammal coronaviruses prefer ACE2 (Damas et al. 2020).

### Did Mutation Rates Increase Before or After the Zoonotic Transfer to Humans?

- The high binding affinity of the SARS-CoV-2 receptor-binding domain (RBD) to 
  human ACE2 indicate selection (Andersen et al. 2020).
- The question is whether selection occurred before the zoonotic transfer 
  (pre-adaptation in pangolins or other intermediates) or after (cryptic 
  human-to-human transmissions).
    - Potential biases are the undersampling of non-human SARS-like CoVs 
      (Andersen et al. 2020) and SARS-CoV-2 from the early cryptic transmission 
      stages (e.g., Bedford et al. 2020).
- Likely, SARS-like CoVs from bats and pangolins recombined before jumping into 
  humans (Lam et al. 2020; Nielsen et al. 2020; Xiao et al. 2020).

### References

- Bedford T., Greninger A.L., Roychoudhury P., Starita L.M., Famulare M., Huang 
    M.-L., Nalla A., Pepper G., Reinhardt A., Xie H., Shrestha L., Nguyen T.N., 
    Adler A., Brandstetter E., Cho S., Giroux D., Han P.D., Fay K., Frazar 
    C.D., Ilcisin M., Lacombe K., Lee J., Kiavand A., Richardson M., Sibley 
    T.R., Truong M., Wolf C.R., Nickerson D.A., Rieder M.J., Englund J.A., 
    The Seattle Flu Study Investigators, Hadfield J., Hodcroft E.B., 
    Huddleston J., Moncla L.H., Müller N.F., Neher R.A., Deng X., Gu W., 
    Federman S., Chiu C., Duchin J., Gautom R., Melly G., Hiatt B., Dykema P., 
    Lindquist S., Queen K., Tao Y., Uehara A., Tong S., MacCannell D., 
    Armstrong G.L., Baird G.S., Chu H.Y., Jerome K.R. 2020. Cryptic 
    transmission of SARS-CoV-2 in Washington State. medRxiv. 
    2020.04.02.20051417.
- Lam T.T.-Y., Shum M.H.-H., Zhu H.-C., Tong Y.-G., Ni X.-B., Liao Y.-S., Wei 
    W., Cheung W.Y.-M., Li W.-J., Li L.-F., Leung G.M., Holmes E.C., Hu Y.-L., 
    Guan Y. 2020. Identifying SARS-CoV-2 related coronaviruses in Malayan 
    pangolins. Nature. 1–6.
- MacArthur R.H., Wilson E.O. 1967. The Theory of Island Biogeography. 
    Princeton, NJ: Princeton University Press.
- Nielsen R., Wang H., Pipes L. 2020. Synonymous mutations and the molecular 
    evolution of SARS-Cov-2 origins. bioRxiv.:2020.04.20.052019.
