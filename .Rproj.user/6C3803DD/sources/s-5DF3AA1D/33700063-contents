setwd("C:/GitHub/cal-adapt/caladaptr-dev")
library(httr)

## Ecoengine Installation
#library(devtools)
#install_github('ropensci/ecoengine')

## Load the packages used by ecoengine
pkgs_req <- c("magrittr", "data.table", "httr", "plyr", "assertthat", "dplyr", "whisker", "jsonlite", "lubridate")
(pkgs_missing <- pkgs_req[!(pkgs_req %in% installed.packages()[,"Package"])])
if (length(pkgs_missing)) install.packages(pkgs_missing, dependencies=TRUE)

## Load them all
pkgs_missing <- pkgs_req[!sapply(pkgs_req, function(p) require(p, character.only=T))]

#############################################################################################

ca_base_url <- "http://api.cal-adapt.org/api"   ## turn this into a function
#require(pkgs_req, character. only = TRUE)

## Get resources
ca_resources_resp <- httr::GET(ca_base_url)
class(ca_resources_resp)

## Parse the response ojbect into a list
ca_resources_data <- httr::content(ca_resources_resp, type = "application/json")
names(ca_resources_data)

## We store climate data as GeoTIFF files on the server. Each geotiff file is represented by a Raster Store in the API. A Raster Series is a collection of Raster Stores. For this workshop we will focus on working with a Raster Series. Let's get a list of Raster Series on the API.

## Get more details about the available raster series
(url_series_all <- file.path(ca_base_url, "series", "?pagesize=100"))
ca_rstseries_resp <- httr::GET(url_series_all)  ## one page of series
## To get more than one page, use http://api.cal-adapt.org/api/series/?pagesize=100.

class(ca_rstseries_resp)
ca_rstseries_data <- httr::content(ca_rstseries_resp, type = "application/json")
names(ca_rstseries_data)
ca_rstseries_data$count
ca_rstseries_data[["next"]]
ca_rstseries_data[["previous"]]

class(ca_rstseries_data[["results"]])
names(ca_rstseries_data[["results"]])  ## no names
length(ca_rstseries_data[["results"]])


class(ca_rstseries_data[["results"]][[1]])
names(ca_rstseries_data[["results"]][[1]])
ca_rstseries_data[["results"]][[1]]$name

## Return the names of the datasets in this object
sapply(ca_rstseries_data[["results"]], function(x) x$name )

## Return the slugs of the datasets in this object
sapply(ca_rstseries_data[["results"]], function(x) x$slug)


###########################################################################
## Search for a specific resource by name

#'name': 'yearly average maximum temperature'
(search_params <- paste0("?name='yearly average maximum temperature'?pagesize=100"))
(url_series_precip <- file.path(ca_base_url, "series", search_params))

ca_precip_resp <- httr::GET(url_series_precip)

## Trap errors
## (none of these seem to catch empty results)

assert_that(ca_precip_resp$status_code < 400)
warn_for_status(ca_precip_resp, task = "retrieve list of raster series")


httr::http_error(ca_precip_resp)
httr::http_status(ca_precip_resp)
httr::stop_for_status(x, task = NULL)
httr::warn_for_status(x, task = NULL)
httr::message_for_status(x, task = NULL)

## Parse result into a list
ca_precip_data <- httr::content(ca_precip_resp, type = "application/json")

## Check for no results
if (ca_precip_data$count==0) warning("No results returned from query")
assert_that(ca_precip_data$count > 0, msg="No results returned from query") ## this will stop the code

str(ca_precip_data$results)


#'https://api.cal-adapt.org/api/series/?name=yearly+average+maximum+temperature&pagesize=100'
#'https://api.cal-adapt.org/api/series/?name=yearly+average+maximum+temperature?pagesize=100'

############################################
## Search for a resource by name: Try 2

(search_params <- paste0("?name=yearly+average+maximum+temperature&pagesize=100"))
(url_series_precip2 <- file.path(ca_base_url, "series", search_params))

