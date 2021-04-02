clear
use "E:\Airbnb\all_panel2.dta", clear


*========================================================================================
*check the number and development of sharing houses with respect to time
*in 3 regions
*========================================================================================
*drop reapting obsrevations to calculate total amount of ids in thre cities in different time periods.
duplicates drop id2, force

*[1]check the number of sharing properties in 3 citires with respect to monthly time 
bys time code: tabstat id2, stats(count)
*11= Stockholm 22=Oslo 33=Copenhagen

*outreg2 using changes.xlxs, replace 
*I want to export it in word/excel but it turned out to be a massy but collect them by hands would be low efficient.
*PROBLEM NEED TO BE SOLVED.

*[2]check the change of numbers with respect to yearly time
gen year=year(time), after(time)
bys year code: tabstat id2, stats(count)
*11= Stockholm 22=Oslo 33=Copenhagen




*========================================================================================
*check the availability days with respect to time
*in 3 regions
*========================================================================================

*[1]check the availability days in 3 citires with respect to monthly time 
bys time code: tabstat availability_365, stats(mean)
*11= Stockholm 22=Oslo 33=Copenhagen
*I use mean values instead 

*[2]check the availability days with respect to yearly time

bys year code: tabstat availability_365, stats(mean)
*11= Stockholm 22=Oslo 33=Copenhagen
*I use mean values instead 


*========================================================================================
*the diffrences among room types with respect to time in 3 regions druing the development 
*========================================================================================

* encode the room_type from strings first 
encode room_type, gen(type)

*check the diffrences among room types with respect to time in 3 regions druing the development 
bys type time code: tabstat id2, stats(count)
*same problem with export

*check with yearly time
bys type year code: tabstat id2, stats(count)


*========================================================================================
*the distribution of availability days in 3 regions
*========================================================================================
*check the number of sharing houses with respect to availability days in 3 regions
bys availability_365 code: tabstat id2, stats(count)
* the same problem again, the resluts are too long to be collected 
**we can see how many houses are not active and how many are alomost shared for the whole year 


*PROBLEM: 
*can't export prepperly thus can't check the development clearly










