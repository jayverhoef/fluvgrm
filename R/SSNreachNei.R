#-------------------------------------------------------------------------------
#
#           SSNreachNei
#
#-------------------------------------------------------------------------------

#' Function for finding neighboring reaches in SpatialStreamNetwork Objects
#'
#' Function for finding neighboring reaches in SpatialStreamNetwork Objects
#'
#' @param object an object of class \code{\link[=SpatialStreamNetwork-class]{SpatialStreamNetwork}}.
 
#' @return a sparse matrix with indicators of neighboring reaches.  
#' The rownames and column names are included, and match those from the 
#' rownames of the reaches in the \code{\link[=SpatialStreamNetwork-class]{SpatialStreamNetwork}} object.
#'
#' @author Jay Ver Hoef
#' @export

SSNreachNei = function(object)
{
  liNeighFun = function(x, SL) {
      rgeos::gTouches(SpatialLines(list(x)), spgeom2 = SL, byid = TRUE)
    }
  SL = as.SpatialLines(object)
  SLlist = SL@lines
  ReachNei = sapply(SLlist, liNeighFun, SL = SL)
  colnames(ReachNei) = object@data$rid
  rownames(ReachNei) = object@data$rid
  ReachNei = Matrix::Matrix(ReachNei, sparse = TRUE)
}
