#------------------------------------------------------------------------------
# libraries
#------------------------------------------------------------------------------
library("SSN")
library('fluvgrm')

simTU <- importSSN(system.file("lsndata/simTU.ssn", 
	package = "fluvgrm"), o.write = TRUE)

# note, simulation code is included for reproducibility
# however, the results are stored as well
# so it is possible to just skip to graphics part of script

#------------------------------------------------------------------------------
#           Simulate Network
#------------------------------------------------------------------------------

# stream network originally created using these commands
# setwd('/home/jay/Data/fluvgrm/fluvgrm/inst/lsndata')
# set.seed(1)
# simTU <- createSSN(n = 500,
#   obsDesign = binomialDesign(400),
#   importToR = TRUE, path = "simTU.ssn",
#   treeFunction = iterativeTreeLayout)
# createDistMat(simTU)
# it takes a few minutes to create.  Instead, you can
# import the object as stored in the package
# load the SpatialStreamNetwork object
# simTU <- importSSN(system.file("lsndata/simTU.ssn", 
#	package = "fluvgrm"), o.write = TRUE)
# now plot it
# plotSSN(simTU, pch = 19, cex = .7,
#   addFuncColName = 'addfunccol')

#------------------------------------------------------------------------------
#       Graphics
#------------------------------------------------------------------------------

# skip all of the simulations and just use stored data
data(storeFCWA)
data(storeFCSD)
data(FCWA)
data(FCSD)
# combine the data for plotting with boxplots
alldat = NULL
for(i in 1:length(FCWA[,1])) alldat = rbind(alldat,
  data.frame(type = 'FCWA', dist = FCWA[i,'meanDist'], 
    svgm = storeFCWA[i,]),
  data.frame(type = 'FCSD', dist = FCWA[i,'meanDist'], 
    svgm = storeFCSD[i,]))

SLDF = as.SpatialLinesDataFrame(simTU)
SPDF = as.SpatialPointsDataFrame(simTU)

# set the working directory to save the figure
setwd(tempdir())
getwd()

# create plot
pdf('FCWAvsFCSD4Fig.pdf', height = 8, width = 14)

  layout(matrix(1:2, nrow = 1), widths = c(1,2.5))

  par(mar = c(0,0,0,0))
  plot(SLDF, asp = .65)
  plot(SPDF, add =TRUE, pch = 19, cex = 1)

  par(mar = c(5,5,1,1))
  boxplot(svgm ~ type + dist, data = alldat, col = c('white','grey70'),
	  at = sort(c(1:11,(1:11)+.3)), boxwex = .25, xaxt = 'n', cex.lab = 2,
	  ylab = 'Semivariogram', pch = 1, cex.axis = 1.5, ylim = c(-5,10))
  points(1:11,apply(storeFCWA,1,mean), pch = 19)
  points((1:11)+.3,apply(storeFCSD,1,mean), pch = 19)
  legend(.2,-2.5, legend = c('FCWA','FCSD'), pch = c(22,15), 
	  col = c('black','grey70'), cex = 2)
  axis(side=1, (1:11)+.15, labels=as.character(round(FCWA[1:11,'meanDist'],1)), 
    cex.axis = 1.5)
  mtext('Mean Lag Distance', side=1, cex = 2, padj = 2.5) 
  lines(c(0,30),c(1,1), lty = 2)

dev.off()

