 use "E:\Airbnb\all_panel_v2.0", clear
 
 *---------------------------------------------------------------------------------------
 *SET PANEL & TIME VAR

 order ID, first
 keep ID time availability_365 price code 
 
 xtset ID time
 
 *---------------------------------------------------------------------------------------
 *GENERATE DUMMY VARs
 
 *[1] gen spcial dummy 
 
 *dummy1= 1 if in Copenhagen 
 *       = 0 if in other two cities
 
 gen dummy1 =1 if code ==33 & code < .
 replace dummy1 =0 if code <33
 
 *check the dummy var (result should be zero)
 count if code ==33 & dummy1 ==0
 

 
 *[2] gen time dummy 
 *code: gen time dummy-gen dummy =date<mdy(month, day, year)
 
 *gen time dummy when Denmark announced the new laws for Airbnb  
 
  *dummy2= 1 if time after 04 April 2019
  *      = 0 if time before 04 April 2019
 
 gen dummy2 =time>=mdy(04,04,2019)
 count if time >= mdy(04,04,2019) & dummy2 ==0
  
  
 *gen time dummy when Denmark announced the new laws for Airbnb COME TO EFFECT 
 
  *dummy3= 1 if time after 01 July 2019
  *      = 0 if time before 01 July 2019
 
 
 gen dummy3 =time>=mdy(07,01,2019)
 count if time>=mdy(07,01,2019) & dummy3 ==0
 
  
 *gen interaction of spacil & time dummies 
 gen interdummy12 = dummy1*dummy2  
 gen interdummy13 =dummy1*dummy3  
 
 sort time 
 browse time code dummy1 dummy2 dummy3
 
 
 *----------------------------------------------------------------------------------------
 *DESCRIPTIVE ANALYSIS 
 
 xtdes 
 *"n" is very larger compared with "t"
 *that is many individual units but few time periods 
 *as for this "short panel", the data was viewed as clustered on the individual unit
 
 xtsum
 
 *check the standard deviation 
 *if "within" = 0 , the var is time-invariant 
 *if "between" = 0. the var is individual -invariant 
 *we can see that ID, code & dummy1 are time-invariant vars
 
 
 *---------------------------------------------------------------------------------
 *DATA TEST before REGRESSION 
 
 *[1] autocorrelation 
  *because the small time periods, it's hard to discuss whether there is an autocorrelation of the disturbance term, so we assume it as independent and identical
 
 *[2] multicollinearity 
 pwcorr availability_365 price dummy1 dummy2 dummy3 interdummy12 interdummy13
 
 * we can see that there is no strong correlation between each independent vars and the dependent var available_365.
 *no strong correlation between dummy1 & dummy2 or dummy1 & dummy3
 * but there is strong correlation between dummy1 & interdummy12/13 or dummy2 & interdummy12/13
 *we will see which var we need to omit in the model
 
 
 *---------------------------------------------------------------------------------
 *MODEL CHOOSING 
 
 *---------------------------------------------------
 *[1] run the regression adding dummy1 & dummy2
 
 *fixed effect:
 xtreg availability_365 price dummy1 dummy2 , fe
 
 *save estimators 
 estimate store fe_1_2
 
 *random effect (if no option, "re" by default)
 xtreg availability_365 price dummy1 dummy2 , re
 *because it use GIS, then none of the R-sq is the right one 
 *we check the significance of model by using xttest 
 xttest0
 *we can see that the model is significant as prob>chibar2=0
 estimate store re_1_2
 
 *use Hausman test 
 *null hypothesis: A REM is suitable 
 *alternative hypothesis: A REM is not suitable (then the alternative is to use a FEM)

 hausman fe_1_2 re_1_2
 
 *we can see that prob>chi=0, statistically significant.
 *there is significant difference between the coefficients of FEM & REM.
 *reject null hypothesis, use fixed effect model 
 
 *save MODEL_1
 *asdoc xtreg availability_365 price dummy1 dummy2 , fe, title(model_1 dummy1 dummy2) save(task4_reg.doc) replace 


 
 *----------------------------------------------------------------------------
 *[2] run the regression agian adding the interaction of dummy1 & 2, dummy12
 xtreg availability_365 price dummy1 dummy2 interdummy12, fe
 estimate store fe_1_2_12
 
 xtreg availability_365 price dummy1 dummy2 interdummy12, re
 estimate store re_1_2_12
 
 hausman fe_1_2_12 re_1_2_12
 *P>chi=0, significant 
 *null hypothesis rejected, use FEM
 
 *save MODEL_2
 *asdoc xtreg availability_365 price dummy1 dummy2 interdummy12, fe title(model_2: dummy1, dummy2 interdummy12) save(task4_reg.doc) append
 
 
 *------------------------------------------------------------------------------  
 *[3]see what the difference is if we change the time dummy (by using dumy3 & dummy13)
 
 *dummy3= 1 if time after 01 July 2019
 *      = 0 if time before 01 July 2019
 
 *repeat the steps 
 xtreg availability_365 price dummy1 dummy3, fe
 estimate store fe_1_3
 
 xtreg availability_365 price dummy1 dummy3, re
 estimate store re_1_3
  
 hausman fe_1_3 re_1_3 
 *P>chi=0, significant 
 *null hypothesis rejected, use FEM
 
 *save MODEL_3
 *asdoc xtreg availability_365 price dummy1 dummy3, fe title(model_3: dummy1 dummy3) save(task4_reg.doc) append

 
 *repeat the steps 
 xtreg availability_365 price dummy1 dummy3 interdummy13, fe
 estimate store fe_1_3_13
 
 xtreg availability_365 price dummy1 dummy3 interdummy13, re
 estimate store re_1_3_13
  
 hausman fe_1_3_13 re_1_3_13
 *P>chi=0, significant 
 *null hypothesis rejected, use FEM
 
 *MODEL_1
 asdoc xtreg availability_365 price dummy1 dummy2 , fe, title(model_1 dummy1 dummy2) save(task4_reg.doc), replace 
 *MODEL_2
 asdoc xtreg availability_365 price dummy1 dummy2 interdummy12, fe, title(model_2: dummy1, dummy2 interdummy12) save(task4_reg.doc), append
 *MODEL_3
 asdoc xtreg availability_365 price dummy1 dummy3, fe, title(model_3: dummy1 dummy3) save(task4_reg.doc), append
 *MODEL_4
 asdoc xtreg availability_365 price dummy1 dummy3 interdummy13, fe, title(model_4: dummy1 dummy3 interdummy13) save(task4_reg.doc), append

*see the interpretation in doc file


*-----------------------------------------------------------------------------------------------------------------------------------------------
*UPDATE
*I generated dummy4 & interdummy14 for the time 02 July 2018
*run the regression as well




 
 
 