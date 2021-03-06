% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_swat_unit.R
\name{get_swat_unit}
\alias{get_swat_unit}
\title{Get unit to one SWAT2012 variable name}
\usage{
get_swat_unit(varname, stop_on_error = TRUE)
}
\arguments{
\item{varname}{character or character-array: one or more SWAT2012 variable names}

\item{stop_on_error}{boolean: stop, when one or more entries of varname are not convertible}
}
\value{
character or character-array: SWAT2012 units
}
\description{
Get the unit of one SWAT2012 meteorological input parameter. Only five parameters are currently supported: wnd, hmd, slr, pcp, and tmp.
}
\examples{

 var <- 'pcp'
 unit <- get_swat_unit(var)
 print(unit)
 # mm/d

 var <- 'slr'
 unit <- get_swat_unit(var)
 print(unit)
 # MJ/m2/d
 
 
}
