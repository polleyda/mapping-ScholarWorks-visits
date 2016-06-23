# Load required packages
x <- c("ggplot2", "rgdal", "scales", "ggmap","plyr", "dplyr", "maptools", "ggalt")
lapply(x, require, character.only = TRUE)

# Set working directory to Desktop
setwd("C:/Users/dapolley/Desktop/ScholarWorks-maps")

# Read in the data
data <- read.csv("map_data_template.csv", header = TRUE, na.strings = "NA")

# Read in world map w/ country boundaries shapefile
map <- readOGR(dsn = "mapping-ScholarWorks-visits/TM_WORLD_BORDERS-0.3", layer = "TM_WORLD_BORDERS-0.3")

# Remove Antarctica from shapefile
map <- subset(map, map$ISO3 != "ATA")

# Coerce map into dataframe ggplot2 can recognize
map <- fortify(map, region = "ISO3")

# Rename is03 column to id
colnames(data) <- c("sort_id", "common_name", "formal_name", "id", "visits")

# Convert data$id from factor to character to ease merge
data[,"id"] <- as.character(data[,"id"])

# Merge dataframes by id (ISO2)
plot_data <- left_join(map, data)

# Map data
ggplot() +
  geom_polygon(data = plot_data, aes(x = long, y = lat, group = group, fill = visits), color = "black", size = 0.05) +
  coord_proj("+proj=robin +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs") +
  scale_fill_gradient(low = "#fee8c8", high = "#e34a33", trans = "sqrt") +
  theme(axis.ticks = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank(),
        rect = element_blank())+
  labs(title = "Visits to ScholarWorks", fill = "Site Visits")
