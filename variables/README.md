This folder containes the procedures and codes used to prepare the spatial information for:

* [Study area](#Studyarea)
* [Land use classification](#Landuse)
* [Forest cover](#Forest)


## Studyarea
For ecological and management reasons, the study area in the Alps has been selected accroding to the following criteria:  
1. An area large enough to produce biologically meaningful results (Center/Eastern Alps);
2. An area environmentally meaningful for the presence (and future expansion) of the bear ([Alpine Convention](http://www.alpconv.org/it/convention/default.html) area);
3. An area administratively homogeneous (Italy).

For these reasons, the area selected is the intersection between the Alpine Convetion area, and the Italian regions of Lombardia, Trentino Alto Adige, Veneto e Friuli Venezia Giulia. The generated shapefile is found [here](https://github.com/andreacorra/AlpBearConnect/tree/master/variables/alpconv)


## Landuse

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


## Forest

The forest presence in the landscape has been derived using the [Copernicus layer](https://land.copernicus.eu/pan-european/high-resolution-layers/forests). In detail:  
1. Tree cover density (TCD) and the Forest type product (FTY) layers are downloaded for the reference area;
2. Using raster calculator a new layer is generated, taking into consideration the non-urban and non-orchard tree associations;
3. ...

