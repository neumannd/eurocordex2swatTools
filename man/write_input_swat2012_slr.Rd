% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/write_input_swat2012_slr.R
\name{write_input_swat2012_slr}
\alias{write_input_swat2012_slr}
\title{Write out solar radiation SWAT 2012 meteorology input file}
\usage{
write_input_swat2012_slr(file, data, station_names,
  col_time_name = "time_posix")
}
\arguments{
\item{file}{string: directory + file name of output file}

\item{data}{data.frame: contains a column with time stamp and >=1 columns with data; time column needs to be of type POSIXct}

\item{station_names}{character-array: contains names of the stations to write out; have to be equal to column names of data}

\item{time_name}{character, optional: name of the time stamp column, default = 'time_posix'}
}
\description{
This is a wrapper function for write_input_swat2012_other()
}
\examples{

# see example in README

}
