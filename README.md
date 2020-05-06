<img src="https://media.giphy.com/media/xULW8l2gXuRPmsQe8U/giphy.gif">

## Coronavirus Macroevolution

- [x] SARS-CoV-2: Punctuation (4/16)
- [x] SARS-CoV-2: Punctuation (4/16; mutation rate)
- [x] SARS-CoV-2: Punctuation (4/16; path ~ node x continent)
- [ ] SARS-CoV-2: Punctuation (5/05; equitable global subsampling)
- [ ] SARS-CoV-2: Punctuation (5/05; mutation rate)
- [ ] SARS-CoV-2: Punctuation (5/05; path ~ node x continent)
- [ ] SARS-CoV-2: Punctuation (4/30; non-subsampled)
- [ ] SARS-CoV-2: Punctuation (4/30; mutation rate)
- [ ] SARS-CoV-2: Punctuation (4/30; path ~ node x continent)
- [ ] SARS-Cov-2: Speciation ~ time + continent
- [ ] SARS-CoV-2: Geographic radiation
- [ ] SARS-CoV-2: Dispersal ~ mutation rate
- [x] SARS-like CoV: Punctuation

### The Mode of SARS-CoV-2 Evolution

- Here, we investigate the mode of SARS-CoV-2 genomic evolution and compare it 
  to its tempo.
    - The mutation rate of SARS-CoV-2 has so far been slower than that of 
      SARS-CoV (Jia et al. 2020), the seasonal flu (see Rambaut's statement in 
      Kupferschmidt 2020), and RNA viruses generally (Corum and Zimmer 2020).
        - SARS-CoV-2 has proofreader proteins.
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
              SARS-CoV-2 spreads around the Earth from only one origin (Wuhan).
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
          2020; Le et al. 2020; Sheahan et al. 2020) under development will 
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
        - We compare the separate-slopes model above with the single-slope one 
          using the Bayesian Information Criterion (BIC; Schwarz 1978) and 
          select the one with the lowest BIC value.
            - BIC = ln(*n*)*k* - 2ln(*Lh*)
                - *n:* the number of taxa (sample size)
                - *k:* the number of parameters estimated by the model
                - *Lh:* the maximized value of the likelihood function
            - ΔBIC = BIC of a model - BIC of the model with the lowest value
                - A ΔBIC lower than two is barely worth mentioning; between two 
                  and five represents positive evidence for the model with the 
                  lowest value; between five and ten a strong one; and a 
                  convincing one for a ΔBIC greater than ten (Raftery 1995).
        - The separate-slopes model is more likely than the single-slope one 
          (ΔBIC = 6,161.6; *R<sup>2</sup>* = 0.81).
        - There is indeed evidence for Simpson's paradox, with three lines 
          having positive slopes (Africa, Asia, and North America), and the 
          other three negative (Europe, Oceania, and South America).
            - All *P* values are less than 0.01.
            - The lines seem off because they are phylogenetically-corrected.
            - But, note that all continents have multiple introductions.
                - Using dummy coding may not be the most appropriate approach.
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
            - As before, the residual distribution is non-normal (Shapiro-Wilk 
              *P* < 0.0001).
        - We interpret the separate-slope regression results with care.
    - No published studies have interpreted negative slopes in a punctuation 
      regression test.
        - Here are some thoughts to help interpret negative slopes:
            - Viral transmission is allopatric.
            - Sampled viruses could either be in the middle of a coevolutionary 
              arms race with the host's immune system (Red Queen-like; Van 
              Valen 1973; Stenseth and Smith 1984) or at the end (i.e., 
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
                      179,670,186 central Americans from South America and add 
                      them to North America.
                - We use an additional `R` package, `ggrepel` 0.8.2 (Slowinski 
                  2020), when creating the scatter plot.
            - There is little evidence for a positive relationship, but this 
              result may be because of the small sample size (*τ* = 0.47; 
              *P* = 0.1361).
            - The plot shows somewhat of a positive relationship, with South 
              America likely being an outlier.
    - Non-random sampling regarding time and, specifically, location affects 
      how we interpret our results.
        - [...]
- A follow-up question is whether only parts of the tree, where cross-continent 
  dispersal is rampant, exhibit signatures of punctuated evolution.

### SARS-like Betacoronaviruses Have Been Evolving Gradually

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
- Cobey S. 2020. ***Modeling infectious disease dynamics***. Science.
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
- Gao Q., Bao L., Mao H., Wang L., Xu K., Yang M., Li Y., Zhu L., Wang N., Lv 
    Z., Gao H., Ge X., Kan B., Hu Y., Liu J., Cai F., Jiang D., Yin Y., Qin C., 
    Li J., Gong X., Lou X., Shi W., Wu D., Zhang H., Zhu L., Deng W., Li Y., Lu 
    J., Li C., Wang X., Yin W., Zhang Y., Qin C. 2020. Rapid development of an 
    inactivated vaccine for SARS-CoV-2. bioRxiv. 2020.04.17.046375.
- Gorbalenya A.E., Baker S.C., Baric R.S., de Groot R.J., Drosten C., Gulyaeva 
    A.A., Haagmans B.L., Lauber C., Leontovich A.M., Neuman B.W., Penzar D., 
    Perlman S., Poon L.L.M., Samborskiy D.V., Sidorov I.A., Sola I., Ziebuhr 
    J., Coronaviridae Study Group of the International Committee on Taxonomy of 
    Viruses. 2020. ***The species *Severe acute respiratory syndrome-related 
    coronavirus*: Classifying 2019-nCoV and naming it SARS-CoV-2***. Nat. 
    Microbiol. 1–9.
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
- Kendall M.G. 1938. A new measure of rank correlation. Biometrika. 30:81–93.
- Kupferschmidt K. 2020. Mutations can reveal how the coronavirus moves—but 
    they're easy to overinterpret. Available from https://www.sciencemag.org/news/2020/03/mutations-can-reveal-how-coronavirus-moves-they-re-easy-overinterpret.
- Lauer S.A., Grantz K.H., Bi Q., Jones F.K., Zheng Q., Meredith H.R., Azman 
    A.S., Reich N.G., Lessler J. 2020. The incubation period of coronavirus 
    disease 2019 (COVID-19) from publicly reported confirmed cases: Estimation 
    and application. Ann. Intern. Med. 172:577–582.
- Le T.T., Andreadakis Z., Kumar A., Román R.G., Tollefsen S., Saville M., 
    Mayhew S. 2020. The COVID-19 vaccine development landscape. Nat. Rev. Drug 
    Discov.
- Leung N.H.L., Chu D.K.W., Shiu E.Y.C., Chan K.-H., McDevitt J.J., Hau B.J.P., 
    Yen H.-L., Li Y., Ip D.K.M., Peiris J.S.M., Seto W.-H., Leung G.M., Milton 
    D.K., Cowling B.J. 2020. Respiratory virus shedding in exhaled breath and 
    efficacy of face masks. Nat. Med. 1–5.
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
- Pinheiro J., Bates D., DebRoy S., Sarkar D., R Core Team. 2019. nlme: Linear 
    and nonlinear mixed effects models. R package.
- R Core Team. 2019. R: A language and environment for statistical computing. 
    Vienna, Austria: R Foundation for Statistical Computing.
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
    coronaviruses in mice. Sci Transl. Med.
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
- Van Valen L. 1973. A new evolutionary law. Evol. Theory. 1:1–30.
- Venditti C., Meade A., Pagel M. 2006. Detecting the node-density artifact in 
    phylogeny reconstruction. Syst. Biol. 55:637–643.
- Vogel G. 2020. Antibody surveys suggesting vast undercount of coronavirus 
    infections may be unreliable. Available from https://www.sciencemag.org/news/2020/04/antibody-surveys-suggesting-vast-undercount-coronavirus-infections-may-be-unreliable.
- Wang C., Horby P.W., Hayden F.G., Gao G.F. 2020a. A novel coronavirus 
    outbreak of global health concern. Lancet. 395:470–473.
- Wang H., Wang Z., Dong Y., Chang R., Xu C., Yu X., Zhang S., Tsamlag L., 
    Shang M., Huang J., Wang Y., Xu G., Shen T., Zhang X., Cai Y. 2020b. 
    ***Phase-adjusted estimation of the number of Coronavirus Disease 2019 
    cases in Wuhan, China***. Cell Discov. 6:1–8.
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
- **[Coronavirus updates: autopsy results drastically change US coronavirus 
     timeline][]**
- [China coronavirus: Six questions scientists are asking][]
- [How sewage could reveal true scale of coronavirus outbreak][]
- [Did pangolins spread the China coronavirus to people?][]
- [Why snakes probably aren't spreading the new China virus][]
- [How much is coronavirus spreading under the radar?][]
- [The coronavirus pandemic in five powerful charts][]

[Coronavirus]: https://www.nature.com/collections/hajgidghjb
[Coronavirus updates: autopsy results drastically change US coronavirus 
 timeline]: https://doi.org/10.1038/d41586-020-00154-w
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
- [Cassia Wagner][]

[LitCOVID]: https://www.ncbi.nlm.nih.gov/research/coronavirus
[Nextstrain]: https://nextstrain.org
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
[Cassia Wagner]: https://bedford.io/team/cassia-wagner
