clear
. ***********************************************
. * Set relative paths to the working directory
. ***********************************************
global AVZ "/Users/eleonor/Documents/Long"
global MY_IN_PATH "/Users/eleonor/Documents/Long/v35_STATA+EN"
global MY_DO_FILES "$AVZ/do/"
global MY_LOG_OUT "$AVZ/log/"
global MY_OUT_DATA "$AVZ/output/"
global MY_OUT_TEMP "$AVZ/temp/"

clear
use "${MY_IN_PATH}/ppathl.dta"
label language EN
save "${MY_IN_PATH}/ppathl.dta", replace 

clear 
use "${MY_IN_PATH}/pgen.dta"
label language EN
save "${MY_IN_PATH}/pgen.dta", replace 

clear
use "${MY_IN_PATH}/bioimmig.dta"
label language EN
save "${MY_IN_PATH}/bioimmig.dta", replace 

clear
use "${MY_IN_PATH}/bioagel.dta"
label language EN
save "${MY_IN_PATH}/bioagel.dta", replace 

*===============================================================================
*** Merge   

clear 
use pid syear sex gebjahr netto pop phrf sampreg corigin immiyear migback arefback using "${MY_IN_PATH}/ppathl.dta", clear

merge 1:1 pid syear using "${MY_IN_PATH}/pgen.dta", keepus(pgbilzeit pgpsbil pgpbbil02 pgpsbilo pgpsbila pglabgro pgtatzeit pgfamstd pgemplst pgexpft pgexppt pgnace2 pgallbet ) keep(master match) nogen 

merge 1:1 pid syear using "${MY_IN_PATH}/pequiv.dta", keepus(e11106) keep(master match) nogen

save "/Users/eleonor/Documents/Long/output/panel_1.dta", replace 

clear
use "${MY_OUT_DATA}/panel_1.dta"
merge 1:1 pid syear using "${MY_IN_PATH}/biobirth.dta", keepus(biokids kidgeb01 kidgeb02 kidgeb03 kidgeb04 kidgeb05 kidgeb06 kidgeb07 kidgeb08 kidgeb09 kidgeb10 kidgeb11 kidgeb12 kidgeb13 kidgeb14 kidgeb15) keep(master match) nogen 
save "${MY_OUT_DATA}/panel_2 .dta", replace  

clear
use "${MY_OUT_DATA}/panel_2.dta"
merge 1:1 pid syear using "${MY_IN_PATH}/bioimmig.dta", keepus( biimgrp bicampm bifamc biexpr biexprac biexpran birelhs2 biscger) keep(master match) nogen 
save "${MY_OUT_DATA}/panel_3.dta", replace 

*===============================================================================
*** Wash data 
* only select people with completed interviews
keep if inrange(netto, 10, 19)
*drop if inrange(netto, 30, 39)
*drop if inrange(netto, 89, 99)

* only private households
keep if pop==1 | pop==2

save "${MY_OUT_DATA}/panel_final.dta", replace 

* select the year 
keep if syear ==2017
save "${MY_OUT_DATA}/2017.dta",replace

keep if syear==2018
save "${MY_OUT_DATA}/2018.dta",replace





*===============================================================================

*** Prepare the dataset

* a) load data set & check duplicates 
clear
use "${MY_OUT_DATA}/2018.dta"
duplicates examples pid

* b) recode misiings 
mvdecode _all, mv(-8/-1 = .)

* c) wage 

* hourly wage 
gen wage = pglabgro/(4.33*pgtatzeit) if pglabgro>=1 & pgtatzeit>=1

* log hourly wage(adjusted)
sum wage, detail
replace wage = 1/3*r(p1) if wage<1/3*r(p1)
replace wage = 3*r(p99) if wage>3*r(p99) & wage<.

gen lwage = log(wage)
label variable lwage "Log hourly wage"


* d) age 
gen age = syear - gebjahr

* f) gender
recode sex (-1 = -1 "-1_No answer") (1 = 0 "0_Male") (2 = 1 "1_Female"), gen(gender)

