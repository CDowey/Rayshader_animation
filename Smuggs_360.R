library(rayshader)
library(magrittr)

# Create a series of .pngs for sun angles 1-360 in rayshade and sphereshade

# Load raster
tiff_path = "./Smuggs_LiDAR_Resample_Clip.tif"
tiff = raster::raster(tiff_path)

# Convert raster to matrix
elmat = matrix(raster::extract(tiff, raster::extent(tiff), buffer = 0), 
               nrow = ncol(tiff), ncol = nrow(tiff))

for (i in 1:360){
  
  # Create "hillshade"
  sa1 <- i 

  # Rayshade also has a sunangle piece that I didn't change? probably should?
  raymat = ray_shade(elmat,lambert = TRUE, sunangle = sa1)
  
  ambmat = ambient_shade(elmat)

  filepath = paste("./", i, ".png", sep='')

  elmat %>% sphere_shade(texture = "bw", sunangle = sa1) %>%
    add_shadow(raymat, 0.8) %>%
    add_shadow(ambmat, 0.8) %>%
    save_png(filepath)
  
  print(i)

}
