library(dendextend)
library(here)
#load data
load(here("data", "mlst-dend-coloured.Rdata"))
load(here("data", "snv-dend-coloured.Rdata"))

#plot
png(here("images", "tangle-step2.png"), width = 18, height = 24, units = "in", pointsize = 10, res = 300)
dendlist(snv.dend, mlst.dend) %>%
  set("branches_lwd", 2) %>% #bold branch line widths
  highlight_distinct_edges(value = 1, edgePar = "lwd") %>%  #thin line width of distinct branches
  untangle(method = "step2side") %>% #make layout better
  tanglegram(sub = "test", main_left = "snvphyl", main_right = "wgMLST") %>% 
  entanglement()
dev.off()