ca_precip2_resp <- httr::GET(url_series_precip2)
assert_that(ca_precip2_resp$status_code < 400)     ## Stop everything for a return code >400
warn_for_status(ca_precip2_resp, task = "retrieve list of raster series")  ## Give a warning for other things

## Convert response to a list
ca_precip2_data <- httr::content(ca_precip2_resp, type = "application/json")

## Check for no results
ca_precip2_data$count
if (ca_precip2_data$count==0) warning("No results returned from query")

## List names and URLs returned
sapply(ca_precip2_data$results, function(x) x$name)
sapply(ca_precip2_data$results, function(x) x$slug)
sapply(ca_precip2_data$results, function(x) x$url)

############################################
## Search for resource by name Try 3

search_params_lst <- list(name="yearly average maximum temperature", pagesize=100)
(url_series_base <- file.path(ca_base_url, "series/"))

#httr::modify_url(url_series_base, query=search_params_lst)
ca_precip3_resp <- httr::GET(url_series_base, query=search_params_lst)
assert_that(ca_precip3_resp$status_code < 400)     ## Stop everything for a return code >400
warn_for_status(ca_precip3_resp, task = "retrieve list of raster series")  ## Give a warning for other things

## Convert response to a list
ca_precip3_data <- httr::content(ca_precip3_resp, type = "application/json")

## Check for no results
ca_precip3_data$count
if (ca_precip3_data$count==0) warning("No results returned from query")
assert_that(ca_precip3_data$count > 0)

## List names and URLs returned
sapply(ca_precip3_data$results, function(x) x$slug)

########################################################
## Get the metadata for a specific raster series
#response = requests.get('http://api.cal-adapt.org/api/series/tasmax_year_CNRM-CM5_rcp45/'

rs_slug <- "tasmax_year_CNRM-CM5_rcp45"
(rs_url <- file.path(ca_base_url, "series", rs_slug, "/"))

#httr::modify_url(url_series_base, query=search_params_lst)
rs_resp <- httr::GET(rs_url)
assert_that(rs_resp$status_code < 400, msg="Server returned an error code. Check your request.")     ## Stop everything for a return code >400
warn_for_status(rs_resp, task = "retrieve raster series metadata")  ## Give a warning for other things

## Convert response to a list
rs_data <- httr::content(rs_resp, type = "application/json")

## Check for no results 
## This doesn't work: rs_data$count

names(rs_data)

## Convert begin and end values to R objects (POSIXlt)
strptime(rs_data$begin, format="%Y-%m-%dT%T", tz="UTC")
strptime(rs_data$end, format="%Y-%m-%dT%T", tz="UTC")

length(rs_data$rasters)
sapply(rs_data$rasters, function(x) x[1])

############################
## Get the Raster Stores from a Raster Series

rs_slug <- "tasmax_year_CNRM-CM5_rcp45"

(rstore_list_url <- file.path(ca_base_url, "series", rs_slug, "rasters", "/"))

#"http://api.cal-adapt.org/api/series/tasmax_year_CNRM-CM5_rcp45/rasters/"

rstore_list_resp <- httr::GET(rstore_list_url)
assert_that(rstore_list_resp$status_code < 400, msg="Server returned an error code. Check your request.")     ## Stop everything for a return code >400
warn_for_status(rstore_list_resp, task = "retrieve raster series metadata")  ## Give a warning for other things

## Convert response to a list
rstore_list_data <- httr::content(rstore_list_resp, type = "application/json")

names(rstore_list_data)
rstore_list_data$count

class(rstore_list_data$results)
length(rstore_list_data$results)

class(rstore_list_data$results[[1]])

## Look at the names
names(rstore_list_data$results[[1]])

## Look at the tile URL
rstore_list_data$results[[1]]$tileurl

## Question for S&B: can we use this as a leaflet background tile layer?

rstore_list_data$results[[1]]$units
rstore_list_data$results[[1]]$xpixsize

## Get the GeoTIFF
tif_url <- rstore_list_data$results[[1]]$image

library(raster)
this_img_ll <- raster::raster(tif_url)
plot(this_img_ll)

