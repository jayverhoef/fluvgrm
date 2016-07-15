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
#' @param strLwd: line width for streams.  Ignored if addFuncColName is used.
#' @param ... other arguments passed from the points function
#'
#' @seealso \code{\link{plotPointsRGB}}, \code{\link{rect}}, 

#' @return a map of a SpatialStreamNetwork object using sp plotting functions.
#'
#' @author Jay Ver Hoef
#' @rdname plotSSN
#' @export plotSSN 



plotSSN <- function(x, VariableName = NULL, addFuncColName = NULL, 
  nbrks = 8, strCol = 'blue', strLwd = NULL, ...) 
{
  par(mar = c(0,0,0,0))
  layout(matrix(1:2, nrow = 1), width = c(4,1))
  SPDF = as.SpatialPointsDataFrame(x)
  SLDF = as.SpatialLinesDataFrame(x)
  if(!is.null(addFuncColName)) {
    strLwd = 0.3+3*SLDF@data[,addFuncColName]} else {
    if(!is.null(strLwd)) strLwd = 1}
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


