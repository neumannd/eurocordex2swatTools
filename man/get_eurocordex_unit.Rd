% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_eurocordex_unit.R
\name{get_eurocordex_unit}
\alias{get_eurocordex_unit}
\title{Get unit to one EURO-CORDEX variable name}
\usage{
get_eurocordex_unit(varname, stop_on_error = TRUE)
}
\arguments{
\item{varname}{character or character-array: one or more EURO-CORDEX variable names}

\item{stop_on_error}{boolean: stop, when one or more entries of varname are not convertible}
}
\value{
character or character-array: EURO-CORDEX units
}
\description{
Get the unit of one EURO-CORDEX meteorological input parameter (should be equal to CF Conventions units). Only five parameters are currently supported: sfcWind, hurs, rsds, pr, tasmax, tasmin, and tas.
}
\examples{

 var <- 'hurs'
 unit <- get_eurocordex_unit(var)
 print(unit)
 # \%
 
 var <- 'rsds'
 unit <- get_eurocordex_unit(var)
 print(unit)
 # W m-2
 
 
}