## Get the geom (of a raster is the corners)
(tif_bb_lst <- rstore_list_data$results[[1]]$geom)
class(tif_bb_lst)
length(tif_bb_lst)
names(tif_bb_lst)
tif_bb_lst$type

tif_bb_lst$coordinates
tif_bb_geom <- tif_bb_lst$coordinates
class(tif_bb_geom)

# don't know how to convert tif_bb_geom to a sf object. 


############################
## Get the Raster Stores from a Raster Series

rs_slug <- "tasmax_year_CNRM-CM5_rcp45"

(rstore_list_url <- file.path(ca_base_url, "series", rs_slug, "rasters", "/"))

#"http://api.cal-adapt.org/api/series/tasmax_year_CNRM-CM5_rcp45/rasters/"

rstore_list_resp <- httr::GET(rstore_list_url)
assert_that(rstore_list_resp$status_code < 400, msg="Server returned an error code. Check your request.")     ## Stop everything for a return code >400
warn_for_status(rstore_list_resp, task = "retrieve raster series metadata")  ## Give a warning for other things

## Convert response to a list
rstore_list_data <- httr::content(rstore_list_resp, type = "application/json")


######################################################
## Get Data for a Point Location (encoded as GeoJSON)

coords2json <- function(pt) {
  return(paste0("{\"type\":\"Point\",\"coordinates\":[", pt[1], ",", pt[2], "]}")  )
}

pt <- c(-121.4687,38.5938)

# Query parameters
#my_point_lst <- list(type="Point", coordinates=c(-121.4687,38.5938))

#https://api.cal-adapt.org/api/series/tasmax_year_CNRM-CM5_rcp45/rasters/?pagesize=100&g={\"type\":\"Point\",\"coordinates\":[-121.4687,38.5938]}

#params_lst <- list(pagesize=10, g={"type":"Point","coordinates":[-121.4687,38.5938]})
params_lst <- list(pagesize=10, g=coords2json(pt))

base_url <- 'http://api.cal-adapt.org/api/series/tasmax_year_CNRM-CM5_rcp45/rasters/'

# Add HTTP header
#headers_lst <- list('ContentType'='json')

# Make request
#response = requests.get(url, params=params, headers=headers) #Python code
rs_pt_resp <- httr::GET(base_url, query=params_lst, content_type_json())

class(rs_pt_resp)
assert_that(rs_pt_resp$status_code < 400, msg="Server returned an error code. Check your request.")     ## Stop everything for a return code >400
warn_for_status(rs_pt_resp, task = "retrieve data for a point location")  ## Give a warning for other things

## Convert response to a list
rs_pt_data <- httr::content(rs_pt_resp, type = "application/json")
rs_pt_data$count

class(rs_pt_data)
length(rs_pt_data)
names(rs_pt_data)

length(rs_pt_data$results)

rs_pt_data$results[[1]]
sapply(rs_pt_data$results, function(x) x$image)

######################################################
## Get Data for a Point Location (encoded as WKT)

pt <- c(-121.4687,38.5938)

(params_lst <- list(pagesize=10, g=sf::st_as_text(st_point(pt))))

base_url <- 'http://api.cal-adapt.org/api/series/tasmax_year_CNRM-CM5_rcp45/rasters/'

# Make request
rs_pt2_resp <- httr::GET(base_url, query=params_lst, content_type_json())

class(rs_pt2_resp)
assert_that(rs_pt2_resp$status_code < 400, msg="Server returned an error code. Check your request.")     ## Stop everything for a return code >400
warn_for_status(rs_pt2_resp, task = "retrieve data for a point location")  ## Give a warning for other things

## Convert response to a list
rs_pt2_data <- httr::content(rs_pt2_resp, type = "application/json")
rs_pt2_data$count

# class(rs_pt2_data)
# length(rs_pt2_data)
# names(rs_pt2_data)
# length(rs_pt2_data$results)

sapply(rs_pt2_data$results, function(x) x$image)

#####################################################################3
## Prepare some polygon boundaries

