library(dendextend)
library(here)
library(readr)
library(dplyr)
library(dichromat)

#read in data
load(here("data", "step2side-orders.Rdata")) #objects with dend ordering
load(here("data", "dends.Rdata")) #coloured label dends
metadata <- read_csv(here("data", "Tanglegram_Metadata.csv")) #read in metadata
snv <- read_csv(here("data", "snvphyl_dist-matrix_no-ref.csv")) #read in snv dist matrix

#get colours for connecting lines
rownames(snv) <- snv$strain #name dist matrix rownames
snv <- snv %>% 
  select(-strain) #remove strain col

snv.dend <- snv %>% as.matrix() %>% #change tibble into matrix obj
  as.dist() %>% #change to distance obj
  hclust(method = "average") %>% #hierarchical clustering UPGMA
  as.dendrogram() #change to dendrogram obj

rns <- as.factor(rownames(snv)[order.dendrogram(dends[["snvphyl"]])]) #create obj of original mlst tibble rownames based on order in dendro
md <- metadata[match(rns, metadata$Key),] #match metadata row order to the rns order
md <- md %>% 
  mutate(ColoursNum = as.numeric(as.factor(md$Group))) %>% #add a col of the group numbers
  mutate(ColoursName = rainbow(max(ColoursNum))[ColoursNum]) #add a col of the colour hex, by subsetting the colours based on a vector of numbers
write_csv(md, here("data", "tanglegram_meta-with-colours.csv")) #save this data table incase its needed later

# labels_colors(dends[["wgmlst"]]) <- md$ColoursName #change dendro label colours to match the colour hex created in md tibble
# labels_colors(dends[["snvphyl"]]) <- md$ColoursName
labels_colors(dends[["snvphyl"]]) <- "black" #remove label cols as not needed
labels_colors(dends[["wgmlst"]]) <- "black"

#plot
png(here("images", "tangle-step2-compare5.png"), width = 18, height = 24, units = "in", pointsize = 10, res = 300)
# dendlist(mlst.dend, snvphyl.dend) %>% 
dends %>%
  set("branches_lwd", 1) %>%
  set("labels_cex", 0.75) %>% 
  highlight_distinct_edges(value = 1, edgePar = "lwd") %>% 
  tanglegram(main_left = "Snvphyl", 
             main_right = "wgMLST", 
             color_lines = md$ColoursName) #colour connecting lines
dev.off()

# #hclust default line colours plot
# png(here("images", "tangle-step2-test2.png"), width = 18, height = 24, units = "in", pointsize = 10, res = 300)
# # dendlist(mlst.dend, snvphyl.dend) %>% 
# dends %>%
#   set("branches_lwd", 1) %>%
#   highlight_distinct_edges(value = 1, edgePar = "lwd") %>% 
#   tanglegram(main_left = "Snvphyl", 
#              main_right = "wgMLST")
# dev.off()

# #no connecting line colours plot
# png(here("images", "tangle-step2-test4.png"), width = 18, height = 24, units = "in", pointsize = 10, res = 300)
# # dendlist(mlst.dend, snvphyl.dend) %>% 
# dends %>%
#   set("branches_lwd", 1) %>%
#   highlight_distinct_edges(value = 1, edgePar = "lwd") %>% 
#   tanglegram(main_left = "Snvphyl", 
#              main_right = "wgMLST", 
#              common_subtrees_color_lines = FALSE) #turn off connecting line colours
# dev.off()





















