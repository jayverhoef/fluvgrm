#------------------------------------------------------------------------------
# libraries
#------------------------------------------------------------------------------
library('SSN')
library('fluvgrm')
library('viridis')

#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
# SCRIPT
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------

# load the SpatialStreamNetwork object
SSN4 <- importSSN(system.file("lsndata/LewWillCol.ssn", 
	package = "fluvgrm"), o.write = TRUE)

# pull out the data.frame of observed data
DF = getSSNdata.frame(SSN4)
# fit a classical regression model to the observed data
lmout = lm(STREAM_AUG ~ upDist + upDist:upDist + ELEV + ELEV:ELEV, 
    data = DF)
# compute residuals on the fitted model and add to data.frame
DF[,'resid'] = residuals(lmout)
# put the data.frame back into the SpatialStreamNetwork object
SSN4 = putSSNdata.frame(DF, SSN4)

#------------------------------------------------------------------------------
#  plot the SpatialStreamNetwork object and color response variable
#------------------------------------------------------------------------------
  plotSSN(SSN4, VariableName = 'resid', pch = 19, cex = 1.2,
    addFuncColName = 'afvArea', strCol = 'grey50')

# to create the neighborhood matrix from scratch, use the following command
# Mat = SSNreachNei(SSN4)
# however, it takes a long time, so it is stored as part of the package and
# can be loaded directly
load(system.file("/lsndata/reachnei/neiMatrix-72.Rdata", 
	package = "fluvgrm"))

# set some of the arguments for the variogram functions
nbrksfc = 12
maxbrksfc = 2.3e+05
nbrksfu = 18
maxbrksfu = 3.5e+05
fcbrks = c(-.001, (1:nbrksfc)/nbrksfc*maxbrksfc)
fubrks = c(-.001, (1:nbrksfu)/nbrksfu*maxbrksfu)

# set the working directory to R's temp directory to save figures
setwd(tempdir())
# to see where this is on your file system
getwd()
# the figures will go away with the temp directory when R quits

#------------------------------------------------------------------------------
#      create pdf figure in current working directory
#------------------------------------------------------------------------------

# compute the various variograms
FUSDout = FUSD(SSN4, 'resid', breaks = fubrks) 
svgmbar = function(x) {sum(x$np*x$semivar)/sum(x$np)}
FUSDbar = svgmbar(FUSDout[[1]][[1]])
FUDJout = FUDJ(SSN4, 'resid', breaks = fubrks[1:10])
FCSDout = FCSD(SSN4, 'resid', breaks = fcbrks)
FCSD01out = FCSD01(SSN4, 'resid', 
  breaks = c(0, 600, 1200, 3000, 10000),
  ReachNei = Mat)

