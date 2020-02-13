Hello,

I am working with AFLP data and am running some post hoc tests using poppr and specifically looking at population structure using NJ trees. I am able to create the trees without issue (Nei and Provesti distance), but run into issues when trying to add bootstrap support. I have been unable to find other people with this issue and feel that it might be something simple I have overlooked. 

The error I receive is:

```r
> aboot(collected, dist = provesti.dist, sample = 200, tree = "nj", cutoff = 50, quiet = TRUE)
Error in dimnames(x) <- dn : 
  length of 'dimnames' [2] not equal to array extent
```

I have attached the smallest dataset I am running this on. Any help would be greatly appreciated. Fyi, this is data from a highly clonal plant where we expect no population differentiation.

Thank you for your time and advice,

Elliot Weidow



Here is a sample of what I have been doing:

```r
> collected <- read.genalex("DataBinaryT-seasons-justV.csv")
Warning messages:
1: In df2genind(gena, ind.names = ind.vec, pop = pop.vec, ploidy = ploidy,  :
  character '.' detected in names of loci; replacing with '_'
2: In df2genind(gena, ind.names = ind.vec, pop = pop.vec, ploidy = ploidy,  :
  non-polymorphic marker(s) deleted

> collected

This is a genclone object
-------------------------
Genotype information:

   19 original multilocus genotypes 
   27 diploid individuals
   57 dominant loci

Population information:

    1 stratum - Pop
    3 populations defined - 2, 3, 4
> neicollected    <- nei.dist(collected)
> neicollected
```

(I have omitted the tree generating script, but they run fine)

```r
> aboot(collected, dist = provesti.dist, sample = 200, tree = "nj", cutoff = 50, quiet = TRUE)
Error in dimnames(x) <- dn : 
  length of 'dimnames' [2] not equal to array extent
```




Also, here is my session data:

```r
> sessionInfo()
R version 3.4.2 (2017-09-28)
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows >= 8 x64 (build 9200)

Matrix products: default

locale:
[1] LC_COLLATE=English_United States.1252  LC_CTYPE=English_United States.1252    LC_MONETARY=English_United States.1252
[4] LC_NUMERIC=C                           LC_TIME=English_United States.1252    

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] magrittr_1.5   ape_5.0        mmod_1.3.3     poppr_2.8.0    adegenet_2.1.1 ade4_1.7-10   

loaded via a namespace (and not attached):
 [1] polysat_1.7-2     phangorn_2.4.0    gtools_3.5.0      reshape2_1.4.3    splines_3.4.2     lattice_0.20-35   colorspace_1.3-2 
 [8] expm_0.999-2      htmltools_0.3.6   yaml_2.1.18       mgcv_1.8-20       pegas_0.10        rlang_0.2.0       pillar_1.2.1     
[15] glue_1.2.0        sp_1.2-7          bindrcpp_0.2      bindr_0.1.1       plyr_1.8.4        stringr_1.3.0     munsell_0.4.3    
[22] gtable_0.2.0      coda_0.19-1       permute_0.9-4     httpuv_1.3.6.2    parallel_3.4.2    spdep_0.7-4       Rcpp_0.12.16     
[29] xtable_1.8-2      scales_0.5.0      gdata_2.18.0      vegan_2.4-5       mime_0.5          deldir_0.1-14     fastmatch_1.1-0  
[36] ggplot2_2.2.1     digest_0.6.15     stringi_1.1.7     gmodels_2.16.2    dplyr_0.7.4       shiny_1.0.5       grid_3.4.2       
[43] quadprog_1.5-5    tools_3.4.2       LearnBayes_2.15.1 lazyeval_0.2.1    tibble_1.4.2      cluster_2.0.6     seqinr_3.4-5     
[50] pkgconfig_2.0.1   MASS_7.3-47       Matrix_1.2-11     spData_0.2.8.3    assertthat_0.2.0  R6_2.2.2          boot_1.3-20      
[57] igraph_1.2.1      nlme_3.1-131      compiler_3.4.2   
```