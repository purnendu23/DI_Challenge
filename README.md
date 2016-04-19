# DI_Challenge

Data: https://www.dropbox.com/s/rwb1fh74sf7l6u3/RetailOrders.tab.zip?dl=0

This sample data set describes repair order patterns at hypothetical dealerships throughout US. The data is fictional, but a good representative sample of the types of data that is encountered regularly in the car retail sector.

I have done an exploratory analysis of the data.

My goal is to set criteria for performance and find the best performing dealer. Top performing leader" should be judged on the basis of following criteria:

Quality of Service (Order completion time, Variety of services etc.)
Market/Customer share
Profit 

The file consists of repair-order entries during a 3.4 year period from 95 Dealers. During this period 655,200 cars were repaired most of which were during the third year.
After going through the data, I found that the only criteria which can be trusted from the available data would be the Market Share w.r.t "repair orders" and "unique cars serviced by each dealer"
It was not possible to know the "average time to complete a  repair order" and the variety of services was not a good enough criteria by itself.

1.)  I pick Dealer Number: 33078 as the top performing dealer. I have judged the dealers on 2 important criteria
a.) Market Share of the Repair orders 
b.) Market Share of unique vehicles serviced during this time period.

I also calculated the "Average annual growth of the market share_Repair-orders" but did not use it as a criteria. Most of the repair orders were concentrated in the third year.
The plots generated show the performance of top-6 dealers on the basis of these two criteria:

              Ro_Market_Share_Percentage          Market_Share_of_Total Vehicles Serviced


