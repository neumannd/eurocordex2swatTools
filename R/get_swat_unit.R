#' Get unit to one SWAT2012 variable name
#'
#' Get the unit of one SWAT2012 meteorological input parameter. Only five parameters are currently supported: wnd, hmd, slr, pcp, and tmp.
#'
#' @param varname character or character-array: one or more SWAT2012 variable names
#' @param stop_on_error boolean: stop, when one or more entries of varname are not convertible
#'
#' @return character or character-array: SWAT2012 units
#' @export
#'
#' @examples
#' 
#'  var <- 'pcp'
#'  unit <- get_swat_unit(var)
#'  print(unit)
#'  # mm/d
#' 
#'  var <- 'slr'
#'  unit <- get_swat_unit(var)
#'  print(unit)
#'  # MJ/m2/d
#'  
#'  
get_swat_unit <- function(varname, stop_on_error = TRUE) {
  
  mapping_swat_varname2unit <- list('wnd' = 'm/s',
                                    'hmd' = '1',
                                    'slr' = 'MJ/m2/d',
                                    'pcp' = 'mm/d',
                                    'tmp' = 'degreeC')
  
  if (stop_on_error) if (sum(!(varname%in%names(mapping_swat_varname2unit)))) stop('get_swat_unit: one or more elements of varname are not convertible')
  
  varname_out <- unlist(mapping_swat_varname2unit[varname])
  names(varname_out) <- NULL
  
  return(varname_out)
  
}