customizeTo_Dealer_Array <- function(x)
{
  temp<-NULL
  for(i in unique(rdata[,"Dealer_Id"]) ){temp[as.character(i)] = 0}
  temp <- as.array(temp)
  index <- intersect(names(x), names(temp))
  for(i in index){temp[as.character(i)] = x[as.character(i)]}
  res <- temp
}


count_of_unique <- function(x){
  length(unique(x))
}

## Repair Orders market share of each dealership
get_Ro_share_pcent <- function()
{
  unique_orders_num <- tapply(rdata$Ro_Number, rdata$Dealer_Id, count_of_unique)
  Ro_Mrkt_Share_Pcent <- (unique_orders_num / sum(unique_orders_num))*100
  dframe <- as.data.frame(Ro_Mrkt_Share_Pcent)
}

## Average Annual Growth in Repair-Order market share of each Dealership
get_Avg_AnnualGrowthPercentage_RoShare <- function()
{
  rdata$Ro_Close_Date <- as.Date(rdata$Ro_Close_Date, format = "%m/%d/%Y")
  start_date <- min(rdata$Ro_Close_Date)
  end_date <- max(rdata$Ro_Close_Date)
  
  begining <- start_date
  ending <- start_date+365
  
  
  Y1_rdata <- rdata[(which(rdata$Ro_Close_Date >= begining & rdata$Ro_Close_Date < ending)), c("Dealer_Id","Ro_Number")]
  unique_orders <- tapply(Y1_rdata$Ro_Number, Y1_rdata$Dealer_Id, count_of_unique)
  unique_orders <- customizeTo_Dealer_Array(unique_orders)
  
  previous_share <- (unique_orders / sum(unique_orders))*100
  
  yearly_growth <- NULL
  for(i in unique(rdata[,"Dealer_Id"]) ){yearly_growth[as.character(i)] = 0}
  
  for(i in 1:3)
  {
    begining <- begining+365
    ending <- ending+365
    
    yearly_rdata <- rdata[(which(rdata$Ro_Close_Date >= begining & rdata$Ro_Close_Date < ending)), c("Dealer_Id","Ro_Number")]
    unique_orders_num <- tapply(yearly_rdata$Ro_Number, yearly_rdata$Dealer_Id, count_of_unique)
    unique_orders_num <- customizeTo_Dealer_Array(unique_orders_num)
    
    Ro_share <- (unique_orders_num / sum(unique_orders_num))*100
    if(previous_share > 0)
      yearly_growth <- yearly_growth + ((Ro_share - previous_share)/previous_share)*100
    
    previous_share <- Ro_share
  }
  Ro_Avg_Annual_Growth <- yearly_growth/3.4
  dframe <- as.data.frame(Ro_Avg_Annual_Growth)
}


## Vehicles market share of each dealership
get_Vehicles_share_pcent_a <- function(x,y, T_Vehicles)
{
  vehicles_share_in_market<-NULL
  for(i in unique(x) ){vehicles_share_in_market[as.character(i)] = 1}
  
  index <- intersect(names(vehicles_share_in_market), names(y))
  if(length(index) > 0)
  {
    for(v in index){
      vehicles_share_in_market[as.character(v)] = 1/y[as.character(v)]
    }
  }
  
  pcent_share <- (sum(vehicles_share_in_market)/T_Vehicles )* 100
}

get_Vehicles_share_pcent <- function()
{
  Dealers_Shared <- tapply(rdata$Dealer_Id, rdata$VIN, count_of_unique)
  Number_of_Dealers_Sharedby_Vehicle <- (as.data.frame(Dealers_Shared))
  Number_of_Dealers_Sharedby_Vehicle <- setDT(Number_of_Dealers_Sharedby_Vehicle, keep.rownames = TRUE)[]
  colnames(Number_of_Dealers_Sharedby_Vehicle)[1] <- "VIN"
  
  #One vehicle is sometimes repaired by multiple dealers over a period of time
  Number_of_Dealers_Sharedby_Vehicle <- Number_of_Dealers_Sharedby_Vehicle[!which(Number_of_Dealers_Sharedby_Vehicle$Dealers_Shared == 1),]
  
  #Total Vehicles in the market
  total_vehicles <- length(unique(rdata[,"VIN"]))
  
  Vehicles_Mrkt_Share_Pcent <- tapply(rdata$VIN, rdata$Dealer_Id, get_Vehicles_share_pcent_a, Number_of_Dealers_Sharedby_Vehicle, total_vehicles)
  dframe <- as.data.frame(Vehicles_Mrkt_Share_Pcent)
}

## Average of the Annual Growth in Vehicle base of the Dealership
get_Avg_AnnualGrowthPercentage_VIN <- function()
{
  rdata$Ro_Close_Date <- as.Date(rdata$Ro_Close_Date, format = "%m/%d/%Y")
  start_date <- min(rdata$Ro_Close_Date)
  end_date <- max(rdata$Ro_Close_Date)
  
  begining <- start_date
  ending <- start_date+365
  
  Y1_rdata <- rdata[(which(rdata$Ro_Close_Date >= begining & rdata$Ro_Close_Date < ending)), c("Dealer_Id","VIN")]
  unique_vehicles <- tapply(Y1_rdata$VIN, Y1_rdata$Dealer_Id, count_of_unique)
  unique_orders <- customizeTo_Dealer_Array(unique_orders)
  
  previous_share <- (unique_orders / sum(unique_orders))*100
  
  yearly_growth <- NULL
  for(i in unique(rdata[,"Dealer_Id"]) ){yearly_growth[as.character(i)] = 0} 
}


###############################################################################################
##################################################### NOT USED #################################
get_Avg_Internal_Amount_Incurred <- function()
{
  internal_labour_amount_incurred <- tapply(rdata$Internal_Labor_Amount, rdata$Dealer_Id, sum)
  internal_Parts_amount_incurred <- tapply(rdata$Internal_Parts_Amount, rdata$Dealer_Id, sum)
  internal_Misc_amount_incurred <- tapply(rdata$Internal_Misc_Amount, rdata$Dealer_Id, sum)
  
  unique_orders_num <- tapply(rdata$Ro_Number, rdata$Dealer_Id, count_of_unique)
  Avg_Internal_amount_incurred <- (internal_Misc_amount_incurred + internal_Parts_amount_incurred +internal_labour_amount_incurred)/ unique_orders_num  
  
  dframe <- as.data.frame(Avg_Internal_amount_incurred)
}

##################################################################################################
