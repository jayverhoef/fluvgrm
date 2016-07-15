# fluvgrm: An R package in support of publication by Zimmerman and Ver Hoef, "The Torgegram for Fluvial Variography: Characterizing Spatial Dependence on Stream Networks," in revision to Journal of Computational and Graphical Statistics.

#### Jay M. Ver Hoef and Dale. L. Zimmerman

#### NOAA Fisheries (NMFS) Alaska Fisheries Science Center and Department of Statistics and Actuarial Science, University of Iowa

As a scientific work, an in keeping with common scientific practicies, we kindly request that you cite our research project and applicable publications if you use our work(s) or data in your publications or presentations. Additionally, we strongly encourage and welcome collaboration to promote use of these data in the proper context and scope.

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
