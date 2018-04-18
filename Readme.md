# Introduction

We want to read in EURO-CORDEX Data and write out input files for SWAT


# Important directories

EURO-CORDEX data:

`/silod4/dneumann/phoswam/euro-cordex`

code:

`/media/neumannd/work_dell/89_PhosWAM/61_SWAT_Data/10_phoswam_swat_data_processing`

example input files:

`/media/neumannd/work_dell/89_PhosWAM/61_SWAT_Data/01_SWAT_input/example_input_data_andreas/`

scripts for EURO-CORDEX data download:

`/media/neumannd/work_dell/89_PhosWAM/61_SWAT_Data/01_SWAT_input/EURO_CORDEX`


# EURO-CORDEX

Data were obtained from:

https://esgf-data.dkrz.de/search/cordex-dkrz/

We use these runs:

 * institution: CLMcom and SMHI
 * experiments: historical, rcp2.6, and rcp8.5
 * domain: EUR-11
 * project: CORDEX
 * ensemble: r12i1p1 (mainly)
 * time frequency: day
 * variables: hurs, sfcWind, rsds, pr, tasmax, tasmin (see below for details)

Variables:

 * hurs: near-surface relative humidity
 * sfcWind: surface wind speed
 * rsds: surface downwelling shortwave radiation (like measured solar radiation)
 * pr: precipitation
 * tasmax: daily maximum temperature
 * tasmin: daily minimum temperature

Furthermore, `hurs` was missing for rcp8.5 and historical CCLM simulations. Therefore, I will calculate `hurs` from temperature, pressure, and specific humidity.

See here for conversion: https://esgf-data.dkrz.de/search/cordex-dkrz/


# SWAT

## What SWAT needs

TODO


## File definitions

TODO


## Stations

TODO






