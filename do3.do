clear
use "E:\Airbnb\all_panel2.dta"
duplicates drop id2, force




*========================================================================================
*the distribution of availability days in 3 regions
*========================================================================================
*check the number of host id with respect to "calculated_host_listings_count"
 bys calculated_host_listings_count code: tabstat host_id, stats(count)

*we can see that the host ids with only one property are 11548, 11502 and 42180 in three regions 

*check their total number of host_ids
bys code: tabstat host_id, stats(count)

*then we can calculate how many host ids are with more than one perperty

*========================================================================================
*the distribution of availability days in 3 regions from year to year
*========================================================================================

*by using 
*bys calculated_host_listings_count year code: tabstat host_id, stats(count)
*however the results are too long
*better to check in each sigle dataset
