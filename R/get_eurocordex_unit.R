#' Get unit to one EURO-CORDEX variable name
#'
#' Get the unit of one EURO-CORDEX meteorological input parameter (should be equal to CF Conventions units). Only five parameters are currently supported: sfcWind, hurs, rsds, pr, tasmax, tasmin, and tas.
#'
#' @param varname character or character-array: one or more EURO-CORDEX variable names
#' @param stop_on_error boolean: stop, when one or more entries of varname are not convertible
#'
#' @return character or character-array: EURO-CORDEX units
#' @export
#'
#' @examples
#' 
#'  var <- 'hurs'
#'  unit <- get_eurocordex_unit(var)
#'  print(unit)
#'  # %
#'  
#'  var <- 'rsds'
#'  unit <- get_eurocordex_unit(var)
#'  print(unit)
#'  # W m-2
#'  
#'  
get_eurocordex_unit <- function(varname, stop_on_error = TRUE) {
  
  mapping_eurocordex_varname2unit <- list('sfcWind' = 'm s-1',
                                          'hurs' = '%',
                                          'rsds' = 'W m-2',
                                          'pr' = 'dm3 m-2 s-1',
                                          'tasmax' = 'K',
                                          'tasmin' = 'K',
                                          'tas' = 'K')
  
  if (stop_on_error) if (sum(!(varname%in%names(mapping_eurocordex_varname2unit)))) stop('get_eurocordex_unit: one or more elements of varname are not convertible')
  
  varname_out <- unlist(mapping_eurocordex_varname2unit[varname])
  names(varname_out) <- NULL
  
  return(varname_out)
  
}