getwd()
yose_bnd_nad83 <- st_read(dsn="./data", layer="yose_boundary")
head(yose_bnd_nad83)
yose_bnd_wgs84 <- st_transform(yose_bnd_nad83, 4326)
yose_bnd_wgs84
st_write(yose_bnd_wgs84, dsn=".", layer="yosemite_bnd", driver="ESRI Shapefile")

counties_bnd <- st_read(dsn="./data", layer="CA_counties_ll")
head(counties_bnd)
yose_bnd_wgs84 <- st_transform(yose_bnd_nad83, 4326)
yose_bnd_wgs84
st_write(yose_bnd_wgs84, dsn=".", layer="yosemite_bnd", driver="ESRI Shapefile")


##########################################################
## Get data for a time slice for Yosemite

yose_bnd_sf <- sf::st_read(dsn="./data", layer="yosemite_bnd")

## Simplify it to reduce the amount of data that needs to be processed
## The dTolerance level is in map units, was identified through trial-and-error
yose_bnd_simp <- sf::st_simplify(yose_bnd_sf, dTolerance = 0.01)

## Generate the WKT
yose_bnd_simp_wkt <- sf::st_as_text(yose_bnd_simp$geometry[1])
nchar(yose_bnd_simp_wkt)

(params_lst <- list(pagesize=100, g=yose_bnd_simp_wkt, stat='mean'))

base_url <- 'http://api.cal-adapt.org/api/series/tasmax_year_CNRM-CM5_rcp45/'

(begin_date <- as.Date("2050-01-01"))
(end_date <- as.Date("2060-12-31"))
begin_date < end_date

(begin_end_url = paste0(base_url, format(begin_date, "%Y-%m-%d"), "/", format(end_date, "%Y-%m-%d"), "/"))

# Make request
rast_yosem_resp <- httr::GET(begin_end_url, query=params_lst, content_type_json())

## Check for request errors
class(rast_yosem_resp)
assert_that(rast_yosem_resp$status_code < 400, msg="Server returned an error code. Check your request.")     ## Stop everything for a return code >400
warn_for_status(rast_yosem_resp, task = "retrieve data for a point location")  ## Give a warning for other things

## Convert response to a list
rast_yosem_data <- httr::content(rast_yosem_resp, type = "application/json")
names(rast_yosem_data)
rast_yosem_data$count

rast_yosem_data$results[[1]]$image
sapply(rast_yosem_data$results, function(x) x$image)

# Test polygon simplification
# yose_bnd_wkt <- st_as_text(yose_bnd_sf$geometry[1])
# class(yose_bnd_wkt)
# nchar(yose_bnd_wkt)
# 
# yose_bnd_simp1 <- st_simplify(yose_bnd_sf, dTolerance = 0.001)
# yose_bnd_simp1_wkt <- st_as_text(yose_bnd_simp1$geometry[1])
# class(yose_bnd_simp1_wkt)
# nchar(yose_bnd_simp1_wkt)
# 
# yose_bnd_simp2 <- st_simplify(yose_bnd_sf, dTolerance = 0.01)
# yose_bnd_simp2_wkt <- st_as_text(yose_bnd_simp2$geometry[1])
# class(yose_bnd_simp2_wkt)
# nchar(yose_bnd_simp2_wkt)
# 
# plot(st_geometry(yose_bnd_sf), asp=1, border="blue")
# plot(st_geometry(yose_bnd_simp1), border="red", add=TRUE)
# plot(st_geometry(yose_bnd_simp2), border="purple", add=TRUE)


##########################################################
## Get vector data  
## THIS DOESN'T WORK. DON'T KNOW HOW TO CONVERT NESTED LIST BACK INTO
## POLYGONS

(base_url <- file.path(ca_base_url, "counties", "/"))

# Make request
counties_resp <- httr::GET(base_url, content_type_json())

class(counties_resp)
assert_that(counties_resp$status_code < 400, msg="Server returned an error code. Check your request.")     ## Stop everything for a return code >400
warn_for_status(counties_resp, task = "retrieve data for counties")  ## Give a warning for other things

## Convert response to a list
counties_data <- httr::content(counties_resp, type = "application/json")
counties_data$count

names(counties_data)
class(counties_data$features)
length(counties_data$features)

