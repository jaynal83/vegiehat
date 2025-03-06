################################################################################
# 0. Loading required libraries
################################################################################

library(sf)
library(ggplot2)
library(readr)
library(dplyr)
################################################################################
# 1. Import map data
################################################################################

# https://gadm.org/

st_layers("./data/gadm41_BGD.gpkg")

dfBGD0 <- st_read("./data/gadm41_BGD.gpkg", layer = "ADM_ADM_0")
dfBGD1 <- st_read("./data/gadm41_BGD.gpkg", layer = "ADM_ADM_1")
dfBGD2 <- st_read("./data/gadm41_BGD.gpkg", layer = "ADM_ADM_2")
dfBGD3 <- st_read("./data/gadm41_BGD.gpkg", layer = "ADM_ADM_3")

ggplot()+
  geom_sf(
    data = dfBGD0
  )+
  geom_sf(
    data = dfBGD1
  )+
  geom_sf(
    data = dfBGD2
  )+
  geom_sf(
    data = dfBGD3 %>% dplyr::filter(NAME_2=="Bogra")
  )

dfVegiehat <- read_csv(
  file = "./data/Vegiehat_Full_Data.csv"
)

dfSoybeanOil <- dfVegiehat %>%
  filter(
    `Items to Choose`=="Soybean Oil"
  ) %>%
  group_by(
    DistrictName
  ) %>%
  summarise(
    avgPrice = mean(Price, na.rm = T)
  )

mapSoybeanOil <- dfBGD2 %>%
  left_join(
    dfSoybeanOil,
    by = c("NAME_2"="DistrictName")
  )

ggplot()+
  geom_sf(
    data = dfBGD0
  )+
  geom_sf(
    data = mapSoybeanOil,
    aes(
      fill = avgPrice
    )
  )+
  scale_fill_gradientn(
    colors = c("darkgreen", "orange", "red"),
    na.value = "white"
  )+
  theme(
    panel.background = element_blank()
  )
