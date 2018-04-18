#' Look for files in a specific directory and return a list of files with start and end dates
#'
#' @param dir string: directory name
#' @param file string: file name part we look for 'dir/file_YYYYDDMM-YYYYDDMM.nc' files
#'
#' @return data.frame with three columns 'filename' (without path), 'time_start' and 'time_stop' (format: YYYYMMDD)
#' @export
#' 
#' @examples
#'  
#' # Used by `read_eurocordex_data`. Please look into that function's code for a usage example.
get_eurocordex_filelist <- function(dir, file) {
  
  tmp_fList <- list.files(dir, paste0(file, '_[0-9]{8}-[0-9]{8}.nc'))
  if (length(tmp_fList) == 0) stop('get_eurocordex_filelist: no files found')
  n_fList <- nchar(tmp_fList[1])
  
  fList <- data.frame(tmp_fList, 
                      as.numeric(substr(tmp_fList, n_fList-19, n_fList-12)), 
                      as.numeric(substr(tmp_fList, n_fList-10, n_fList-3)), 
                      stringsAsFactors = FALSE)
  names(fList) <- c('filename', 'time_start', 'time_stop')
  
  return(fList)
}