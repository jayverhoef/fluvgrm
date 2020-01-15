#-------------------------------------------------------------------------------
#
#           plotSSN
#
#-------------------------------------------------------------------------------

#' Plotting Function for SpatialStreamNetwork Objects
#'
#' Plotting Function for SpatialStreamNetwork Objects
#'
#' @param x an object of class \code{\link[=SpatialStreamNetwork-class]{SpatialStreamNetwork}}.
#' @param VariableName a response variable name in the data.frame of observed data in the SpatialStreamNetwork object.
#' @param addFuncColName the additive function column name in the data.frame of lines data in the SpatialStreamNetwork object.  The size of the streams are scaled by this column. If NULL (default) all lines are are same size.
#' @param nbrks the number of classes for coloring the predictions (or standard errors) according to their value.  The default is 8.
#' @param strCol color of the stream lines. Default is 'blue'.
#' @param strLwd line width for streams.  Ignored if addFuncColName is used.
#' @param ... other arguments passed from the \code{\link{points}} function
 
#' @return a map of a SpatialStreamNetwork object using sp plotting functions.
#'
#' @author Jay Ver Hoef
#' @export
#' @examples
#' SSN4 <- importSSN(system.file("lsndata/LewWillCol.ssn", 
#'	 package = "fluvgrm"), o.write = TRUE)
#' # default plot with blue lines for stream segments and
#' # black + for data locations
#' plotSSN(SSN4)
#' # plot with response variable colored by value
#' plotSSN(SSN4, VariableName = 'STREAM_AUG', pch = 19, cex = 1.2,
#'   addFuncColName = 'afvArea', strCol = 'grey50')
#' # to run a script that will create Fig. 4-6 in the Zimmerman and
#' # Ver Hoef paper "The Torgegram for Fluvial Variography: Characterizing
#' # Spatial Dependence on Stream Networks" navigate to the script on your
#' # computer found here:
#' system.file("scripts/realDataFigures.R", package = "fluvgrm")
#' # if you run it from source,
#' source(system.file("scripts/realDataFigures.R", package = "fluvgrm"))
#' # Figures 5 and 6 are stored on the R temp directory, 
#' # which can be found with
#' tempdir()
#' # and you can navigate to it in your file system to see the pdfs
#' # that were created. Figure 5 on the raw temperature data is named 
#' # "FCFUtemp.pdf," and Figure 6 on the residuals is names "FCFUresid.pdf."
#' # The script used to access the data and create Figure 2 is the file 
#' # "simulationFigures.R" in the scripts folder. To see where that is 
#' # in your file system use:
#' system.file("scripts/simulationFigure.R", package = "fluvgrm")
#' # To run the whole script from within R use:
#' source(system.file("scripts/simulationFigure.R", package = "fluvgrm"))
#' # Figure 2 is now stored on the R temp directory, which can be found with
#' tempdir()
#' # and you can navigate to it in your file system to see the pdf that was 
#' # created. Figure 2 is named "FCVAvsFCSD4Fig.pdf."

plotSSN <- function(x, VariableName = NULL, addFuncColName = NULL, 
  nbrks = 8, strCol = 'blue', strLwd = NULL, ...) 
{
  par(mar = c(0,0,0,0))
  if(!is.null(VariableName))
    layout(matrix(1:2, nrow = 1), widths = c(4,1))
  SPDF = as.SpatialPointsDataFrame(x)
  SLDF = as.SpatialLinesDataFrame(x)
  if(!is.null(addFuncColName)) {
    strLwd = 0.3+3*SLDF@data[,addFuncColName]} else {
    if(is.null(strLwd)) strLwd = 1}
  plot(SLDF, lwd = strLwd, col = strCol)
  if(is.null(VariableName)) {plot(SPDF, add = TRUE, ...)} else
  {
  DF = SPDF@data
  breaks = c(min(DF[,VariableName], na.rm = TRUE)-1e-10,
    quantile(DF[,VariableName],(1:(nbrks - 1))/nbrks, na.rm = TRUE),
    max(DF[,VariableName], na.rm = TRUE)+1e-10)
  colrs = viridis(nbrks)
  for(i in 1:nbrks)
    points(SPDF[DF[,VariableName] >= breaks[i] & 
      DF[,VariableName] < breaks[i+1] & !is.na(DF[,VariableName]),],
      col = colrs[i], ...)
  }
  plot(c(0,1),c(0,1), type = 'n', xaxt = 'n', yaxt = 'n', bty = 'n',
    xlab = '', ylab = '')
  if(!is.null(VariableName))
     addBreakColorLegend(.1,.15,.5,.85, breaks, colrs)
  if(!is.null(VariableName))
    return(invisible(data.frame(breaks)))
}