class(counties_data$features[[1]])
names(counties_data$features[[1]])

counties_data$features[[1]]$type
counties_data$features[[1]]$id

names(counties_data$features[[1]]$properties)

class(counties_data$features[[1]]$geometry)
names(counties_data$features[[1]]$geometry)

counties_data$features[[1]]$geometry$type
counties_data$features[[1]]$geometry$coordinates

## Convert features to a spatial object - epic fail
st_as_sf(counties_data$features)
install.packages("geojsonsf")
library(geojsonsf)
x <- geojson_sf(counties_data$features[[1]]$geometry$coordinates)

# Shows raw data which is not structured and readable
counties_data2_txt <- httr::content(counties_resp, as="text", type = "application/json")
nchar(counties_data2)

x <- jsonlite::fromJSON(counties_data2_txt)

length(x)
names(x$features)
names(x$features$geometry)
length(x$features$geometry$coordinates)
x$features$geometry$coordinates

y <- as(x$features$geometry$coordinates, "sfc_MULTIPOLYGON")

y <- st_multipolygon(x$features$geometry$coordinates[[1]])

## See https://github.com/r-spatial/sf/issues/185

names(x$features)

y <- st_as_sf(x$features)

names(x$features$geometry)

URLdecode("https://api.cal-adapt.org/api/counties/?intersects=%7B%22type%22%3A%22Point%22%2C%22coordinates%22%3A%5B-121.4687%2C38.5938%5D%7D&srs=4326&simplify=0.0001&precision=4")

###########################################################
##  Get pixel values for an entire county

(counties_base_url <- file.path(ca_base_url, "counties", "/"))

pt <- c(-121.4687, 38.5938)

# Point location in geojson format
#lat = 38.5938
#lng = -121.4687
#point = '{"type":"Point","coordinates":[%s,%s]}' % (lng, lat)

# Params
#params = {'intersects': point, 'srs': 4326, 'simplify': .0001, 'precision': 4}
(params_lst <- list(intersects=st_as_text(st_point(pt)), srs=4326, simplify=0.0001, precision=4))

# Request the geometry of the county that intersects this point
county_pt_resp <- httr::GET(counties_base_url, query=params_lst, content_type_json())

## Trap request problems
class(county_pt_resp)
assert_that(county_pt_resp$status_code < 400, msg="Server returned an error code. Check your request.")     ## Stop everything for a return code >400
warn_for_status(county_pt_resp, task = "retrieve county layer for a point location")  ## Give a warning for other things

## Convert response to a list
county_pt_data <- httr::content(county_pt_resp, type = "application/json")

county_pt_data$count
names(county_pt_data)

## Construct the URI based on the ID
class(county_pt_data$features)
length(county_pt_data$features)
names(county_pt_data$features[[1]])
(id <- county_pt_data$features[[1]]$id)
(county_uri <- paste0("/api/counties/", id, "/")) ## note that can't include http://api...

## Question for S&B: will county id numbers be the same? Could we make a lookup table?
  
## Find the mean of the pixels in this county

(params_lst <- list(pagesize=100, ref=county_uri, stat='mean'))

rastsers_url <- 'http://api.cal-adapt.org/api/series/tasmax_year_CNRM-CM5_rcp45/rasters/'

# Request pixels in this county
rast_cty_mean_resp <- httr::GET(rastsers_url, query=params_lst, content_type_json())

## Trap request problems
class(rast_cty_mean_resp)
assert_that(rast_cty_mean_resp$status_code < 400, msg="Server returned an error code. Check your query.")
warn_for_status(rast_cty_mean_resp, task = "retrieve the mean of the selected county")

## Convert response to a list
rast_cty_mean_data <- httr::content(rast_cty_mean_resp, type = "application/json")

names(rast_cty_mean_data)
length(rast_cty_mean_data)

class(rast_cty_mean_data$results)
names(rast_cty_mean_data$results)

class(rast_cty_mean_data$results[[1]])
names(rast_cty_mean_data$results[[1]])

rast_cty_mean_data$results[[1]]$image
sapply(rast_cty_mean_data$results, function(x) x$image)






