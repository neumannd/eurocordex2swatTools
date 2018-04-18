#' Replace time data in a data.frame by new time 
#'
#' @param data data.frame: contains data and time columns ('time' and 'time_posix'); time_posix column needs to be of type POSIXct
#' @param fakeTime POSIXct-array: contains new times to insert
#' @param col_time character, optional: set alternative name of column 'time'
#' @param col_time_posix character, optional: set alternative name of column 'time_posix'
#' @param fakeLength boolean, optional: if data has less entries than the length of fake time => extend data by repeating entries
#'
#' @return data.frame: with 'corrected' time axies
#' @export
#'
#' @examples
#' 
#' # see example in README
#' 
set_eurocordex_faketime <- function(data, fakeTime, col_time = 'time', col_time_posix = 'time_posix', fakeLength=TRUE) {
  
  nold <- dim(data)[1]
  nnew <- length(fakeTime)
  
  if (nnew > 2*nold) stop('set_eurocordex_faketime: fakeTime more than twice as long as the number of entries in data')
  
  if (fakeLength) {
    if (nold > nnew) {
      out_data <- data[1:nnew,]
      warning(paste0('set_eurocordex_faketime: ', formatC(nold-nnew, format='d'), ' lines dropped'))
    } else if (nold < nnew) {
      out_data <- rbind(data, data[(2*nold-nnew+1):nold,])
      warning(paste0('set_eurocordex_faketime: ', formatC(nnew-nold, format='d'), ' lines duplicated'))
    } else {
      out_data <- data
    }
    
    corr_fakeTime <- fakeTime
  } else {
    if (nold > nnew) {
      out_data <- data[1:nnew,]
      warning(paste0('set_eurocordex_faketime: ', formatC(nold-nnew, format='d'), ' lines dropped'))
    } else if (nold < nnew) {
      out_data <- data
      warning(paste0('set_eurocordex_faketime: ', formatC(nnew-nold, format='d'), ' values of fakeTime dropped'))
    } else {
      out_data <- data
    }
    
    corr_fakeTime <- fakeTime[1:min(nnew,nold)]
  }
  
  if ( 'POSIXct'%in%class(fakeTime) ) {
    new_time_POSIXct <- corr_fakeTime
    new_time_raw <- as.numeric(corr_fakeTime) - as.numeric(as.POSIXct(0, tz = 'UTC', origin = '1949-12-01 00:00:00'))
  } else {
    stop(paste0('set_eurocordex_faketime: please provided fakeTime in the format POSIXct and not as ', paste0(class(fakeTime), collapse = ' or ')))
  }
  
  if ( sum(is.na(col_time)) + sum(''%in%col_time) + sum(is.null(col_time)) == 0 ) {
    out_data[col_time] <- new_time_raw
  }
  
  if ( sum(is.na(col_time_posix)) + sum(''%in%col_time_posix) + sum(is.null(col_time_posix)) == 0 ) {
    out_data[col_time_posix] <- new_time_POSIXct
  }
  
  return(out_data)
  
}