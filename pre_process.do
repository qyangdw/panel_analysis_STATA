clear
//
//generate a new variable "code = 11/22/33" in each original dataset already.

//then append them.

use "E:\SE\stockhom_panel.dta"
append using "E:\NY\Oslo_panel.dta" "E:\DK\Copenhagen_panel.dta" 
describe

//check if there are the same ids in different country.

//first, calculate each id's repeatig number in each specific city and generate the new variable "re_distirct" to save the resluts.

duplicates tag id code, gen(dup1)
gen re_distirct = dup1+1
drop dup1

//second, calculate each id's repeating number in total (without respect to any other variable) and genearate a new variable "re_total" to sav Ethel resluts 

duplicates  tag id, generate(dup2)
gen re_total = dup2+1
drop dup2

//finally, compare "re_distirct" and "re_total", if their differences between all observations are zeros that means there is no same id from different city otherwise to fix the problem 

gen diff  = re_distirct -re_total 
sum diff 
  
//we can see that "diff" =\ 0, which means there are repeating ids. 
//by duplicates we can see claerly.
//to solve the problem we add prefixs for all the ids.
save "E:\Airbnb\all_panel1.dta", replace 

clear
use "E:\SE\stockhom_panel.dta"
tostring id, replace 
gen id2 = "1"+id, after(id)
destring id2, replace 
save "E:\Airbnb\11.dta", replace  


clear
use "E:\NY\Oslo_panel.dta"
tostring id, replace 
gen id2 = "2"+id, after(id)
destring id2, replace 
 save "E:\Airbnb\22.dta", replace  

clear
use "E:\DK\Copenhagen_panel.dta"
tostring id, replace 
gen id2 = "3"+id, after(id)
destring id2, replace 
save "E:\Airbnb\33.dta", replace 

clear 
use "E:\Airbnb\11.dta"
append using "E:\Airbnb\22.dta" "E:\Airbnb\33.dta"

save "E:\Airbnb\all_panel2.dta", replace

//now check the duplicates again 
duplicates tag id2 code, gen(dup1)
gen re_distirct = dup1+1
drop dup1

duplicates  tag id2, generate(dup2)
gen re_total = dup2+1
drop dup2

gen diff  = re_distirct -re_total 
sum diff 
//now mean of "diff" = zerp, no repeating ids.
save "E:\Airbnb\all_panel2.dta", replace


 
 
