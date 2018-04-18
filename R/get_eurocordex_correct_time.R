#' correct the input parameter 'time' for read_eurocordex_data()
#'
#' @param time length-1 or length-2 array of type character, numeric or integer
#'
#' @return numeric or integer array of length 2
#' @export 
#'
#' @examples
#' 
#' # Used by `read_eurocordex_data`. Please look into that function's code for a usage example.
#' 
#' 
get_eurocordex_correct_time <- function(time) {

  if (length(time) != 2) {
    if (length(time) == 1) {
      warning('read_eurocordex_data: Length of time should be 2 but is 1. Setting time min and max to this value')
      tmp_time <- c(time, time)
    } else {
      stop('read_eurocordex_data: Length of time should be 2 but is larger.')
    }
  } else {
    tmp_time <- time
  }
  
  if (class(tmp_time[1])%in%c('numeric', 'integer')) {
    num_time <- tmp_time
  } else if (class(tmp_time[1])%in%c('character')) {
    num_time <- as.numeric(tmp_time)
  } else {
    stop('read_eurocordex_data: time is of wrong typ. It has to be character, numeric or integer.')
  }
 
  return(num_time) 
}