* e) marriage status 
gen married = 1 if pgfamstd==1 | pgfamstd==6 | pgfamstd==7 | pgfamstd==8
replace married = 0 if inrange(pgfamstd, 2, 5)


* g) refugee & native 
*drop indrect background
drop if migback ==3 & arefback==1
drop if migback ==3 & arefback==3
drop if migback ==2 & arefback==1

drop if arefback==3
gen escape=0 if arefback==1
replace escape=1 if arefback==2
label variable escape "Direct refugee background"

* h) country of origin 



* i) contact with family in DE
recode bifamc (1 = 1 "1_Yes") (2 = 0 "0_No"), gen(contact)

* j) spouse in DE
recode birelhs2 (1 2 = 1 "1_Yes") (3 = 0 "0_No"), gen(spouse)

* k) have a child age 0_5

gen c1= syear - kidgeb01 

gen c2= syear - kidgeb02

gen c3= syear - kidgeb03 

gen c4= syear - kidgeb04 

gen c5= syear - kidgeb05

gen c6= syear - kidgeb06

gen c7= syear - kidgeb07 

gen c8= syear - kidgeb08 

gen c9= syear - kidgeb09 

gen c10= syear - kidgeb10 

gen c11= syear - kidgeb11 

gen c12= syear - kidgeb12

gen c13= syear - kidgeb13

gen c14= syear - kidgeb14

gen c15= syear - kidgeb15

replace c1=1 if c1<=5 
replace c1=0 if c1>5

replace c2=1 if c2<=5 
replace c2=0 if c2>5

replace c3=1 if c3<=5 
replace c3=0 if c3>5

replace c4=1 if c4<=5 
replace c4=0 if c4>5

replace c5=1 if c5<=5 
replace c5=0 if c5>5

replace c6=1 if c6<=5 
replace c6=0 if c6>5

replace c7=1 if c7<=5 
replace c7=0 if c7>5

replace c8=1 if c8<=5 
replace c8=0 if c8>5

replace c9=1 if c9<=5 
replace c9=0 if c9>5

replace c10=1 if c10<=5 
replace c10=0 if c10>5

replace c11=1 if c11<=5 
replace c11=0 if c11>5

replace c12=1 if c12<=5 
replace c12=0 if c12>5

replace c13=1 if c13<=5 
replace c13=0 if c13>5

replace c14=1 if c14<=5 
replace c14=0 if c14>5

replace c15=1 if c15<=5 
replace c15=0 if c15>5


egen nchild5 =rowtotal(c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15)

label variable nchild "Number of children 0 to 5"

// * occupation sectors 
// gen sectors = .
// replace sectors=1 if inrange(pgnace2, 1,2) //agri
// replace sectors=2 if inrange(pgnace2, 5,9) //min
// replace sectors=3 if inrange(pgnace2, 10,33) //manu
// replace sectors=4 if inrange(pgnace2, 35,39) //energy 
// replace sectors=5 if inrange(pgnace2, 41,43) //tranportation
 
// replace sectors=6 if inrange(pgnace2, 55,56) //service 
// replace sectors=6 if inrange(pgnace2, 94,96) //service 
 
// replace sectors=7 if inrange(pgnace2, 58,63) //info and communication 
// replace sectors=8 if inrange(pgnace2, 64,68) //finance 
// replace sectors=9 if inrange(pgnace2, 69,75) //tech

// replace sectors=10 if inrange(pgnace2, 77,84) //public & socail work 
// replace sectors=10 if inrange(pgnace2, 86,88) //public & socail work 

// replace sectors=11 if pgnace2==85 //education 
// replace sectors=12 if inrange(pgnace2, 90,93) // art, entertain 

* l) schooling & degree 
recode pgbilzeit(7 8.5=0 "Less than primary school education") (9=1 "Primary school education") (10 10.5 11 11.5 12=2 "Intermediary school education") (13 13.5 14 14.5=3 "High school education") (15 16 17 18=4 "Tertiary education"), gen(edu)

