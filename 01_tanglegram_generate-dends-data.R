library(readr)
library(dplyr)
library(here)

#read in the snvphyl dist matrix
snvphyl.distmat <- read_csv(here("data","snvphyl_dist-matrix_no-ref.csv")) %>% 
  select(-strain)

snvphyl.dend <- snvphyl.distmat %>% as.matrix() %>% #convert to matrix
  as.dist() %>% # convert to distance
  hclust(method = "average") %>% # cluster on upgma
  as.dendrogram() # convert to dendrogram

#do the same with the wgmlst dist matrix
mlst.distmat <- read_csv(here("data", "wgmlst_dist-matrix.csv")) %>% 
  select(-strain)

mlst.dend <- mlst.distmat %>% as.matrix() %>% 
  as.dist() %>% 
  hclust(method = "average") %>% 
  as.dendrogram()

save(snvphyl.dend, mlst.dend, file = here("data", "dends.Rdata"))
