library("SSN")
library('fluvgrm')

simTU <- importSSN(system.file("lsndata/simTU.ssn", 
	package = "fluvgrm"), o.write = TRUE)

# note, simulation code is included for reproducibility
# however, the results are stored as well
# so it is possible to just skip to graphics

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
#           Set Up the Simulation
#------------------------------------------------------------------------------

# get asymmetric distance matrix
distJunc = getStreamDistMat(simTU)$dist.net1
# create pure stream distance matrix
Ds = distJunc + t(distJunc)
# create binary matrix indicating flow-connected
Fc = 1 - (pmin(distJunc,t(distJunc)) > 0)*1

#get the data.frame for the observed locations so we
# can simulate on it
DF <- getSSNdata.frame(simTU, "Obs")
# create matrix of additive function values for each observation
afvMat = outer(DF[,'addfunccol'], rep(1, times = length(DF[,1])))
#get sample size
ni = length(DF[,1])

# create linear-with-sill covariance matrix
# partial sill of 1, range of 10, and nugget of 0.01
TUcov = (matrix(rep(1, times=ni^2), nrow=ni, ncol=ni) - Ds/10)*(Ds < 10)*
  Fc*sqrt(pmin(afvMat,t(afvMat))/pmax(afvMat,t(afvMat))) + 
  diag(rep(.01, times = ni))
# check to see if positive definite
eigen(TUcov)$values
# create cholesky decomposition for simulation
TUcovL = t(chol(TUcov))

# vectorize flow-connected matrix
Fcv = Fc[lower.tri(Fc)]
# vectorize stream distance matrix
Dsv = Ds[lower.tri(Ds)]
# get additive function values
af = DF[,'addfunccol']
# create matrix of additive function values
afM = af%o%rep(1, times = ni)
# create proportional influence weights
afM = pmin(afM,t(afM))/pmax(afM,t(afM))
#vectorize additive function matrix
afM = afM[lower.tri(afM)]

#------------------------------------------------------------------------------
#           Simulation
#------------------------------------------------------------------------------

# set random number seed for reproducibility
set.seed(2)
# set the breaks
brks = c(2*(0:11) + .00001)
# number of simulations
niter = 5000
# create matrices to store outputs
storeFCVA = matrix(NA, nrow = length(brks) - 1, ncol = niter)
storeFCSD = matrix(NA, nrow = length(brks) - 1, ncol = niter)
# begin simulation
for(i in 1:niter) {
  # simulate data with tail-up stream network correlation structure
  # zero mean expectation
  zs = as.vector(TUcovL %*% rnorm(ni)) 
  # get squared differences among all pairs of points
  df2 <- (abs(zs%o%rep(1, times = ni) - rep(1, times = ni)%o%zs))^2
  # divide by 2 to get semivariances
  df2 = df2[lower.tri(df2)]/2
	# FUSDbar first
  FUSDbar = mean(df2[Fcv == 0])
  # volume-adjusted semivariance values for flow-connected sites
  df2V = (FUSDbar - df2[Fcv == 1])/sqrt(afM[Fcv == 1])
  # unadjusted semivariance values for flow-connected sites
	df2C = df2[Fcv == 1]
  # classify distances into distance bins
	cutvec = cut(Dsv[Fcv == 1], brks)
  # compute volume-adjusted semivariogram by averaging in bins
  FCVA = cbind(
		aggregate(Dsv[Fcv == 1], by = list(cutvec), mean),
		FUSDbar - aggregate(df2V, by = list(cutvec), mean)[2],
	  aggregate(df2V, by = list(cutvec), function(x) {length(x)})[,2]
		)
	colnames(FCVA) = c('distClass','meanDist','FCVA','npair')
  storeFCVA[,i] = FCVA$FCVA
  # compute unadjusted semivariogram by averaging in bins
	FCSD = cbind(
		aggregate(Dsv[Fcv == 1], by = list(cutvec), mean),
		aggregate(df2C, by = list(cutvec), mean)[2],
	  aggregate(df2C, by = list(cutvec), function(x) {length(x)})[,2]
		)
	colnames(FCSD) = c('distClass','meanDist','FCSD','npair')
  storeFCSD[,i] = FCSD$FCSD
}

setwd('/home/jay/Data/fluvgrm/fluvgrm/data')
save(storeFCVA, file = 'storeFCVA.rda')
save(storeFCSD, file = 'storeFCSD.rda')
# store the last iteration just to see how each was saved
# and use bin classes etc. for graphics
save(FCVA, file = 'FCVA.rda')
save(FCSD, file = 'FCSD.rda')