pdf('FCFUresid.pdf', height = 12, width = 12)
        layout(matrix(1:4, nrow = 2, byrow = TRUE))
        # part A
        npWtStd = 1 + (FUSDout[[1]][[1]]$np - min(FUSDout[[1]][[1]]$np))/
          (max(FUSDout[[1]][[1]]$np) - min(FUSDout[[1]][[1]]$np))
        par(mar = c(5,5,5,2))
        plot(FUSDout[[1]][[1]]$brkDist,FUSDout[[1]][[1]]$semivar, 
          ylim = c(0,1.05*max(FUSDout[[1]][[1]]$semivar)),
          xlim = c(0,1.05*max(FUSDout[[1]][[1]]$brkDist)),
          pch = 19, cex = 4*npWtStd, xlab = 'Flow-Unconnected Distance',
          ylab = 'Semivariance', cex.lab = 2, cex.axis = 1.5)
        lines(c(min(FUSDout[[1]][[1]]$brkDist),max(FUSDout[[1]][[1]]$brkDist)),
          rep(FUSDbar, times =2), lty = 2, col = 'grey60', lwd = 3)
        mtext('A', cex = 4, adj = -.18, padj = -.4)
        #part B
        clrClasses = c('#f0f0f0','#d9d9d9',
        '#bdbdbd','#969696','#737373','#525252','#252525')
        clrBrks = min(FUDJout[[1]][[1]]$semivar) + (0:length(clrClasses))*
          (max(FUDJout[[1]][[1]]$semivar) - min(FUDJout[[1]][[1]]$semivar))/
          length(clrClasses)
        clrBrks[1] = clrBrks[1] - 1e-5
        clrBrks[length(clrClasses) + 1] = clrBrks[length(clrClasses) + 1] + 1e-5
        npWtStd = 1 + (FUDJout[[1]][[1]]$np - min(FUDJout[[1]][[1]]$np))/
          (max(FUDJout[[1]][[1]]$np) - min(FUDJout[[1]][[1]]$np))
        par(mar = c(5,5,5,2))
        plot(FUDJout[[1]][[1]]$distShrt, FUDJout[[1]][[1]]$distLong, type = 'n', 
          xlim = c(0, max(FUDJout[[1]][[1]]$distLong)),
          ylim = c(0, max(FUDJout[[1]][[1]]$distLong)),
          col = clrClasses[as.integer(cut(FUDJout[[1]][[1]]$semivar, clrBrks))],
          xlab = 'Shorter Distance to Common Junction',
          ylab = 'Longer Distance to Common Junction',
          cex.lab = 2, cex.axis = 1.2
        )
        for(i in 1:(2*length(FUSDout[[1]][[1]][,1]))) {
          iinc = i*max(FUDJout[[1]][[1]]$distLong)/length(FUSDout[[1]][[1]][,1])
          lines(c(0,iinc),c(iinc,0), lty = 2, col = 'grey60')
        }
        points(FUDJout[[1]][[1]]$distShrt, FUDJout[[1]][[1]]$distLong, pch = 19,
          cex = 3*npWtStd, 
          col = clrClasses[as.integer(cut(FUDJout[[1]][[1]]$semivar, clrBrks))])
        points(FUDJout[[1]][[1]]$distShrt, FUDJout[[1]][[1]]$distLong, pch = 1,
          cex = 3*npWtStd, lwd = 2)
        xyleg = min(FUDJout[[1]][[1]]$distLong) + (max(FUDJout[[1]][[1]]$distLong) - 
          min(FUDJout[[1]][[1]]$distLong))/2
        xylen = max(FUDJout[[1]][[1]]$distLong)
        legWidth = (max(FUDJout[[1]][[1]]$distLong) - 
          min(FUDJout[[1]][[1]]$distLong))/10
        addBreakColorLegend(.7*xylen,0,.7*xylen+legWidth,.6*xylen, clrBrks, clrClasses, 
          '1.2', cex = 1.4)
        mtext('B', cex = 4, adj = -.18, padj = -.4)
        # part C
        npWtStd = 1 + (FCSDout[[1]][[1]]$np - min(FCSDout[[1]][[1]]$np))/
          (max(FCSDout[[1]][[1]]$np) - min(FCSDout[[1]][[1]]$np))
        par(mar = c(5,5,5,2))
        plot(FCSDout[[1]][[1]]$brkDist,FCSDout[[1]][[1]]$semivar,
          ylim = c(0,1.05*max(FCSDout[[1]][[1]]$semivar)), 
          xlim = c(0,1.05*max(FCSDout[[1]][[1]]$brkDist)),
          pch = 19, cex = 2*npWtStd, xlab = 'Flow-Connected Distance',
          ylab = 'Semivariance', cex.lab = 2, cex.axis = 1.5)
        mtext('C', cex = 4, adj = -.18, padj = -.4)
        # part D
        par(mar = c(5,5,5,2))
        plot(c(FCSD01out[[1]][['72']]$svgm0$brkDist,
            FCSD01out[[1]][['72']]$svgm1$brkDist),
          c(FCSD01out[[1]][['72']]$svgm0$semivar,
            FCSD01out[[1]][['72']]$svgm1$semivar), type = 'n',
          xlim = c(0,max(c(FCSD01out[[1]][['72']]$svgm0$brkDist,
            FCSD01out[[1]][['72']]$svgm1$brkDist))*1.1),
          ylim = c(0,max(c(FCSD01out[[1]][['72']]$svgm0$semivar,
            FCSD01out[[1]][['72']]$svgm1$semivar))*1.1),
          xlab = 'Flow-Connected Distance',
          ylab = 'Semivariance', cex.lab = 2, cex.axis = 1.5)
        npWtStd = 1 + (FCSD01out[[1]][['72']]$svgm1$np - 
          min(FCSD01out[[1]][['72']]$svgm0$np))/
          (max(FCSD01out[[1]][['72']]$svgm0$np) - 
           min(FCSD01out[[1]][['72']]$svgm0$np))
        points(FCSD01out[[1]][['72']]$svgm1$brkDist,
          FCSD01out[[1]][['72']]$svgm1$semivar, 
          pch = 19, cex = 2*npWtStd, col = '#bdbdbd')
        text(FCSD01out[[1]][['72']]$svgm1$brkDist,
          FCSD01out[[1]][['72']]$svgm1$semivar,
          labels = as.character(FCSD01out[[1]][['72']]$svgm1$np), 
          pos = 2, cex = 2.5, offset = .7)
        npWtStd = 1 + (FCSD01out[[1]][['72']]$svgm0$np - 
          min(FCSD01out[[1]][['72']]$svgm0$np))/
          (max(FCSD01out[[1]][['72']]$svgm0$np) - 
          min(FCSD01out[[1]][['72']]$svgm0$np))
        points(FCSD01out[[1]][['72']]$svgm0$brkDist, 
          FCSD01out[[1]][['72']]$svgm0$semivar,
          pch = 19, cex = 2*npWtStd)
        text(FCSD01out[[1]][['72']]$svgm0$brkDist,
          FCSD01out[[1]][['72']]$svgm0$semivar,
          labels = as.character(FCSD01out[[1]][['72']]$svgm0$np), 
          pos = 4, cex = 2.5, offset = .7)
        legend(max(c(FCSD01out[[1]][['72']]$svgm0$brkDist,
          FCSD01out[[1]][['72']]$svgm1$brkDist))*1.1, xjust = 1,
            0, yjust = 0,
            pch = c(19,19), col = c('black','#bdbdbd'), 
            legend = c('FCSD(0)','FCSD(1)'), lwd = c(3,3),
            cex = 2, lty = c(0,0))
        mtext('D', cex = 4, adj = -.18, padj = -.4)
