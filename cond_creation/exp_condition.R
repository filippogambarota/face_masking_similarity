# Packages

library(tidyverse)
library(magick)

rm(list = ls())

# Exp Param ---------------------------------------------------------------

im <- magick::image_read("../face/f1.png") # this need a folder where exp images are stored
im_info <- magick::image_info(im)

h_face = im_info$height # face image height
w_face = im_info$width # face image width

Ecc <- c("LPF", "RPF")
mask_dur <- 0.2
face_dur <- 0.05
soa <- c(0, 0.1)

ncatch <- 20

# New cond file -----------------------------------------------------------

fovea <- 1:4
periphery <- 5:8

female_fovea <- paste0("f", fovea)
female_periphery <- paste0("f", periphery)
male_fovea <- paste0("m", fovea)
male_periphery <- paste0("m", periphery)

quad1 <- expand_grid(face1 = female_periphery, face2 = female_fovea)
quad2 <- expand_grid(face1 = male_periphery, face2 = female_fovea)
quad3 <- expand_grid(face1 = female_periphery, face2 = male_fovea)
quad4 <- expand_grid(face1 = male_periphery, face2 = male_fovea)

cond <- bind_rows(quad1, quad2, quad3, quad4) %>% 
  expand_grid(., soa, Ecc) %>% 
  mutate(Catch = 0)
  
cond$Catch[sample(1:nrow(cond), 20)] = 1
cond$face_dur <- face_dur

# Final Cond File

cond %>% 
  mutate(mask = paste0("face/mask_", face1, ".png"),
         face1 = paste0("face/", face1, ".png"),
         face2 = paste0("face/", face2, ".png"),
         ratio_hw = h_face/w_face,
         ratio_wh = w_face/h_face,
         mask_dur = mask_dur) -> cond

# Check Matrix ------------------------------------------------------------

plot(table(cond$face1, cond$face2))

# Check Condition ---------------------------------------------------------

table(cond$face1, cond$face2)
table(cond$Catch)
table(cond$Ecc)
table(cond$soa)

# Write -------------------------------------------------------------------

# Main Experiment

writexl::write_xlsx(cond, "../face_cond.xlsx")

# Practice

cond %>% 
  filter(Catch == 0) %>% 
  slice(sample(1:nrow(.), 9)) %>% 
  writexl::write_xlsx("../face_prac.xlsx")

# Debug Purpose

bind_rows(
  cond %>% slice(sample(1:20)),
  cond %>% filter(Catch == 1) %>% slice(1:5)) %>% 
  writexl::write_xlsx(., "../face_debug.xlsx")

# Example Grid ------------------------------------------------------------

# This create the example grid

all_images <- list.files("../face/", full.names = T)

all_images <- all_images[!stringr::str_detect(all_images, "mask")]

magick::image_read(all_images) %>% 
  magick::image_montage(tile = "4", geometry = "x150+30+30", bg = "#808080") %>%
  magick::image_write(
    format = "png", path = "../example_faces.png",
    quality = 100
)