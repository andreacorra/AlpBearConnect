This folder containes the procedures and codes used to prepare the spatial information for:

* Selection of the [study area](#Study_area)
* [Buffer](#Buffer)
* [Forest cover](#Forest)
* [Elevation](#Elevation)
* [Human settlment](#Human_settlement)
* [Transitional woodland-shrub](#Shrub)
* [Land use classification](#Land_use)


## Study_area
For ecological and management reasons, the study area in the Alps has been selected accroding to the following criteria:  
1. An area large enough to produce biologically meaningful results (Center/Eastern Alps);
2. An area environmentally meaningful for the presence (and future expansion) of the bear ([Alpine Convention](http://www.alpconv.org/it/convention/default.html) area);
3. An area administratively homogeneous (Italy).

For these reasons, the area selected is the intersection between the Alpine Convetion area, and the Italian regions of Lombardia, Trentino Alto Adige, Veneto e Friuli Venezia Giulia. The generated shapefile is found [here](https://github.com/andreacorra/AlpBearConnect/tree/master/variables/alpconv)


## Buffer

A buffer of 5 km is built around the study area, in order to avoid the 'edge effect' while calculating distances from land types (i.e. human settlments just outside the study area will not be seen without a buffer). There are a set of functions eihter in R and QGIS to calculate the buffer.  


## Forest

The forest presence in the landscape has been derived using the [Copernicus forest layers](https://land.copernicus.eu/pan-european/high-resolution-layers/forests) and the Corine Land Cover vector [data](https://land.copernicus.eu/pan-european/corine-land-cover/clc-2012). In detail:  
1. Tree cover density (TCD), Forest type product (FTY), and Corine Land Cover (CLC) vector layers are downloaded for the reference area;
2. The CLC vector is rasterized to match the Copernicus resolution (20 m);
3. Given the aim of the study, two layers have been derived:  
   1. **Agricultural Forest Cover**: Using the QGIS [raster calculator](https://docs.qgis.org/2.8/en/docs/user_manual/working_with_raster/raster_calculator.html), the layer is generated accounting for both orchards and olive tree as derived from the FTY layer (x = 3), and the vineyards as derived form CLC layer (x = 221):   
   ```
   CLC@1" = 221  OR "FTY@1" = 3   
   ```
     
   2. **Non-urban and non-agricultural Tree Cover Density**: First, using the QGIS raster calculator and the procedure above-mentioned, a layer of *all* the urban and agricultural tree cover is generated. In detail, we considered in the FTY layer the orchards and olive tree (x = 3), as well as the urban trees (x = 4, 5). To account for vineyards, we included the corresponding class of CLC (x = 221). Hence, we generated the new layer (say **non_forest_TCD**) of urban and agricultural tree cover:  
   ```
   CLC@1" = 221  OR "FTY@1" = 3  OR "FTY@1" = 4  OR "FTY@1" = 5 
   ```
      Using the GRASS raster calculator [r.mapcalc](http://www.ing.unitn.it/~grass/docs/tutorial_62_en/htdocs/comandi/r.mapcalc.htm), we 'clip' the TCD taking into account **only** non-urban and non-agricultural tree associations.  
      ```
      new_map = not(if(non_forest_TCD)) * TCD
      ```
   With the following function, if *non_forest_TCD* is *NOT* 1 (i.e. 0), then it returns 1, which is then multiplied by   percentage of cover. The resulting map is a Tree Cover Density (0 to 100) without non-urban and non-agricultural tree associations.


## Elevation
The elevation has been derived from the EU [Digital Elevation Model](https://land.copernicus.eu/imagery-in-situ/eu-dem/eu-dem-v1.1). All the corresponding derived variables (slope, aspect, etc) are derived with the function *terrain()* in the package [raster](https://cran.r-project.org/web/packages/raster/index.html).


## Human_settlement
The human settlement has been derived from the EU [European Settlement Map](https://land.copernicus.eu/pan-european/GHSL/european-settlement-map/esm-2012-release-2017-urban-green). For analysis purposes the higher resolution (2.5 m) has been chosen, as it will then be reduced as needed. There are many tiles componing the study area, so in sequence:  
1. All the tiles were downloaded form the website;
2. The tiles were clipped using the buffered study area layer;
3. The clipped files were merged as to compose the final raster file.
4. (Be aware that the final raster file is **very** large, so it could be a good idea to run the analysis if large disk space is available)


## Shrub
The Transitional woodland-shrublands are derived in 


# EXTRA:
## Land_use

1. The RGB Landsat8 images are downloaded from [EarthExplorer](https://earthexplorer.usgs.gov/)
   1. On **Enter Search Criteria** select your reference area (by adding coordinates, shapefiles, etc)
   2. Select Your Data Set (in this case *Landsat/Landsat Collection 1 Level-1/Landsat 8 OLI/TIRS c1 Level-1*)
   3. Hit 'Results' on the bottom
   4. Select the tiles with no clouds and in summertime (no snow cover, except for glaciers)
   5. Download the *LandsatLook Images with Geographic Reference* for the selected tiles  
   
2. Load the selected tiles in a GIS environment
3. The RGB image is composite of 3 bands (**R** Red, **G** Green, **B** Blue). We want to extract a certain land type using the *RGB* signature
4. Open Raster calculator
5. To extract a certain land type, add the cut-off values for each band according to a known range ('*RGB* signature').
6. For extracting areas of barren rocks, it is possible to use the *RGB* signature used by [Bretar et al, 2009](https://www.hydrol-earth-syst-sci.net/13/1531/2009/)

```
"rock@1"   >=  70  AND 
"rock@1"   <=  230 AND
"rock@2"   >=  85  AND
"rock@2"   <=  220 AND
"rock@3"   >=  75  AND
"rock@3"   <=  200
```
The first band (@1), corresponds to the Red band, the second to the Green band, and the third to the Blue band.  



