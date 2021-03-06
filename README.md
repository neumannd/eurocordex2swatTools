# Introduction

This package provides some functions to read in EURO-CORDEX model output in netCDF format, to process them, and to write them out into input files for SWAT Version 2012.

Please see the functions' help pages for details.


# Acknowledgements

This package was created within the project [PhosWaM](https://www.io-warnemuende.de/projekt/142/phoswam.html) ('Phosphorus from source to sea - Integrated phosphorus and water resources management for sustainable water protection'). PhosWaM is funded within the ReWaM funding initiative by the German Federal Ministry for Education and Research (BMBF) under project number FKZ 033W042A.

The programing work was also performed within the scope of the [Leibniz ScienceCampus Phosphorus Research Rostock](https://wissenschaftscampus-rostock.de/).


# Usage examples

Here are three usage examples. You need to download the appropriate data first. The EURO-CORDEX data are available via one of the EURO-CORDEX data notes, which are listed [on the EURO-CORDEX homepage](http://www.euro-cordex.net/060378/index.php.en).

## Example 1: wind and precipitation

```
#' define directory that contains the model data
dir <- '/my/data/directory/for/EUROCORDEX/data'

#' define EURO-CORDEX model run details
variable <- 'sfcWind'
domain <- 'EUR-11'
driver <- 'ICHEC-EC-EARTH'
experiment <- 'rcp85'
ensemble <- 'r12i1p1'
institute <- 'CLMcom'
model <- 'CCLM4-8-17'
downscaling_realisation <- 'v1'
time_frequency <- 'day'
time <- c('20110201', '20170301')

#' define stations
stations <- data.frame(c('abc', 'def', 'ghi', 'jkl'), c(10.31, 11.12, 9.2, 9.31), c(55.19, 54.77, 55.02, 53.2), c(44, 1, 5, 107), stringsAsFactors = FALSE)
names(stations) <- c('station_name', 'lon', 'lat', 'elev')

#' read in the data
my_data <- read_eurocordex_data(dir, variable, domain, driver, experiment, ensemble, institute, model, downscaling_realisation, time_frequency, time, stations)

#' plot it to see, whether the data looks good
# plot(my_data$time_posix, my_data$abc)

#' set output directory and file name
dOt <- '.'
fOt <- 'test_wnd.wnd'

#' write out the data
write_input_swat2012_wnd(paste(dOt, fOt, sep = '/'), my_data, stations$station_name)



#' now get precipitation data
variable <- 'pr'

#' get the data (same as above)
my_data <- read_eurocordex_data(dir, variable, domain, driver, experiment, ensemble, institute, model, downscaling_realisation, time_frequency, time, stations)

#' convert units (NEW!)
my_data <- convert_eurocordex_units(my_data, stations$station_name, get_eurocordex_unit('pr'), get_swat_unit('pcp'))

#' set output file name (same as above)
fOt <- 'test_pcp.pcp'

#' write out the data (different function call)
write_input_swat2012_pcp(paste(dOt, fOt, sep = '/'), my_data, stations, stations$station_name)

```

## Example 2: temperature

```
#' define directory that contains the model data
dir <- '/my/data/directory/for/EUROCORDEX/data'

#' define EURO-CORDEX model run details
domain <- 'EUR-11'
driver <- 'ICHEC-EC-EARTH'
experiment <- 'rcp85'
ensemble <- 'r12i1p1'
institute <- 'CLMcom'
model <- 'CCLM4-8-17'
downscaling_realisation <- 'v1'
time_frequency <- 'day'
time <- c('20110201', '20170301')

#' define stations
stations <- data.frame(c('abc', 'def', 'ghi', 'jkl'), c(10.31, 11.12, 9.2, 9.31), c(55.19, 54.77, 55.02, 53.2), c(44, 1, 5, 107), stringsAsFactors = FALSE)
names(stations) <- c('station_name', 'lon', 'lat', 'elev')


#' now get T min and T max data
#' get the data (same function as above)
my_data_min <- read_eurocordex_data(dir, 'tasmin', domain, driver, experiment, ensemble, institute, model, downscaling_realisation, time_frequency, time, stations)
my_data_max <- read_eurocordex_data(dir, 'tasmax', domain, driver, experiment, ensemble, institute, model, downscaling_realisation, time_frequency, time, stations)

#' convert units (same as above)
my_data_min <- convert_eurocordex_units(my_data_min, stations$station_name, get_eurocordex_unit('tasmin'), get_swat_unit('tmp'))
my_data_max <- convert_eurocordex_units(my_data_max, stations$station_name, get_eurocordex_unit('tasmax'), get_swat_unit('tmp'))

#' set output file name (same as above)
fOt <- 'test_tmp.tmp'

#' write out the data (different function call)
write_input_swat2012_tmp(paste(dOt, fOt, sep = '/'), my_data_min, my_data_max, stations, stations$station_name)

```

## Example 3: relative humidity

Some parameters of some data sets are missing -- e.g. relative humidity of some realizations of the CLM community simulations. For this purpose we created a functions, which reads in specific humidity, temperature, and pressure and calculates the relative humidity (approximately) from these parameters.


```
#' define directory that contains the model data
dir <- '/my/data/directory/for/EUROCORDEX/data'

#' define EURO-CORDEX model run details
domain <- 'EUR-11'
driver <- 'ICHEC-EC-EARTH'
experiment <- 'rcp85'
ensemble <- 'r12i1p1'
institute <- 'CLMcom'
model <- 'CCLM4-8-17'
downscaling_realisation <- 'v1'
time_frequency <- 'day'
time <- c('20110201', '20170301')

#' define stations
stations <- data.frame(c('abc', 'def', 'ghi', 'jkl'), c(10.31, 11.12, 9.2, 9.31), c(55.19, 54.77, 55.02, 53.2), c(44, 1, 5, 107), stringsAsFactors = FALSE)
names(stations) <- c('station_name', 'lon', 'lat', 'elev')

#' read data and calculate relativ humidity data
my_data <- calculate_eurocordex_relative_humidity(dir, domain, driver, experiment, ensemble, institute, model, downscaling_realisation, time_frequency, time, stations)

#' set output directory and file name
dOt <- '.'
fOt <- 'test_hmd.hmd'

#' write out the data
write_input_swat2012_hmd(paste(dOt, fOt, sep = '/'), my_data, stations$station_name)

```



# Notes

Most functions, which use specific columns of the model data data.frame, allow to parse parameters such as col_time or col_elev. If the columns should not have the default names, these parameters allow to set the column names manually.
