<img="https://media0.giphy.com/media/QNIL3zOyJplN6/giphy.gif">

# Coronavirus Macroevolution

### SARS-CoV-2 Genomes Are Evolving Gradually

- We first aim to describe the mode of SARS-CoV-2 evolution and how it compares 
  to its inferred slow tempo so far (Bedford et al. 2020; Jia et al. 2020)?
    - To start, we focus on SARS-CoV-2 whole genomes.
        - Once they jumped into and spread among humans, has SARS-CoV-2 been 
          evolving in a punctuational manner, so that a large proportion of 
          their genomic divergences occurred during transmission events?
        - The null hypothesis is that they have been evolving gradually.
        - To test for punctuated evolution (see Webster et al. 2003; Pagel et 
          al. 2006), we use phylogenetic generalized least squares (PGLS) to 
          regress the total phylogenetic path lengths of the genomes (distances 
          from the root of a phylogenetic tree to the tips) on the net number 
          of transmissions (nodes in a tree).
        - We expect the net number of transmissions along SARS-CoV-2 lineages 
          to correlate with (slope > 0) and explain the variation in 
          accumulated mutations (*R^2^* > 0), controlling for shared ancestry.
        - First, we downloaded a molecular tree of SARS-CoV-2 (*n* = 3,944 
          genomes) from `Nextstrain` (Sagulenko et al. 2017; Hadfield et al. 
          2018; https://nextstrain.org/ncov).
            - Downloaded on: 4/15/2020, 9:56:14 AM
            - The genomes come from various authors and labs, deposited at 
              `GISAID` (Shu and McCauley 2017; https://www.gisaid.org/).
            - Bioinformatic notes (see https://github.com/nextstrain/ncov):
                - Site numbering and genome structure use Wuhan-Hu-1/2019 
                  (GenBank Accession number: MN908947; Wu et al. 2020) as the 
                  reference.
                - The phylogeny is rooted relative to early samples from Wuhan.
                - There were single nucleotide polymorphisms (SNPs) present in 
                  the nCoV samples in the first and last few bases of the 
                  alignment that were masked as likely sequencing artifacts.
            - How does the `Nextstrain` team model the rate of molecular 
              evolution (e.g., substitution model, across-site rate variation, 
              clock model, and heterotachy)?
            - The branch lengths are in the unit of the expected number of 
              substitutions per site.
            - Once our analytical pipeline is up and running, we can redo the 
              analyses using the most up-to-date tree.
        - Using `FigTree` 1.4.4 (Rambaut 2017), we saved the tree in a Newick 
          format with the tip labels enclosed within single quotation marks.
            - This tip label edit is to prevent downstream errors.
        - Using the `R` 3.6.2 (R Core Team 2019) package `phytools` 0.6.99 
          (Revell 2012), we converted the Newick tree into a NEXUS format.
        - Using the package `ape` 5.3 (Paradis and Schliep 2019), we extracted 
          the total path lengths (diagonals of the variance-covariance matrix) 
          and the number of nodes along the paths.
        - Using the regex functionality in `Notepad++` 7.5.8, we fixed the 
          codings of clades with 'anagenetic' taxa in the tree file.
            - Example:
                - Problematic: `(10:0,(11:0):5);`
                - Correct: `(10:0,11:5);`
                - Regex (search): `\(([0-9][0-9]):0\)`
                    - The backslashes escape the parentheses in front of them.
                    - The unescaped parentheses set the digits they enclose as 
                      a group.
                - Regex (replace): `\1`
                    - The replacement is the group designated above.
        - Using the maximum likelihood (ML) algorithm in `BayesTraits` 3.0.1 
          (Pagel 1999; http://www.evolution.rdg.ac.uk/BayesTraitsV3.0.1/BayesTraitsV3.0.1.html), 
          we estimated the parameters of the regression model above.
            - PGLS accounts for the shared inheritance of branch lengths.
            - Our PGLS model assumes that the tree is correct.
            - We fixed Pagel's *λ* (Pagel 1999), a measure of phylogenetic 
              signal, to one.
            - We used default ML search settings.
            - We executed two ML runs and compared the results.
        - There is very little evidence to suggest that SARS-CoV-2 genomes 
          evolved in a punctuated manner (slope = 0.0084 ± 0.0032; 
          *R^2^* = 0.0018).
            - The two ML runs produced practically identical results.
        - SARS-CoV-2 genomes are most likely evolving gradually, with much of 
          the mutations occurring in between net transmission events, as 
          depicted in the tree.
        - We, therefore, find that the tempo and mode of SARS-CoV-2 evolution 
          are linked.
        - We created and saved scatter plots of the regression using the `R` 
          packages `Cairo` 1.5.10 (Urbanek and Horner 2019), `ggplot2` 3.2.1 
          (Wickham 2009), `ggthemes` 4.2.0 (Arnold 2019), `htmlwidgets` 1.5.1 
          (Vaidyanathan et al. 2019), `plotly` 4.9.1 (Sievert 2018), and 
          `svglite` 1.2.2 (Wickham et al. 2019).
            - We did not observe any potential outliers.
        - We ran regression diagnostics by plotting the residuals against 
          fitted values, and a histogram of the residuals using the packages 
          `ggExtra` 0.9 (Attali and Baker 2019), `ggplot2`, `ggthemes`, and 
          `svglite`.
            - The residuals vs. fitted values plot does not indicate a 
              violation of residual homogeneity.
            - The histogram shows that the residuals are normally distributed.
        - We checked whether an artifact of phylogeny reconstruction, the 
          node-density effect (Webster et al. 2003; Venditti et al. 2006), 
          biases our punctuation test.
            - The node-density effect is the underestimation of branch lengths 
              in tree regions with fewer taxa.
            - We executed the *δ* test, which tests for a curvilinear 
              relationship between path length (*x*) and the number of nodes 
              (*n*).
                - Equation: *x* = *β*&middot;*n*^1/*δ*^
                    - *β:* rate of change between path length and the number of 
                           nodes
                - We expect *δ* > 1 when the node-density effect is present.
            - We used `R` to estimate *δ* by fitting a log-log regression.
        - The *δ* test suggests that the node-density effect is present 
          (*δ* = 8.17), but the *P* value of the exponent term is high 
          (*P* = 0.51), and the *R^2^* of the regression is low 
          (*R^2^* = 0.00011).
        - Non-random sampling regarding time and location can affect how we 
          interpret our results.
            - One way to roughly assess such sampling bias is to randomly drop 
              ~10% of the genomes in the tree, redo the analysis, and repeat 
              100 times.
    - A follow-up question is whether only certain parts of the tree exhibit 
      signatures of punctuated evolution.
    - Another potential follow-up is to test for punctuated evolution for each 
      gene in the genome.

## Brief Literature Review

- **Holmes (2003)**  
    summarized the general structure of SARS-associated coronavirus virion
- **Gorbalenya et al. (2020)**  
    named SARS-CoV-2
- **van Doremalen et al. (2020)**
    evaluated the stability of SARS-CoV-2 and SARS-CoV-1 in aerosols and on 
    various surfaces, and estimated their decay rates
- **Wang et al. (2020)**  
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
- **Zhang et al. (in press):**  
    proposed pangolin as a possible natural reservoir of SARS-CoV-2
- **Zhou et al. (2020):**  
    analyzed the SARS-CoV-2 genomes from five of the likely patient zeroes

## References

- Attali D., Baker C. 2019. ggExtra: Add marginal histograms to "ggplot2", and 
    more "ggplot2" enhancements. R package.
- Arnold J.B. 2019. ggthemes: Extra themes, scales and geoms for "ggplot2." R 
    package.
- Bedford T., Greninger A.L., Roychoudhury P., Starita L.M., Famulare M., Huang 
    M.-L., Nalla A., Pepper G., Reinhardt A., Xie H., Shrestha L., Nguyen T.N., 
    Adler A., Brandstetter E., Cho S., Giroux D., Han P.D., Fay K., Frazar 
    C.D., Ilcisin M., Lacombe K., Lee J., Kiavand A., Richardson M., Sibley 
    T.R., Truong M., Wolf C.R., Nickerson D.A., Rieder M.J., Englund J.A., 
    The Seattle Flu Study Investigators, Hadfield J., Hodcroft E.B., Huddleston 
    J., Moncla L.H., Müller N.F., Neher R.A., Deng X., Gu W., Federman S., Chiu 
    C., Duchin J., Gautom R., Melly G., Hiatt B., Dykema P., Lindquist S., 
    Queen K., Tao Y., Uehara A., Tong S., MacCannell D., Armstrong G.L., Baird 
    G.S., Chu H.Y., Jerome K.R. 2020. ***Cryptic transmission of SARS-CoV-2 in 
    Washington State***. medRxiv.:2020.04.02.20051417.
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
- Holmes K.V. 2003. ***SARS-associated coronavirus***. N. Engl. J. Med. 
    348:1948–1951.
- Jia Y., Shen G., Zhang Y., Huang K.-S., Ho H.-Y., Hor W.-S., Yang C.-H., Li 
    C., Wang W.-L. 2020. ***Analysis of the mutation dynamics of SARS-CoV-2 
    reveals the spread history and emergence of RBD mutant with lower ACE2 
    binding affinity***. bioRxiv.:2020.04.09.034942.
- Pagel M. 1999. Inferring the historical patterns of biological evolution. 
    Nature. 401:877–884.
- Pagel M., Venditti C., Meade A. 2006. Large punctuational contribution of 
    speciation to evolutionary divergence at the molecular level. Science. 
    314:119–121.
- Paradis E., Schliep K. 2019. ape 5.0: An environment for modern phylogenetics 
    and evolutionary analyses in R. Bioinformatics. 35:526–528.
- R Core Team. 2019. R: A language and environment for statistical computing. 
    Vienna, Austria: R Foundation for Statistical Computing.
- Rambaut A. 2017. FigTree-version 1.4.4, a graphical viewer of phylogenetic 
    trees.
- Revell L.J. 2012. phytools: An R package for phylogenetic comparative biology 
    (and other things). Methods Ecol. Evol. 3:217–223.
- Sagulenko P., Puller V., Neher R.A. 2017. TreeTime: Maximum-likelihood 
    phylodynamic analysis. Virus Evol. 4.
- Sievert C. 2018. plotly for R.
- Shu Y., McCauley J. 2017. GISAID: Global initiative on sharing all influenza 
    data – from vision to reality. Euro Surveill. 22.
- Urbanek S., Horner J. 2019. Cairo: R graphics device using cairo graphics 
    library for creating high-quality bitmap (PNG, JPEG, TIFF), vector (PDF, 
    SVG, PostScript) and display (X11 and Win32) output. R package.
- van Doremalen N., Bushmaker T., Morris D.H., Holbrook M.G., Gamble A., 
    Williamson B.N., Tamin A., Harcourt J.L., Thornburg N.J., Gerber S.I., 
    Lloyd-Smith J.O., de Wit E., Munster V.J. 2020. Aerosol and surface 
    stability of SARS-CoV-2 as compared with SARS-CoV-1. N. Engl. J. Med.
- Vaidyanathan R., Xie Y., Allaire J.J., Chang J., Russell K. 2019. 
    htmlwidgets: HTML widgets for R. R package.
- Venditti C., Meade A., Pagel M. 2006. Detecting the node-density artifact in 
    phylogeny reconstruction. Syst. Biol. 55:637–643.
- Wang C., Horby P.W., Hayden F.G., Gao G.F. 2020. ***A novel coronavirus 
    outbreak of global health concern***. Lancet. 395:470–473.
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
- Zhang T., Wu Q., Zhang Z. 2020. ***Probable pangolin origin of SARS-CoV-2 
    associated with the COVID-19 outbreak***. Curr. Biol. 30:1346-1351.e2.
- Zhou P., Yang X.-L., Wang X.-G., Hu B., Zhang L., Zhang W., Si H.-R., Zhu Y., 
    Li B., Huang C.-L., Chen H.-D., Chen J., Luo Y., Guo H., Jiang R.-D., Liu 
    M.-Q., Chen Y., Shen X.-R., Wang X., Zheng X.-S., Zhao K., Chen Q.-J., 
    Deng F., Liu L.-L., Yan B., Zhan F.-X., Wang Y.-Y., Xiao G.-F., Shi Z.-L. 
    2020. ***A pneumonia outbreak associated with a new coronavirus of probable 
    bat origin***. Nature. 579:270–273.

## *Nature* Coronavirus Collection

- **[Coronavirus][]**
- **[Coronavirus latest: Global infections pass two million][]**
- [China coronavirus: Six questions scientists are asking][]
- [How sewage could reveal true scale of coronavirus outbreak][]
- [Did pangolins spread the China coronavirus to people?][]
- [Why snakes probably aren't spreading the new China virus][]
- [How much is coronavirus spreading under the radar?][]
- [The coronavirus pandemic in five powerful charts][]

[Coronavirus]: https://www.nature.com/collections/hajgidghjb
[Coronavirus latest: Global infections pass two million]:
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

- **[COVID-19 Portofolio][]**
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
- **[From Bats to Human Lungs, the Evolution of a Coronavirus][]**
- **[Bad News Wrapped in Protein: Inside the Coronavirus Genome][]**
- [First 'Significant' Coronavirus Mutation Discovered In Preliminary Study][]
- [TWiV Special: Coronavirus update with Mark Denison, MD][]
- [Phylodynamic Analysis | 176 genomes | 6 Mar 2020][]
- [nCoV-2019 codon usage and reservoir (not snakes v2)][]
- [COVID-19 Projections][]
- [CovidActNow][]
- [Molecular dating using heterochronous data and substitution model 
   averaging][]

[COVID-19 Portofolio]: https://icite.od.nih.gov/covid19/search
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
[From Bats to Human Lungs, the Evolution of a Coronavirus]:
    https://www.newyorker.com/science/elements/from-bats-to-human-lungs-the-evolution-of-a-coronavirus#intcid=recommendations_the-new-yorker-right-rail-popular_bb51f0e8-6f2e-4099-b947-1bed209b9498_popular4-1
[Bad News Wrapped in Protein: Inside the Coronavirus Genome]:
    https://www.nytimes.com/interactive/2020/04/03/science/coronavirus-genome-bad-news-wrapped-in-protein.html
[First 'Significant' Coronavirus Mutation Discovered In Preliminary Study]:
    https://www.newsweek.com/coronavirus-mutation-study-covid-19-1497745
[TWiV Special: Coronavirus update with Mark Denison, MD]:
    https://podcasts.apple.com/us/podcast/this-week-in-virology/id300973784?i=1000469609855
[Phylodynamic Analysis | 176 genomes | 6 Mar 2020]:
    http://virological.org/t/phylodynamic-analysis-176-genomes-6-mar-2020/356
[nCoV-2019 codon usage and reservoir (not snakes v2)]:
    http://virological.org/t/ncov-2019-codon-usage-and-reservoir-not-snakes-v2/339
[COVID-19 Projections]: https://covid19.healthdata.org/united-states-of-america
[CovidActNow]: https://covidactnow.org
[Molecular dating using heterochronous data and substitution model averaging]:
    https://taming-the-beast.org/tutorials/Molecular-Dating-Tutorial
