library('ncdf4')

source('filter_eurocordex_filelist.R')
source('get_eurocordex_correct_time.R')
source('get_eurocordex_filelist.R')
source('get_eurocordex_stations_indices.R')
source('read_eurocordex_data.R')
source('read_eurocordex_files.R')
source('write_input_swat2012_hmd.R')
source('write_input_swat2012_other.R')
source('write_input_swat2012_pcp.R')
source('write_input_swat2012_slr.R')
source('write_input_swat2012_tmp.R')
source('write_input_swat2012_wnd.R')
source('convert_eurocordex_units.R')

dIn <- '/silod4/dneumann/phoswam/euro-cordex/EUR-11_ICHEC-EC-EARTH_MIXED_r12i1p1_CLMcom-CCLM4-8-17_v1_day'
# fIn <- 'tasmin_EUR-11_ICHEC-EC-EARTH_rcp26_r12i1p1_CLMcom-CCLM4-8-17_v1_day_20060101-20101231.nc'
fIn <- 'ts_EUR-11_ICHEC-EC-EARTH_rcp85_r12i1p1_CLMcom-CCLM4-8-17_v1_day_20060101-20101231.nc'
ncid <- nc_open(paste(dIn, fIn, sep = '/'))
time_day <- ncvar_get(ncid, 'time')
time_posix <- as.POSIXct(time_day*86400, tz = 'UTC', origin = '1949-12-01 00:00:00')
nc_close(ncid)


dir <- '/silod4/dneumann/phoswam/euro-cordex/EUR-11_ICHEC-EC-EARTH_MIXED_r12i1p1_CLMcom-CCLM4-8-17_v1_day'
# variable <- 'sfcWind'
variable <- 'pr'
domain <- 'EUR-11'
driver <- 'ICHEC-EC-EARTH'
experiment <- 'rcp85'
ensemble <- 'r12i1p1'
institute <- 'CLMcom'
model <- 'CCLM4-8-17'
downscaling_realisation <- 'v1'
time_frequency <- 'day'
time <- c('20110201', '20170301')

stations <- data.frame(c('abc', 'def', 'ghi', 'jkl'), c(10.31, 11.12, 9.2, 9.31), c(55.19, 54.77, 55.02, 53.2), c(44, 1, 5, 107), stringsAsFactors = FALSE)
names(stations) <- c('station_name', 'lon', 'lat', 'elev')

varname <- variable

my_data <- read_eurocordex_data(dir, variable, domain, driver, experiment, ensemble, institute, model, downscaling_realisation, time_frequency, time, stations)
my_data$time_posix <- as.POSIXct(my_data$time*86400, tz = 'UTC', origin = '1949-12-01 00:00:00')

plot(my_data$time_posix, my_data$abc)

dOt <- '.'
fOt <- 'test_pr.dat'

# write_input_swat2012_wnd(paste(dOt, fOt, sep = '/'), my_data, stations$station_name)
write_input_swat2012_pcp(paste(dOt, fOt, sep = '/'), my_data, stations, stations$station_name)


my_data_min <- read_eurocordex_data(dir, 'tasmin', domain, driver, experiment, ensemble, institute, model, downscaling_realisation, time_frequency, time, stations)
my_data_min$time_posix <- as.POSIXct(my_data$time*86400, tz = 'UTC', origin = '1949-12-01 00:00:00')
my_data_max <- read_eurocordex_data(dir, 'tasmax', domain, driver, experiment, ensemble, institute, model, downscaling_realisation, time_frequency, time, stations)
my_data_max$time_posix <- as.POSIXct(my_data$time*86400, tz = 'UTC', origin = '1949-12-01 00:00:00')

for(iS in stations$station_name) my_data_min[[iS]] = my_data_min[[iS]]-273.3
for(iS in stations$station_name) my_data_max[[iS]] = my_data_max[[iS]]-273.3

fOt <- 'test_tmp.dat'
write_input_swat2012_tmp(paste(dOt, fOt, sep = '/'), my_data_min, my_data_max, stations, stations$station_name)
