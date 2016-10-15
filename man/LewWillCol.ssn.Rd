\name{LewWillCol.ssn}
\alias{LewWillCol.ssn}
\docType{data}
\title{
LewWillCol.ssn data folder
}
\description{
  The LewWillCol.ssn data folder contains the spatial, attribute, and topological information needed to construct a spatial stream network object using the SSN package.
}
\details{
  \preformatted{
  The LewWillCol.ssn folder contains two spatial datasets:
    edges:    polyline shapefile representing the stream network
    sites:    point shapefile representing the observed site locations

  There is also 1 text file, netID72.txt, which contains the topological 
  information for the stream network in the Lewis/Willamette rivers in 
  the Columbia basin dataset.

  Attribute data are also stored within each of the spatial datasets. 
  The column names are defined as follows:

  edges:
    COMID:	Common identifier of an NHD feature or relationship
    FDATE:      Feature currency date. This is the date the stream line 
                was initially drawn, or its latest update. 
    RESOLUTION: This differentiates the 1:24k scale from the 1:100k scale 
                NHD. In our case we are using 1:100k, so the field is always 
                populated with "Medium".
    GNIS_ID:	Geographic Names Information System identifier
    GNIS_Name: 	Feature name as found in the Geographic Names Information 
                System
    LENGTHKM:	Length (km)
    REACHCODE:	Unique identifier for a reach. The first 8 digits contain
                the identfier for the HUC8 and the last 6 digits are a
                unique within-HUC8 identifier for the reach
    FLOWDIR:    This is the flow direction. It can have one of two values, 
                WithDigitized or Uninitialized. We only kept WithDigitized 
                after reconditioning. This indicates it's a flowline with 
                flow and direction.
    FCODE:	Numeric code that contains the feature type and it's attributes
    		as found in the NHDFCode lookup table
    CUMDRAINAG: Cumulative drainage area (km2) for the lowermost location on
                the edge
    AREAWTMAP: 	Area weighted mean annual precipitation (mm) at the lowermost
    		location on the edge
    SLOPE:	Slope of the edge (cm/cm)
    h2oAreaKm2: Watershed area (km2) for the lowermost location on the line 
                segment
    rid:        Reach identifier
    upDist:     Distance from the stream outlet (most downstream location in 
                the the stream network) to the uppermost location on the line
                segment
    areaPI:     Segment proportional influence value, calculated using watershed
                area (h2oAreaKm2)
    afvArea:	Additive function value, calculated using areaPI
    netID:	Network identifier
    Length:     Length of line segment (m)


  sites:
    OBSPRED_ID:	Unique ID assigned to each temperature deployment. A deployment
                is a site + year combination of data. Individual sites have 
                multiple deployments when temperature monitoring occurs in more 
                than one year.
    PERMA_FID:	ID given to a single temperature sensor site. A site may contain 
                multiple years of data.
    SAMPLEYEAR: The year that temperature data were recorded at the location.
    SNAP_X:     This is for the observation points only. It's the X coordinate 
                of the point after it was snapped to the NHD network.
    SNAP_Y:     This is for the observation points only. It's the X coordinate 
                of the point after it was snapped to the NHD network.
    STREAM_AUG: mean daily temperature from 1 August - 31 August.  This is the 
                modeled response variable
    ID_1KM:     A unique ID for the 1 km stream segments and corresponding prediction points.
    FTYPE:      This attribute is only for the predicted temperature locations. 
                This attribute is the NHDPlus feature type and can have one of 
                two values, either 'StreamRiver' or 'ArtificialPath'. This is an
                NHDPlus defined attribute.
    WATERBODY:  This attribute is only for the predicted temperature locations. 
                This attribute is for prediction points that fall within an 
                NHDPlus water body feature. Values may be 0 or 1. 1 represents 
                a point or stream segment within a water body feature. This 
                attribute was generated at the Boise Lab to designate line 
                segments that fall within water bodies.
    TAILWATER:  Categorical predictor variable coded as 0/1 to indicate whether 
                a stream temperature site is downstream from a reservoir that 
                creates an anomalously cold tailwater.
    ELEV:       Elevation in meters.
    CANOPY:     Percent canopy for each 1 km stream segment.
    SLOPE:      Slope (rise/run) for each NHDPlus stream reach.
    PRECIP:     NHDPlus precipitation measure (mm)
    CUMDRAINAG:	Cumulative drainage area (sq. km) for each NHDPlus stream reach
    Y_COORD:    coordinate of Albers Equal Area projection with units meters, 
                used as surrogate for latitude.
    NLCD11PC:   Percent cumulative open water from NHDPlus, derived from 
                National Land Cover Dataset.
    GLACIER:    The percentage of the catchment area classified as glacier at 
                each temperature site.
    BFI:        Base flow index. Base flow to total flow as a percentage.
    Air_Aug:    August mean air temperature for the NorWeST processing unit.
    Flow_Aug:   August mean stream flow metric for the NorWeST processing unit.
    OBSPREDID:  A unique ID for each feature.
    NEAR_FID:	the FID of the nearest edge feature
    NEAR_DIST:	the distance between the original site coordinates and the nearest
  	   	edge
    NEAR_X:	x coordinate
    NEAR_Y:	y coordinate
    NEAR_ANGLE:	the angle between the original site location and the nearest
                point on the closest edge
    rid:	Reach identifier of the edge the site resides on
    ratio:	Site ratio value; provides the proportional distance along the
    		edge to the site location
    upDist:	Distance upstream from the stream outlet (m)
    afvArea:	Additive function value calculated using waterhsed area (h2oAreaKm2)
    locID:      Location identifier
    netID:      Stream network identifier
    pid:        Point identifier

}
}
\source{
The data are downloadable from the NorWeST site.
\url{http://www.fs.fed.us/rm/boise/AWAE/projects/NorWeST.html}

NHDPlus V1 website:
\url{http://www.horizon-systems.com/NHDPlus/NHDPlusV1_home.php}

A User Guide for the data can be found here:
\url{ftp://ftp.horizon-systems.com/NHDPlus/NHDPlusV1/documentation/NHDPLUSV1_UserGuide.pdf}

}

\examples{

SSN4 <- importSSN(system.file("lsndata/LewWillCol.ssn", 
	package = "fluvgrm"), o.write = TRUE)
# default plot with blue lines for stream segments and
# black + for data locations
plotSSN(SSN4)
# plot with response variable colored by value
plotSSN(SSN4, VariableName = 'STREAM_AUG', pch = 19, cex = 1.2,
  addFuncColName = 'afvArea', strCol = 'grey50')
# to run a script that will create Fig. 4-6 in the Zimmerman and
# Ver Hoef paper "The Torgegram for Fluvial Variography: Characterizing
# Spatial Dependence on Stream Networks" navigate to the script on your
# computer found here:
system.file("scripts/realDataFigures.R", package = "fluvgrm")
# if you run it from source,
source(system.file("scripts/realDataFigures.R", package = "fluvgrm"))
# Figures 5 and 6 are stored on the R temp directory,
# which can be found with
tempdir()
# and you can navigate to it in your file system to see the pdfs
# that were created. Figure 5 on the raw temperature data is named
# "FCFUtemp.pdf," and Figure 6 on the residuals is names "FCFUresid.pdf."
}