dev.off()

#------------------------------------------------------------------------------
#      create pdf figure in current working directory
#------------------------------------------------------------------------------

# compute the various variograms
FUSDout = FUSD(SSN4, 'STREAM_AUG', breaks = fubrks) 
svgmbar = function(x) {sum(x$np*x$semivar)/sum(x$np)}
FUSDbar = svgmbar(FUSDout[[1]][[1]])
FUDJout = FUDJ(SSN4, 'STREAM_AUG', breaks = fubrks[1:10])
FCSDout = FCSD(SSN4, 'STREAM_AUG', breaks = fcbrks)
FCSD01out = FCSD01(SSN4, 'STREAM_AUG', 
  breaks = c(0, 600, 1200, 3000, 10000),
  ReachNei = Mat)

pdf('FCFUtemp.pdf', height = 12, width = 12)
        layout(matrix(1:4, nrow = 2, byrow = TRUE))
        # part A
        npWtStd = 1 + (FUSDout[[1]][[1]]$np - min(FUSDout[[1]][[1]]$np))/
          (max(FUSDout[[1]][[1]]$np) - min(FUSDout[[1]][[1]]$np))
        par(mar = c(5,5,5,2))
        plot(FUSDout[[1]][[1]]$brkDist,FUSDout[[1]][[1]]$semivar, 
          ylim = c(0,1.05*max(FUSDout[[1]][[1]]$semivar)),
          xlim = c(0,1.05*max(FUSDout[[1]][[1]]$brkDist)),
          pch = 19, cex = 4*npWtStd, xlab = 'Flow-Unconnected Distance',
          ylab = 'Semivariance', cex.lab = 2, cex.axis = 1.5)
        lines(c(min(FUSDout[[1]][[1]]$brkDist),max(FUSDout[[1]][[1]]$brkDist)),
          rep(FUSDbar, times =2), lty = 2, col = 'grey60', lwd = 3)
        mtext('A', cex = 4, adj = -.18, padj = -.4)
        #part B
        clrClasses = c('#f0f0f0','#d9d9d9',
        '#bdbdbd','#969696','#737373','#525252','#252525')
        clrBrks = min(FUDJout[[1]][[1]]$semivar) + (0:length(clrClasses))*
          (max(FUDJout[[1]][[1]]$semivar) - min(FUDJout[[1]][[1]]$semivar))/
          length(clrClasses)
        clrBrks[1] = clrBrks[1] - 1e-5
        clrBrks[length(clrClasses) + 1] = clrBrks[length(clrClasses) + 1] + 1e-5
        npWtStd = 1 + (FUDJout[[1]][[1]]$np - min(FUDJout[[1]][[1]]$np))/
          (max(FUDJout[[1]][[1]]$np) - min(FUDJout[[1]][[1]]$np))
        par(mar = c(5,5,5,2))
        plot(FUDJout[[1]][[1]]$distShrt, FUDJout[[1]][[1]]$distLong, type = 'n', 
          xlim = c(0, max(FUDJout[[1]][[1]]$distLong)),
          ylim = c(0, max(FUDJout[[1]][[1]]$distLong)),
          col = clrClasses[as.integer(cut(FUDJout[[1]][[1]]$semivar, clrBrks))],
          xlab = 'Shorter Distance to Common Junction',
          ylab = 'Longer Distance to Common Junction',
          cex.lab = 2, cex.axis = 1.2
        )
        for(i in 1:(2*length(FUSDout[[1]][[1]][,1]))) {
          iinc = i*max(FUDJout[[1]][[1]]$distLong)/length(FUSDout[[1]][[1]][,1])
          lines(c(0,iinc),c(iinc,0), lty = 2, col = 'grey60')
        }
        points(FUDJout[[1]][[1]]$distShrt, FUDJout[[1]][[1]]$distLong, pch = 19,
          cex = 3*npWtStd, 
          col = clrClasses[as.integer(cut(FUDJout[[1]][[1]]$semivar, clrBrks))])
        points(FUDJout[[1]][[1]]$distShrt, FUDJout[[1]][[1]]$distLong, pch = 1,
          cex = 3*npWtStd, lwd = 2)
        xyleg = min(FUDJout[[1]][[1]]$distLong) + (max(FUDJout[[1]][[1]]$distLong) - 
          min(FUDJout[[1]][[1]]$distLong))/2
        xylen = max(FUDJout[[1]][[1]]$distLong)
        legWidth = (max(FUDJout[[1]][[1]]$distLong) - 
          min(FUDJout[[1]][[1]]$distLong))/10
        addBreakColorLegend(.7*xylen,0,.7*xylen+legWidth,.6*xylen, clrBrks, clrClasses, 
          '1.2', cex = 1.4)
        mtext('B', cex = 4, adj = -.18, padj = -.4)
        # part C
        npWtStd = 1 + (FCSDout[[1]][[1]]$np - min(FCSDout[[1]][[1]]$np))/
          (max(FCSDout[[1]][[1]]$np) - min(FCSDout[[1]][[1]]$np))
        par(mar = c(5,5,5,2))
        plot(FCSDout[[1]][[1]]$brkDist,FCSDout[[1]][[1]]$semivar,
          ylim = c(0,1.05*max(FCSDout[[1]][[1]]$semivar)), 
          xlim = c(0,1.05*max(FCSDout[[1]][[1]]$brkDist)),
          pch = 19, cex = 2*npWtStd, xlab = 'Flow-Connected Distance',
          ylab = 'Semivariance', cex.lab = 2, cex.axis = 1.5)
        mtext('C', cex = 4, adj = -.18, padj = -.4)
        # part D
        par(mar = c(5,5,5,2))
        plot(c(FCSD01out[[1]][['72']]$svgm0$brkDist,
            FCSD01out[[1]][['72']]$svgm1$brkDist),
          c(FCSD01out[[1]][['72']]$svgm0$semivar,
            FCSD01out[[1]][['72']]$svgm1$semivar), type = 'n',
          xlim = c(0,max(c(FCSD01out[[1]][['72']]$svgm0$brkDist,
            FCSD01out[[1]][['72']]$svgm1$brkDist))*1.1),
          ylim = c(0,max(c(FCSD01out[[1]][['72']]$svgm0$semivar,
            FCSD01out[[1]][['72']]$svgm1$semivar))*1.1),
          xlab = 'Flow-Connected Distance',
          ylab = 'Semivariance', cex.lab = 2, cex.axis = 1.5)
        npWtStd = 1 + (FCSD01out[[1]][['72']]$svgm1$np - 
          min(FCSD01out[[1]][['72']]$svgm0$np))/
          (max(FCSD01out[[1]][['72']]$svgm0$np) - 
           min(FCSD01out[[1]][['72']]$svgm0$np))
        points(FCSD01out[[1]][['72']]$svgm1$brkDist,
          FCSD01out[[1]][['72']]$svgm1$semivar, 
          pch = 19, cex = 2*npWtStd, col = '#bdbdbd')
        text(FCSD01out[[1]][['72']]$svgm1$brkDist,
          FCSD01out[[1]][['72']]$svgm1$semivar,
          labels = as.character(FCSD01out[[1]][['72']]$svgm1$np), 
          pos = 2, cex = 2.5, offset = .7)
        npWtStd = 1 + (FCSD01out[[1]][['72']]$svgm0$np - 
          min(FCSD01out[[1]][['72']]$svgm0$np))/
          (max(FCSD01out[[1]][['72']]$svgm0$np) - 
          min(FCSD01out[[1]][['72']]$svgm0$np))
        points(FCSD01out[[1]][['72']]$svgm0$brkDist, 
          FCSD01out[[1]][['72']]$svgm0$semivar,
          pch = 19, cex = 2*npWtStd)
        text(FCSD01out[[1]][['72']]$svgm0$brkDist,
          FCSD01out[[1]][['72']]$svgm0$semivar,
          labels = as.character(FCSD01out[[1]][['72']]$svgm0$np), 
          pos = 4, cex = 2.5, offset = .7)
        legend(max(c(FCSD01out[[1]][['72']]$svgm0$brkDist,
          FCSD01out[[1]][['72']]$svgm1$brkDist))*1.1, xjust = 1,
            0, yjust = 0,
            pch = c(19,19), col = c('black','#bdbdbd'), 
            legend = c('FCSD(0)','FCSD(1)'), lwd = c(3,3),
            cex = 2, lty = c(0,0))
        mtext('D', cex = 4, adj = -.18, padj = -.4)
dev.off()


