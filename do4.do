*===============================================================================
*entry & exist of properties 
*===============================================================================
*tried to use duplicates but have problem with it
*if I check the ids duplicates by time, each id in eah time only exist once
*that is 
clear
use "E:\Airbnb\all_panel2.dta"
duplicates tag id2 time, gen(dup1)
gen re_time = dup1+1
drop dup1
*each value of "re_time" = 1

*then a dumb idea
* sort id2 from the oldest time to the newlest then drop its duplicates
*sort ids from the newest  time to the oldest then drop its duplicates
clear
use "E:\Airbnb\all_panel2.dta"
gsort - time
duplicates drop id2, force
*copy the variables id2, time and code to EXCEL

clear
use "E:\Airbnb\all_panel2.dta"
gsort + time
duplicates drop id2, force

*copy the variables id2, time and code to EXCEL

*sort them in EXCEL 
*then we can check the clear entry and exist date.

*but also we can generate a yearly time variable 

clear
use "E:\Airbnb\all_panel2.dta"
gen year = year(time), after(time)

duplicates tag year id2, gen(dup1)
gen re_year = dup1+1
drop dup1

duplicates tag time id2, gen(dup1)
gen re_time = dup1+1
drop dup1

gen exisitence = re_year-re_time, after(id2)

duplicates drop id2, force

sort exisitence
list id2 exisitence time year in 1/100

*by looking at the "exisitence"
*if the value =0, in the year corresponded, the id has entered and exited in the same yearly
*if the value >0, we can see how many times the ids exist during the yearly

*save as all_panel5.dta
*===============================================================================
*ONE MORE THING FOR ALL 
*I  tried  to summarize the describtive satistics by using the pannel data commands
*However, it can't fufill all my needs. 


