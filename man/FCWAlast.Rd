\name{FCWAlast}
\alias{FCWAlast}
\docType{data}
\title{
 stored data
}
\description{
  Data produced by simulation and stored.
}
\details{
  Data produced by simulation and stored.
}


\examples{
# data produced by the script "simulation.R" located here:
system.file("scripts/simulation.R", package = "fluvgrm")
# The script used to access the data and create Figure 2 is the file
# "simulationFigures.R" in the scripts folder. To see where that is
# in your file system use:
system.file("scripts/simulationFigure.R", package = "fluvgrm")
# To run the whole script from within R use:
source(system.file("scripts/simulationFigure.R", package = "fluvgrm"))
# Figure 2 is now stored on the R temp directory, which can be found with
tempdir()
# and you can navigate to it in your file system to see the pdf that was
# created. Figure 2 is named "FCVAvsFCSD4Fig.pdf."
}