* m) working experience & *^2
 egen experience =rowtotal(pgexpft pgexppt) 
 gen experience2 =experience^2
 
 * n) employment status 
recode pgemplst (-3 -2 -1 5= 0 "0_No answer") (1 = 1 "1_Full time") (2 = 2 "2_Part time(regular)") (3 4 6 = 3 "3_Other temporal work"), gen(employ_status)

* o) firm size 
recode pgallbet (1 = 1 "Micro") (2 = 2 "Small") (3=3 "Medium") (4=4 "Large") (5=5 " Self-Employed Without Coworkers"), gen(firm)

*r) sectors 
* no need to change 
* pay attention "0" not applicable 
rename e11106 sectors

save, replace

keep pid syear escape sampreg lwage gender age married nchild5 edu experience experience2 firm employ_status sectors contact spouse corigin biexpr biexprac biexpran

save "${MY_LOG_OUT}/lwage2018.dta", replace 

*===============================================================================

*	sequence analysis	*

*===============================================================================

*============= clean ==========================================================*
*use my final merged dataset
clear
use "/Users/eleonor/Documents/Long/output/panel_final.dta", clear

*drop indrect background
drop if migback ==3 & arefback==1
drop if migback ==3 & arefback==3
drop if migback ==2 & arefback==1

drop if arefback==3
gen escape=0 if arefback==1
replace escape=1 if arefback==2
label variable escape "Direct refugee background"

*only keep the id, order and element (and background) variables
keep pid syear pgemplst escape
keep if escape==1
rename pgemplst st
*selelct five types of element
drop if st==6 

*select a squence year
keep if syear>=201#

/*codebook pgemplst *here is a way to delete the gapsbut can't make sure every pid has the same starting and ending points
drop if pgemplst ==.
drop if pgemplst<=0
reshape wide pgemplst, i(pid) j(syear)

reshape long pgemplst, i(pid) j(syear)*/


*sequence analysis request the year has no gaps and strongly balanced
*check gaps
xtset pid syear 
*keep pid that only have continuous answers during time. # is the number of years 
bys pid:keep if _N==# 

tab syear
*======================== end of cleaning =====================================*


/*
gen dsyear=d.syear 
bysort pid: replace dsyear=1 if _n==1
bysort pid: egen miss=max(cond(dsyear==.),1,0)
drop if miss==1
rename pgemplst st
*/

/*bro
misstable summarize pid syear st

bys pid: replace st=st[_n-1] if mi(st)*/

/*reshape wide st, i(pid) j(syear) 
*check gaps
xtset pid syear 
gen dsyear=d.syear 
bysort pid: replace dsyear=1 if _n==1
bysort pid: egen miss=max(cond(dsyear==.),1,0)
drop if miss==1
rename pgemplst st
*/

*===== set sq form (notice that many commands need to add ¨sd¨ in front) ======*
*reshape to long form
reshape long st, i(pid) j(syear)
xtset pid syear 
*set the datasetto sq form, just like ¨xtset¨, ¨trim¨ is the option to keep the same length of years (order variable)
sqset st pid syear, trim
*check 
sqtab, ranks (1/10)
*describe 
sqdes

