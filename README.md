[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)

[![minimal R version](https://img.shields.io/badge/R%3E%3D-3.1.1-6666ff.svg)](https://cran.r-project.org/) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/kotzeb0912)](https://cran.r-project.org/package=kotzeb0912) [![packageversion](https://img.shields.io/badge/Package%20version-1.0-orange.svg?style=flat-square)](commits/master)

[![Last-changedate](https://img.shields.io/badge/last%20change-2016--07--15-yellowgreen.svg)](/commits/master)

# fluvgrm 
## An R package in support of publication, "The Torgegram for Fluvial Variography: Characterizing Spatial Dependence on Stream Networks." 

#### Jay M. Ver Hoef<sup>a</sup> and Dale. L. Zimmerman<sup>b</sup>

#### <sup>a</sup>NOAA Fisheries (NMFS) Alaska Fisheries Science Center, and 
#### <sup>b</sup>Department of Statistics and Actuarial Science, University of Iowa

As a scientific work, and in keeping with common scientific practicies, we kindly request that you cite our research project and applicable publications if you use our work(s) or data in your publications or presentations. Additionally, we strongly encourage and welcome collaboration to promote use of these data in the proper context and scope.  The publication is currently in revision:

#### Zimmerman, Dale L. and Ver Hoef, Jay. M. The Torgegram for Fluvial Variography: Characterizing Spatial Dependence on Stream Networks. In revision to *Journal of Computational and Graphical Statistics*.


Executive Summary
-----------------

We introduce a graphical diagnostic called the Torgegram for characterizing the spatial dependence among observations of a variable on a stream network. The Torgegram consists of four component empirical semivariograms, each one corresponding to a particular combination of flow-connectedness within the network and model type (tail-up/tail-down). We show how an overall strategy for fluvial variography can be based on a careful examination of the Torgegram. An analysis of water temperature data from a stream network within the Columbia River basin of the northwest United States illustrates the diagnostic value of the Torgegram as well as its limitations. Additional uses and extensions of the Torgegram are discussed.

Installation
------------

Installation of this R data package is done through the `devtools::install_github()` function or by downloading the [source package from the latest release](https://github.com/jayverhoef/fluvgrm).

```
library("devtools")
install_github("jayverhoef/fluvgrm")
```
Also, the core Torgegram functions have been incorporated in the SSN package, so that needs to be downloaded from CRAN.

```
#install.packages("SSN")
# temporarily, use development version on my github site
install_github("jayverhoef/SSN")
```
We also like the color palette provided by viridis, so that package should be downloaded to run scripts without any modifications.

```
library(fluvgrm)
install.packages("viridis")
```

Examine the Example Data
------------------------

The help file for the example data set can found by typing

```
help(LewWillCol.ssn)
```
in R.  The scripts below show how to import it and obtain results in the paper.

Run R Scripts
-------------

*Real Data*

After all packages are installed, the script used to access the data and create Figures 4 (enhanced with color), 5, and 6 is the file 'realDataFigures.R' in the scripts folder.  To see where that is in your file system use:

```
system.file("scripts/realDataFigures.R", package = "fluvgrm")
```

To run the whole script from within R use:

```
source(system.file("scripts/realDataFigures.R", package = "fluvgrm"))
```

Figures 5 and 6 are stored on the R temp directory, which can be found with

```
tempdir()
```

and you can navigate to it in your file system to see the pdfs that were created.  Figure 5 on the raw temperature data is named "FCFUtemp.pdf," and Figure 6 on the residuals is names "FCFUresid.pdf."

-------------
*Simulation Figure*

The script used to access the data and create Figure 2 is the file 'simulationFigures.R' in the scripts folder.  To see where that is in your file system use:

```
system.file("scripts/simulationFigure.R", package = "fluvgrm")
```

To run the whole script from within R use:

```
source(system.file("scripts/simulationFigure.R", package = "fluvgrm"))
```

Figure 2 is now stored on the R temp directory, which can be found with

```
tempdir()
```

and you can navigate to it in your file system to see the pdf that was created. Figure 2 is named "FCVAvsFCSD4Fig.pdf."

-------------
*Simulation*

The script used to run the simulations that created Figure 2 is called "simulation.R in the scripts folder.  To see where that is in your file system use:

```
system.file("scripts/simulation.R", package = "fluvgrm")
```
It takes a while to run the 5,000 simulations, so they are stored in the package as data.  To see how to access the simulation data, examine the script on how the figure is created.  The simulation script uses `set.seed(2)` so the results should be completely reproducible.

-------------
##### Disclaimer

<sub>This repository is a scientific product and is not official communication of the Alaska Fisheries Science Center, the National Oceanic and Atmospheric Administration, or the United States Department of Commerce. All AFSC Marine Mammal Laboratory (AFSC-MML) GitHub project code is provided on an ‘as is’ basis and the user assumes responsibility for its use. AFSC-MML has relinquished control of the information and no longer has responsibility to protect the integrity, confidentiality, or availability of the information. Any claims against the Department of Commerce or Department of Commerce bureaus stemming from the use of this GitHub project will be governed by all applicable Federal law. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by the Department of Commerce. The Department of Commerce seal and logo, or the seal and logo of a DOC bureau, shall not be used in any manner to imply endorsement of any commercial product or activity by DOC or the United States Government.</sub>
