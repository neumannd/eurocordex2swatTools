#' go through file list and look from which files data should be read
#'
#' @param fList data.frame containing columns filename (char), time_start (int/numeric), and time_stop (int/numeric).
#' @param num_time 2-element array of numeric or integer
#'
#' @return data.frame containing a filtered version of fList; additional columns are added, which indicate which records have to be read from the netCDF files
#' @export
#'
#' @examples
#' 
#' # Used by `read_eurocordex_data`. Please look into that function's code for a usage example.
#' 
#' 
filter_eurocordex_filelist <- function(fList, num_time) {
  
  out_list <- fList[((fList$time_stop >= num_time[1])&(fList$time_start <= num_time[2])),]
  n1 <- dim(out_list)[1]
  
  out_list$posix_start <- as.POSIXct(paste0(paste(formatC(floor(out_list$time_start/1e4), format='d', width=4, flag='0'),
                                        formatC(floor((out_list$time_start%%1e4)/100), format='d', width=2, flag='0'), 
                                        formatC(out_list$time_start%%1e2, format='d', width=2, flag='0'), sep = '-'), ' 00:00:00 UTC'))
  
  out_list$posix_stop <- as.POSIXct(paste0(paste(formatC(floor(out_list$time_stop/1e4), format='d', width=4, flag='0'),
                                        formatC(floor((out_list$time_stop%%1e4)/100), format='d', width=2, flag='0'), 
                                        formatC(out_list$time_stop%%1e2, format='d', width=2, flag='0'), sep = '-'), ' 00:00:00 UTC'))
  
  time_strt <- as.POSIXct(paste0(paste(formatC(floor(num_time[1]/1e4), format='d', width=4, flag='0'),
                                       formatC(floor((num_time[1]%%1e4)/100), format='d', width=2, flag='0'), 
                                       formatC(num_time[1]%%1e2, format='d', width=2, flag='0'), sep = '-'), ' 00:00:00 UTC'))
  
  time_stop <- as.POSIXct(paste0(paste(formatC(floor(num_time[2]/1e4), format='d', width=4, flag='0'),
                                       formatC(floor((num_time[2]%%1e4)/100), format='d', width=2, flag='0'), 
                                       formatC(num_time[2]%%1e2, format='d', width=2, flag='0'), sep = '-'), ' 00:00:00 UTC'))
  
  out_list$data_idx_start <- rep(1, n1)
  out_list$data_idx_stop <- (as.numeric(out_list$posix_stop) - as.numeric(out_list$posix_start)) / 86400 + 1
  out_list$data_idx_count <- out_list$data_idx_stop - out_list$data_idx_start + 1
  
  out_list$read_idx_start <- out_list$data_idx_start
  out_list$read_idx_stop <- out_list$data_idx_stop
  
  out_list$read_idx_start[1] <- (as.numeric(time_strt) - as.numeric(out_list$posix_start[1])) / 86400 + 1
  out_list$read_idx_stop[n1] <- (as.numeric(time_stop) - as.numeric(out_list$posix_start[n1])) / 86400 + 1
  
  out_list$read_idx_count <- out_list$read_idx_stop - out_list$read_idx_start + 1
  
  return(out_list)
  
}