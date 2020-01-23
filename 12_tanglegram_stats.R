library(dendextend)
library(dplyr)
library(here)

##STATS
load(here("data", "step2side-orders.Rdata")) #load in data

cor.dendlist(dends, method = "cophenetic") #calc cophenetic correlation matrix
# cor.dendlist(dends, method = "baker") #calc baker correllation matrix - useless in this case

# #finding exact k's for each dendro - if you didn't want to do bk
snvphyl_k <- find_k(dends[["snvphyl"]])
# plot(snvphyl_k)
mlst_k <- find_k(dends[["wgmlst"]])
# plot(mlst_k)

# cor.dendlist(dends, method = "FM_index", k = 10)
cor.dendlist(dends, method = "FM_index", k = 5) #gives actual FM_index
# cor.dendlist(dends, method = "FM_index", k = 2)
Bk(dends[["snvphyl"]], dends[["wgmlst"]], k = 5) #gives E_FM and V_FM

# cors <- cor.dendlist(dends) #default dendlist correlation matrix, believe its cophentic
# round(cors, 2) #print the matrix rounding to two decimals


dend_bk <- Bk(dends[["snvphyl"]], dends[["wgmlst"]], k = 3:250) #calc bk for k=n (n being number of dendro leaves)
plot(unlist(dend_bk)~as.numeric(names(dend_bk)), #plot only bk calc values for our tanglegram
     main = "BK plot", pch = 20,
     xlab = "k", ylab = "FM index",
     type = "b", ylim = c(0,1))

dend_bk_df <- data.frame(unlist(dend_bk)) %>% #convert bk into data frame
  na.omit() #remove k rows containing na's
write.csv(dend_bk_df, here("data", "bk_range_values.csv"))

mean(dend_bk_df$unlist.dend_bk.) #calc mean bk
min(dend_bk_df$unlist.dend_bk.) #calc min bk
max(dend_bk_df$unlist.dend_bk.) #calc max bk

png(here("images", "tangle-step2_bkplot.png"), width = 4, height = 4, units = "in", pointsize = 10, res = 300)
Bk_plot(dends[["snvphyl"]], dends[["wgmlst"]], k = 3:250, xlim = c(0,100)) #plot bk values with asymptotic values
dev.off()
#our plot shows that our values (scatter plot), does not follow the asymptotic values
#asymptotic values are what would be seen if there was no similarity between the dendro's
    