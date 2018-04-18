#' Convert EURO-CORDEX variable name to SWAT2012 variable name
#'
#' @param varname character or character-array: one or more EURO-CORDEX variable names
#' @param stop_on_error boolean: stop, when one or more entries of varname are not convertible
#'
#' @return character or character-array: SWAT2012 variable names
#' @export
#'
#' @examples
#' 
#'  var <- 'hurs'
#'  var_swat <- convert_varname_eurocordex2swat(var)
#'  print(var_swat)
#'  # [1] "hmd"
#'  
#'  var <- 'rsds'
#'  var_swat <- convert_varname_eurocordex2swat(var)
#'  print(var_swat)
#'  # [1] "slr"
#'  
#'  var <- 'tasmax'
#'  var_swat <- convert_varname_eurocordex2swat(var)
#'  print(var_swat)
#'  # [1] "tmp"
#'  
#'  
convert_varname_eurocordex2swat <- function(varname, stop_on_error = TRUE) {
  
  mapping_eurocordex2swat <- list('sfcWind' = 'wnd',
                                  'hurs' = 'hmd',
                                  'rsds' = 'slr',
                                  'pr' = 'pcp',
                                  'tasmax' = 'tmp',
                                  'tasmin' = 'tmp',
                                  'tas' = 'tmp')
  
  if (stop_on_error) if (sum(!(varname%in%names(mapping_eurocordex2swat)))) stop('convert_varname_eurocordex2swat: one or more elements of varname are not convertible')
  
  varname_out <- unlist(mapping_eurocordex2swat[varname])
  names(varname_out) <- NULL
  
  return(varname_out)
  
}