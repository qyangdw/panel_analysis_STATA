*=======================================================================================================================================================================================
* [START 17 NOV 2020]


*===============================================================================
*                       I Graph Development of Propertires
*===============================================================================

*                        ===============================
*                             [1] All Properties
*                        ===============================


clear 
use "E:\Airbnb\all_panel_fin.dta"

*generate a new var to count the duplictes wrt the time
bysort time: egen property_n= count(time)

*set panel and time vars in panel dataset 
*command in panel analysis usually with prefix "xt"
xtset ID time

*graph Stockholm
twoway (tsline property_n) if code == 11, ytitle(Quantity) ylabel(#5, angle(horizontal)) xtitle(Time) xlabel(#12, angle(forty_five)) title(Property Development in Stockholm) name(property_st, replace)

*graph Oslo
twoway (tsline property_n) if code == 22, ytitle(Quantity) ylabel(#5, angle(horizontal)) xtitle(Time) xlabel(#12, angle(forty_five)) title(Property Development in Oslo) name(property_os, replace)

*graph Copenhagen
twoway (tsline property_n) if code == 33, ytitle(Quantity) ylabel(#5, angle(horizontal)) xtitle(Time) xlabel(#12, angle(forty_five)) title(Property Development in Copenhagen) name(property_cp, replace)


graph save "property_st" "E:\Airbnb\task3_statafiles\property_st.gph", replace
graph save "property_os" "E:\Airbnb\task3_statafiles\property_os.gph", replace
graph save "property_cp" "E:\Airbnb\task3_statafiles\property_cp.gph", replace

* combine graphs 
gr combine property_st property_os property_cp

graph save "property_cp" "E:\Airbnb\task3_statafiles\property_com.gph", replace
*then use graph editor to adjust axis and labels 




*                     =================================
*                     [2] Entire rooms & Privat rooms
*                     =================================

*                        ----------------------------
*                                  Stockholm 
*                        ----------------------------

use "E:\Airbnb\11.dta", clear


*generate a new var to count property
bysort time: egen property_n= count(time)

*encode strings to numeric long
encode room_type, gen(types) 


*[ENTIRE ROOMS]

*count the number of entire rooms/apart wrt time 
*NOTICE: can't use if types == "entire rooms/apart", use code instead (found in data viewer, click the observation)
bysort time: egen room_n = count(ID) if types == 1

*There are missing data in "room_n", use bysort: egen max() to make up the missing ones
bysort time: egen room_c = max(room_n) 
drop room_n

*[PRIVATE ROOMS]
bysort time: egen proom_n = count(ID) if types == 3
bysort time: egen proom_c = max(proom_n) 
drop proom_n
*gen prooms_r = proom_c/property_n

save, replace
*----------------------------------------------------


*graph entire rooms
xtset id time

twoway (tsline room_c), ytitle(Quantity) ylabel(#5, angle(vertical)) xtitle(Time) xlabel(#12, angle(forty_five)) title(Entire Rooms in Stockholm) name(entire_quan_st, replace) graphregion(margin(large))

*graph priavte rooms
twoway (tsline proom_c), ytitle(Quantity) ylabel(#5, angle(vertical)) xtitle(Time) xlabel(#12, angle(forty_five)) title(Private Rooms in Stockholm) name(private_quan_st,replace) graphregion(margin(large))

graph save "entire_quan_st" "E:\Airbnb\task3_statafiles\entire_quan_st.gph"
graph save "private_quan_st" "E:\Airbnb\task3_statafiles\private_quan_st.gph"
*-------------------------------------------------------------------------------


*graph entire/private rooms together
*twoway (tsline room_c) (tsline proom_c), ytitle(Quantity) ylabel(#5, angle(vertical)) xtitle(Time) xlabel(#12, angle(forty_five)) title(Stockholm) name(two_quan_st, replace) graphregion(margin(large))  legend (label(1 "Entire rooms") label(2 "Private rooms"))

*graph save "two_quan_st" "E:\Airbnb\task3_statafiles\two_quan_st.gph"
*-------------------------------------------------------------------------------




*                        ----------------------------
*                                    Oslo
*                        ----------------------------
use "E:\Airbnb\22.dta", clear


bysort time: egen property_n= count(time)
encode room_type, gen(types) 

*[ENTIRE ROOMS]
bysort time: egen room_n = count(ID) if types == 1
bysort time: egen room_c = max(room_n) 
drop room_n

*[PRIVATE ROOMS]
bysort time: egen proom_n = count(ID) if types == 3
bysort time: egen proom_c = max(proom_n) 
drop proom_n

save, replace
*------------------------------------------------------------


*graph entire rooms
xtset id time

twoway (tsline room_c), ytitle(Quantity) ylabel(#5, angle(vertical)) xtitle(Time) xlabel(#12, angle(forty_five)) title(Entire Rooms in Oslo) name(entire_quan_os, replace) graphregion(margin(large))

*graph priavte rooms
twoway (tsline proom_c), ytitle(Quantity) ylabel(#5, angle(vertical)) xtitle(Time) xlabel(#12, angle(forty_five)) title(Private Rooms in Oslo) name(private_quan_os,replace) graphregion(margin(large))


graph save "entire_quan_os" "E:\Airbnb\task3_statafiles\entire_quan_os.gph", replace
graph save "private_quan_os" "E:\Airbnb\task3_statafiles\private_qua_os.gph", replace



*                        ----------------------------
*                                  Copenhagen
*                        ----------------------------
use "E:\Airbnb\33.dta", clear

bysort time: egen property_n= count(time)
encode room_type, gen(types) 

*[ENTIRE ROOMS]
bysort time: egen room_n = count(ID) if types == 1
bysort time: egen room_c = max(room_n) 
drop room_n

*[PRIVATE ROOMS]
bysort time: egen proom_n = count(ID) if types == 3
bysort time: egen proom_c = max(proom_n) 
drop proom_n

save, replace
*--------------------------------------------------------


*graph entire rooms
xtset id time

twoway (tsline room_c), ytitle(Quantity) ylabel(#5, angle(vertical)) xtitle(Time) xlabel(#12, angle(forty_five)) title(Entire Rooms in Copenhagen) name(entire_quan_cp, replace) graphregion(margin(large))

*graph priavte rooms
twoway (tsline proom_c), ytitle(Quantity) ylabel(#5, angle(vertical)) xtitle(Time) xlabel(#12, angle(forty_five)) title(Private Rooms in Copenhagen) name(private_quan_cp,replace) graphregion(margin(large))


graph save "entire_quan_cp" "E:\Airbnb\task3_statafiles\entire_quan_cp.gph", replace
graph save "private_quan_cp" "E:\Airbnb\task3_statafiles\private_qua_cp.gph", replace
*-------------------------------------------------------------------------------------------


*use "graph combine" to combine entire/private graphs




*===============================================================================         
*                   II Graph Hosts with More than One Property                        
*===============================================================================


use "E:\Airbnb\all_panel_fin.dta", clear

*generate a new var to count hosts with more than one propterty 
bysort time: egen host_n = count(ID) if calculated_host_listings_count > 1
bysort time: egen host_c = max(host_n) 
drop host_n

*graph Stockholm
twoway (tsline host_c) if code == 11, ytitle(Quantity) ylabel(#5, angle(horizontal)) xtitle(Time) xlabel(#12, angle(forty_five)) xmtick(##12) title(Multi-property Hosts in Stockholm) name(hosts_st, replace) graphregion(margin(large))

*graph Oslo
twoway (tsline host_c) if code==22, ytitle(Quantity) ylabel(#5, angle(horizontal)) xtitle(Time) xlabel(#12, angle(forty_five)) xmtick(##12) title(Multi-property Hosts in Oslo) name(hosts_os, replace) graphregion(margin(large))

*graph Copenhagen
twoway (tsline host_c) if code == 33, ytitle(Quantity) ylabel(, angle(horizontal)) xtitle(Time) xlabel(#10, angle(forty_five)) title(Multi-property Hosts in Copenhagen) name(hosts_cp, replace) graphregion(margin(large))

*combine, edit 
graph combine hosts_st hosts_os hosts_cp

graph save "hosts_st" "E:\Airbnb\task3_statafiles\hosts_st.gph", replace
graph save "hosts_os" "E:\Airbnb\task3_statafiles\hosts_os.gph", replace
graph save "hosts_cp" "E:\Airbnb\task3_statafiles\hosts_cp.gph", replace
graph save "hosts_cp" "E:\Airbnb\task3_statafiles\hosts_com.gph", replace


*===============================================================================
*                    III Distribution of Avaliablility Days                             
*===============================================================================

use "E:\Airbnb\all_panel_fin.dta", clear

*graph Stockholm
kdensity availability_365 if code==11, ytitle(Density) xtitle(Avaliablility days) ylabel(#5, angle(horizontal))xlabel(#10, angle(forty_five)) title(Stockholm) name(kdensity_st, replace) graphregion(margin(large))

graph save "Graph" "E:\Airbnb\task3_statafiles\kdensity_st.gph", replace


*graph Oslo
kdensity availability_365 if code==22, ytitle(Density) xtitle(Avaliablility days) ylabel(#5, angle(horizontal)) xlabel(#10, angle(forty_five)) title(Oslo) name(kdensity_os, replace) graphregion(margin(large))

graph save "Graph" "E:\Airbnb\task3_statafiles\kdensity_os.gph", replace


*graph Copenhagen
kdensity availability_365 if code==33, ytitle(Density) xtitle(Avaliablility days) ylabel(#5, angle(horizontal)) xlabel(#10, angle(forty_five)) title(Copenhagen) name(kdensity_cp, replace) graphregion(margin(large))

graph save "Graph" "E:\Airbnb\task3_statafiles\kdensity_cp.gph",replace

*graph all 3 cities 
kdensity availability_365, ytitle(Density) xtitle(Avaliablility days) ylabel(#5, angle(horizontal)) xlabel(#10, angle(forty_five)) title(Total) name(kdensity_all, replace) graphregion(margin(large))

graph save "Graph" "E:\Airbnb\task3_statafiles\kdensity_all.gph", replace


*combine the graphs
graph combine  kdensity_st.gph kdensity_os.gph kdensity_cp.gph kdensity_all.gph

graph save "Graph" "E:\Airbnb\task3_statafiles\kdensity_com.gph", replace
*-------------------------------------------------------------------------------




*===============================================================================
*                  IV  Entry & Exit of Properties
*===============================================================================
*tried to use duplicates but have problem with it
*if I check the ids duplicates by time, each id in eah time only exist once
*that is 
use "E:\Airbnb\all_panel_fin.dta", clear

duplicates tag id, gen(dup1)
gen id_dup = dup1+1
drop dup1

*graph Stockholm
kdensity id_dup if code==11, ytitle(Density) xtitle(Active period (month)) ylabel(#5, angle(horizontal)) xlabel(#10, angle(forty_five)) title(Stockholm) name(enex_st, replace) graphregion(margin(large))

*graph Copenhagen
kdensity id_dup if code==22, ytitle(Density) xtitle(Active period (month)) ylabel(#5, angle(horizontal)) xlabel(#10, angle(forty_five)) title(Oslo) name(enex_os, replace) graphregion(margin(large))

kdensity id_dup if code==33, ytitle(Density) xtitle(Active period (month)) ylabel(#5, angle(horizontal)) xlabel(#10, angle(forty_five)) title(Copenhagen) name(enex_cp, replace) graphregion(margin(large))

*graph all 3 cities 
kdensity id_dup, ytitle(Density) xtitle(Active period (month)) ylabel(#5, angle(horizontal)) xlabel(#10, angle(forty_five)) title(Total) name(enex_all, replace) graphregion(margin(large))

graph combine enex_st enex_os enex_cp enex_all, title(Distribution of Active Period)

*if draw tsline, looks weird
*Stockholm, for example 
twoway (tsline id_dup) if code==11

/*then a dumb idea
* sort id from the oldest time to the newlest then drop its duplicates
*sort ids from the newest  time to the oldest then drop its duplicates
clear
use "E:\Airbnb\all_panel2.dta"
gsort - time
duplicates drop id, force
*copy the variables id, time and code to EXCEL

clear
use "E:\Airbnb\all_panel2.dta"
gsort + time
duplicates drop id, force

*copy the variables id, time and code to EXCEL

*sort them in EXCEL 
*then we can check the clear entry and exist date.
*/
*=======================================================================================================================================================================================
*[ END 1:40 17 NOV 2020]

*[UPDATE 18 NOV 2020]


*graph all types, entries & private in one pic

*Stockholm vsmall
twoway (tsline property_n) (tsline room_c) (tsline proom_c) if code ==11, ytitle(Quantity) ylabel(#10, labsize(vsmall) angle(horizontal)) xtitle(Time) xlabel(#30, labsize(vsmall) angle(forty_five)) title(Stockholm) name(alltype_st, replace) legend (label(1 "Total") label(2 "Entire rooms") label(3 "Private rooms"))

*Oslo vsmall
twoway (tsline property_n) (tsline room_c) (tsline proom_c) if code ==22, ytitle(Quantity) ylabel(#10, labsize(vsmall) angle(horizontal)) xtitle(Time) xlabel(#30, labsize(vsmall) angle(forty_five)) title(Oslo) name(alltype_os, replace) legend (label(1 "Total") label(2 "Entire rooms") label(3 "Private rooms"))

*Copenhagen vsamll
twoway (tsline property_n) (tsline room_c) (tsline proom_c) if code ==33, ytitle(Quantity) ylabel(#10, labsize(vsmall) angle(horizontal)) xtitle(Time) xlabel(#30, labsize(vsmall) angle(forty_five)) title(Copenhagen) name(alltype_cp, replace) legend (label(1 "Total") label(2 "Entire rooms") label(3 "Private rooms"))

*Total vsmall
twoway (tsline property_n if code ==11) (tsline property_n if code ==22) (tsline property_n if code ==33), ytitle(Quantity) ylabel(#10, labsize(vsmall) angle(horizontal)) xtitle(Time) xlabel(#30, labsize(vsmall) angle(forty_five)) name(alltype_all, replace) legend (label(1 "Stockholm") label(2 "Oslo") label(3 "Copenhagen"))

*graph rate 
*twoway (tsline entire_r) (tsline private_r) if code ==33, ytitle(Rate) ylabel(#10, labsize(vsmall) angle(horizontal)) xtitle(Time) xlabel(#30, labsize(vsmall) angle(forty_five)) title(Copenhagen) name(alltype_rate_cp, replace) legend (label(1 "Total") label(2 "Entire rooms") label(3 "Private rooms"))

*combine 
*graph combine alltype_st alltype_os alltype_cp alltype_all

*** draw 3 in 1

twoway (tsline property_n if code==11) (tsline property_n if code==22) (tsline property_n if code==33)

/*dummy1: 1cp 0 st 0 os
dummy 2: 1 all date for 0404/2019 or later 0 rst date

pannel regulation left ava_356 = price dummy1 dummy2 interaction of (1, 2)




