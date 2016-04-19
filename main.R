
  library(data.table)
  library(dplyr)
  
  source("functions_features.R")
  ### Reading and cleaning data
  
  rdata <- fread("RetailOrders.tab", sep = "\t", header = TRUE)
  rdata <- as.data.frame(rdata)
  #drops = c("Vehicle_Category", "Warranty_Labor_Amount", "Warranty_Parts_Amount", "Warranty_Misc_Amount", "Internal_Misc_Amount", "Exception")
  #rdata <- rdata[,!(colnames(rdata) %in% drops)]
  
  ### Setting up a new Data frame for collecting features in the columns
  
  perf_frame <- data.frame(c(unique(rdata$Dealer_Id)))
  colnames(perf_frame) <- c("Dealer_Id")
  
  ### Call the functions to get the features in the form of 2-Dim data frame.
  
  feature_function_list <- c(get_Ro_share_pcent, get_Avg_AnnualGrowthPercentage_RoShare, get_Vehicles_share_pcent)
  
  for(func in feature_function_list )
  {
    df <- func()
    df <- setDT(df, keep.rownames = TRUE)[]
    colnames(df)[1] <- "Dealer_Id"
    perf_frame <- merge(perf_frame,df,by=c("Dealer_Id","Dealer_Id"))
  }
  
  ## perf_frame is the data frame with 3 features.
  f1 <-head(perf_frame[order(perf_frame["Ro_Mrkt_Share_Pcent"] , decreasing = TRUE),]) 
  f2 <-head(perf_frame[order(perf_frame["Vehicles_Mrkt_Share_Pcent"] , decreasing = TRUE),]) 
  f3 <- perf_frame[order(perf_frame["Ro_Avg_Annual_Growth"] , decreasing = TRUE),]
  

  
#Plotting commands used after the main:
barplot(f1$Ro_Mrkt_Share_Pcent, names.arg = f1$Dealer_Id, xlab = "Dealer_Id", ylab = "Repair Order Market Share Percentage",  main = "Top 6 Dealer-ships by Market Share of Repair Orders", ylim = c(0,6))
barplot(f2$Vehicles_Mrkt_Share_Pcent, names.arg = f2$Dealer_Id, xlab = "Dealer_Id", ylab = "Vehicles Serviced- Market Share Percentage",  main = "Top 6 Dealer-ships by Market Share of Vehicles", ylim = c(0.0,4.5))