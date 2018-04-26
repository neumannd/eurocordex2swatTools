#' Convert SWAT2012 variable name to EURO-CORDEX variable name
#' 
#' Convert SWAT2012 variable name to EURO-CORDEX variable name
#' 
#' Converts SWAT2012 variable name to EURO-CORDEX variable name.
#' 
#' NOTE: It might return one or MORE values per input value. Please have a look at the examples for details.
#'
#' @param varname character or character-array: one or more SWAT2012 variable names
#' @param stop_on_error boolean: stop, when one or more entries of varname are not convertible
#'
#' @return character or character-array: EURO-CORDEX variable names
#' @export
#'
#' @examples
#' 
#'  # PLEASE NOT THE LAST EXAMPLE!
#' 
#'  var <- 'pcp'
#'  var_ec <- convert_varname_swat2eurocordex(var)
#'  print(var_ec)
#'  # [1] "pr"
#'  
#'  var <- 'slr'
#'  var_ec <- convert_varname_swat2eurocordex(var)
#'  print(var_ec)
#'  # [1] "rsds"
#'  
#'  var <- 'tmp'
#'  var_ec <- convert_varname_swat2eurocordex(var)
#'  print(var_ec)
#'  # [1] "tasmin" "tasmax"
#'  
#'  
convert_varname_swat2eurocordex <- function(varname, stop_on_error = TRUE) {
  
  mapping_swat2eurocordex <- list('wnd' = 'sfcWind',
                                  'hmd' = 'hurs',
                                  'slr' = 'rsds',
                                  'pcp' = 'pr',
                                  'tmpmax' = 'tasmax',
                                  'tmpmin' = 'tasmin',
                                  'tmp' = c('tasmin','tasmax'))
  
  if (stop_on_error) if (sum(!(varname%in%names(mapping_swat2eurocordex)))) stop('convert_varname_swat2eurocordex: one or more elements of varname are not convertible')
  
  varname_out <- unlist(mapping_swat2eurocordex[varname])
  names(varname_out) <- NULL
  
  return(varname_out)
  
}