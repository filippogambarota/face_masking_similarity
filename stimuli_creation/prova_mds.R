library(tidyverse)

im = read_csv("../Desktop/Nao Similarity/stimuli_creation/im_euc.csv", col_names = F)
name = read.table("../Desktop/Nao Similarity/stimuli_creation/im_name.txt", header = T)

im[mds_sel$id,mds_sel$id,] -> im




heatmap(as.matrix(im))

dat <- tibble(im, name)

fit <- cmdscale(im, eig=TRUE, k=2)

# plot solution
x <- fit$points[,1]
y <- fit$points[,2]

mds = tibble(x, y, id = 1:length(x), name = name$all_images_name)

plot(x, y, xlab="Coordinate 1", ylab="Coordinate 2",
     main="Metric MDS", type="n")

mds %>%
  mutate(gender = ifelse(startsWith(name, "AF"), "female", "male")) %>% 
  filter(name %in% nam) -> mds_sel
  

im = sapply(im, function(x) ifelse(x == 0, NA, x))

im_sim = apply(im, 1, function(x) max(x, na.rm = T))

im_table <- tibble("image" = name$all_images_name, "sim" = im_sim)

im_table %>% 
  mutate(gender = ifelse(startsWith(image, "AF"), "female", "male")) %>% 
  arrange(sim) %>% 
  group_by(gender) %>% 
  nest() -> im_table

map(im_table$data, function(x) slice(x, 1:8)) %>% 
  bind_rows() %>% 
  pull(image) -> nam
  
cmdscale(x, eig=TRUE, k=2)