*generate the length (can be a varibale or a constant, in balance panal, it's usually a constant)
egen length = sqlength()
tab length

*check the first person's length.*
egen length1 = sqlength(), element(1)  
tab length1 if pid == 1021602

*design matrix (it defines the distance from onr state to another, eg. from unemployment to regular_partime is 2, and to *fulltime_emplyment is a greater change, can be 4 - you can do it mannually in word)
matrix mvdanes = (0,2,1,3,4\2,0,1,1,3\1,1,0,2,1\3,1,2,0,2\4,3,1,2,0) 
*pay attention that ¨/¨defines the verctor!, ¨\¨(option + shift + 7) defines columns of matrix *

*no need in modern stata
set matsize 4000

*reshaoe to caculate distance
reshape wide st, i(pid) j(syear) 
oma st201#-st2018, subsmat(mvdanes) pwd(omd) length(#length) indel(1.5) 
* oma, length() could contain a variable *

*reshape to define transit martirx
preserve
reshape long st, i(pid) j(syear)
trans2subs  st, id(pid) subs(tpr1)
matrix list tpr1

trans2subs st, id(pid) subs(tpr2) diag
matrix list tpr2

*rememnber to save 
restore

*calculate distance by oma agian  
oma  st201#-st2018, subsmat(tpr1) pwd(tpr) length(l#ength) indel(1.5)

corrsqm omd tpr 
* compare distcance between two martrix (the closer, the better)*

*======================== end of setting the sequence =========================*

*======================== cluster method ======================================*
*cluster by using ward method ¨樹形圖¨

clustermat wards omd, name(oma) add

*define the groups (here is an example of 4 and 6 groups) - it depends on the research purpose and sample size 
cluster generate o=groups(4 6)

*check each groups's obs
tab o4

tab o6

*generate stripe and give symboys to it (ABCDEF by default)
sdstripe st201#-st2018, gen(seqstr) symbols("12345")

*check first 5 of the sequence 
list seqstr in 1/5, clean

*=============== plotting =====================================================*
*reshape to wide to draw grams by groups, thus can see clear trajectory of each group 
reshape wide st, i(pid) j(syear)
* # is the number of groups
sdchronogram st*, by(o#) name(chronogram, replace)


*resahpe to draw a simple gram without clustering 
reshape long st, i(pid) j(syear)
sqindexplot

* another way to show the transition pattern 
trprgr st*, gmax(485)










* sample for teaching *





. use http://teaching.sociology.ul.ie/bhalpin/mvad 

. reshape long state, i(id) j(order) 
(note: j = 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33
>  34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 6
> 6 67 68 69 70 71 72)

Data                               wide   ->   long
-----------------------------------------------------------------------------
Number of obs.                      712   ->   51264
Number of variables                  86   ->      16
j variable (72 values)                    ->   order
xij variables:
              state1 state2 ... state72   ->   state
-----------------------------------------------------------------------------

. sqset st id order   

       element variable:  state, 1 to 6
       identifier variable:  id, 1 to 712
       order variable:  order, 1 to 72

. egen length = sqlength()  

. reshape wide state, i(id) j(order)
(note: j = 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33
>  34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 6
> 6 67 68 69 70 71 72)

Data                               long   ->   wide
-----------------------------------------------------------------------------
Number of obs.                    51264   ->     712
Number of variables                  17   ->      87
j variable (72 values)            order   ->   (dropped)
xij variables:
                                  state   ->   state1 state2 ... state72
-----------------------------------------------------------------------------

. matrix mvdanes = (0,1,1,2,1,3 \1,0,1,2,1,3 \1,1,0,2,1,2 \2,2,2,0,1,1 \1,1,1,1,0,2 \3,3,2,1,2,0 )

.                   
.                   
.                   
.                   
.                   
. set matsize 4000
set matsize ignored.
    Matrix sizes are no longer limited by c(matsize) in modern Statas.  Matrix sizes are now
    limited by flavor of Stata.  See limits for more details.

. 
. 
. . oma state1-state72, subsmat(mvdanes) pwd(omd) length(72) indel(1.5)
Not normalising distances with respect to length
(0 observations deleted)
557 unique observations

. . preserve

. . reshape long state, i(id) j(m)
(note: j = 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33
>  34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 6
> 6 67 68 69 70 71 72)

Data                               wide   ->   long
-----------------------------------------------------------------------------
Number of obs.                      712   ->   51264
Number of variables                  87   ->      17
j variable (72 values)                    ->   m
xij variables:
              state1 state2 ... state72   ->   state
-----------------------------------------------------------------------------

. . trans2subs   state, id(id) subs(tpr1)
(712 missing values generated)
Generating transition-driven substitution matrix

. . matrix list tpr1

symmetric tpr1[6,6]
          c1        c2        c3        c4        c5        c6
r1         0
r2  1.147539         0
r3  1.064734  1.849958         0
r4  1.643575  1.757525  1.671111         0
r5  1.182927  1.844291      1.96   1.90181         0
r6  1.207729  1.525335  1.831594  1.803575  1.608297         0

. . trans2subs state, id(id) subs(tpr2) diag
(712 missing values generated)
Generating transition-driven substitution matrix

. 
. . matrix list tpr2

symmetric tpr2[6,6]
          c1        c2        c3        c4        c5        c6
r1         0
r2  1.967601         0
r3   1.98727  1.993341         0
r4  1.984684  1.987531  1.982969         0
r5  1.959993  1.992045  1.999488  1.994867         0
r6  1.951231   1.96336  1.996033  1.985649  1.972029         0

. 
. restore

. corrsqm omd tpr
Matrices are not the same size

. oma        state1-state72, subsmat(tpr1) pwd(tpr) length(72) indel(1.5)
Not normalising distances with respect to length
(0 observations deleted)
557 unique observations

. corrsqm omd tpr
VECH correlation between omd and tpr: 0.7726

. 
. clustermat wards omd, name(oma) add

. cluster generate o=groups(8 12)

. tabo8
command tabo8 is unrecognized
r(199);

. tabo8
command tabo8 is unrecognized
r(199);

. tab o8

         o8 |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |         93       13.06       13.06
          2 |        139       19.52       32.58
          3 |         62        8.71       41.29
          4 |        146       20.51       61.80
          5 |         93       13.06       74.86
          6 |         30        4.21       79.07
          7 |         47        6.60       85.67
          8 |        102       14.33      100.00
------------+-----------------------------------
      Total |        712      100.00

. stripe state1-state72, gen(seqstr) symbols("EFHSTU")  
command stripe is unrecognized
r(199);

. sdstripe state1-state72, gen(seqstr) symbols("EFHSTU")  
Creating long string representation

. list seqstr in 1/5, clean

                                                                         seqstr  
  1.   TTEEEETTEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE  
  2.   UUFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH  
  3.   UUTTTTTTTTTTTTTTTTTTTTTTTTFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEEEEEEEEEUU  
  4.   TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTEEEEEEEEEEEEEEUUUUUUUUU  
  5.   UUFFFFFFFFFFFFFFFFFFFFFFFFFHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH  

. discrepancy o8, dist(omd) id(id) dcg(dx) niter(1)
command discrepancy is unrecognized
r(199);

. sort o8 dx
variable dx not found
r(111);

. by o8: gen medoid = _n==1
not sorted
r(5);

. list o8 dx seqstr if medoid, clean
variable dx not found
r(111);

. 
. sddiscrepancy o8, dist(omd) id(id) dcg(dx) niter(1)
command sddiscrepancy is unrecognized
r(199);

. 
. sdiscrepancy o8, dist(omd) id(id) dcg(dx) niter(1)
command sdiscrepancy is unrecognized
r(199);

. 
. sdstripe state1-state72, generate(seqstrxt) symbols("EFHSTU") xt
Creating condensed string representation

. > xtspellsep("/") xtdursep(":")
> is not a valid command name
r(199);

. Creating condensed string representation
command Creating is unrecognized
r(199);

. . list seqstrxt in 1/5, clean

            seqstrxt  
  1.       T2E4T2E64  
  2.        U2F36H34  
  3.   U2T24F34E10U2  
  4.        T49E14U9  
  5.        U2F25H45  

. save "/Users/eleonor/Documents/Long/sq_sample.dta"
file /Users/eleonor/Documents/Long/sq_sample.dta saved

.  sdchronogram state*, by(o8, legend(off)) name(chronogram, replace)
sdchronogram is deprecated: it still works but sdchronoplot is preferred
(0 observations deleted)
Creating chronogram data
Categories between 1 and 6
Drawing chronogram






