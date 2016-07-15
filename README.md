# fluvgrm: An R package in support of publication, "The Torgegram for Fluvial Variography: Characterizing Spatial Dependence on Stream Networks." 

#### Jay M. Ver Hoef and Dale. L. Zimmerman

#### NOAA Fisheries (NMFS) Alaska Fisheries Science Center and Department of Statistics and Actuarial Science, University of Iowa

As a scientific work, and in keeping with common scientific practicies, we kindly request that you cite our research project and applicable publications if you use our work(s) or data in your publications or presentations. Additionally, we strongly encourage and welcome collaboration to promote use of these data in the proper context and scope.  The publication is currently in revision:

Zimmerman, Dale L. and Ver Hoef, Jay. M. The Torgegram for Fluvial Variography: Characterizing Spatial Dependence on Stream Networks. In revision to *Journal of Computational and Graphical Statistics*.


Executive Summary
-----------------

We introduce a graphical diagnostic called the Torgegram for characterizing the spatial dependence among observations of a variable on a stream network. The Torgegram consists of four component empirical semivariograms, each one corresponding to a particular combination of flow-connectedness within the network and model type (tail-up/tail-down). We show how an overall strategy for fluvial variography can be based on a careful examination of the Torgegram. An analysis of water temperature data from a stream network within the Columbia River basin of the northwest United States illustrates the diagnostic value of the Torgegram as well as its limitations. Additional uses and extensions of the Torgegram are discussed.

Installation
------------

Installation of this R data package is done through the `devtools::install_github()` function or by downloading the [source package from the latest release](https://github.com/jayverhoef/fluvgrm).

``` r
library("devtools")
install_github("jayverhoef/fluvgrm")
```
Also, the core Torgegram functions have been incorporated in the SSN package, so that needs to be downloaded from CRAN.

``` r
install.packages("SSN")
```
We also like the color palatte provided by viridis, so that package should be downloaded to run scripts without any modifications.

``` r
install.packages("viridis")
```
After all packages are installed, the script used to access the data and create Figures 4 (enhanced with color), 5, and 6 is the file 'realDataFigures.R' in the scripts folder.  You can run the whole script from within R using

```
system.file("scripts/realDataFigures.R", package = "fluvgrm")
```

##### Disclaimer

<sub>This repository is a scientific product and is not official communication of the Alaska Fisheries Science Center, the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. All AFSC Marine Mammal Laboratory (AFSC-MML) GitHub project code is provided on an ‘as is’ basis and the user assumes responsibility for its use. AFSC-MML has relinquished control of the information and no longer has responsibility to protect the integrity, confidentiality, or availability of the information. Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.</sub>
