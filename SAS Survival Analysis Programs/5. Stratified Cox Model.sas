%let path=/home/ajay_malkani0/Survival Analysis data sets; 
libname Surv_Ana "&path";

ods pdf file="&path/5. Stratified_Cox_Model.pdf" style=SasWeb;

/* Running a stratified cox model */

/* A stratified cox model is constructed when one or more variables in the model is fails to meet the 
/* Cox proportional hazard assumption. */

proc phreg data=surv_Ana.addicts;
model survt*status(0)= Prison Dose / RL;
strata clinic;
run;

/* Assessing the inclusion of interaction terms Prison*Clinic and Dose*Clinic in the stratified cox model
contructed above */

/* As before use a data set to define the interactions to be included in the model */

data surv_Ana.addicts3;
	set surv_ana.addicts;
	Clin_Pr=Clinic*Prison;
	Clin_Do=Clinic*Dose;
run;

/* Insertion of interaction terms in stratified Cox model */

/* HR = h_0(t)exp[1Beta_1 + Beta_2DOSE + (2)(1)Beta_3 + Beta_4Clin_Do] = exp(Beta_1 + 2Beta_3) */
/* 		--------------------------------------------------------------                         */
/*		h_0(t)exp[0Beta_1 + Beta_2DOSE + (2)(0)Beta_3 + Beta_4Clin_Do]						   */


/* On LHS, Beta_2DOSE and Beta_4Clin_Do cancel. 0*Beta_1 = 0 cancels, (2)*(0)*Beta_3 cancels. 
(2)(1)Beta_3 represents four different combinations;

1st contrast - Prison among clinic 1

Prison = 1 
----------- and Clinic=1 controlling for dose = exp(Beta_1 + 1Beta_3)
Prison = 0 


2nd contrast - Prison among clinic 2

Prison = 1
----------- and Clinic=2 controlling for dose = exp(1 + 2Beta_3)
Prison = 0 


3rd Contrast - Test for interaction terms

Prison = 1 versus interaction(prison=1 * Clinic=2) controlling for dose)
-----------------------------------------------------------------------------  = exp(Beta_1 + 2Beta_3)
Prison = 0 versus interaction(prison=0 * Clinic=2) controlling for dose)


*/

proc phreg data=surv_ana.addicts3;
model survt*status(0) = Prison Dose Clin_Pr Clin_Do;
strata Clinic;
contrast 'HR for prison among clinic=1' Prison 1 Clin_Pr 1/estimate=exp;
contrast 'HR for prison among clinic=2' Prison 1 Clin_Pr 2/estimate=exp;
contrast "TEST INTERACTION" Clin_PR 1, Clin_Do 1;
title 'Stratified Cox model giving the HR for prison among Clinics 1 and 2 and the test for interaaction';
run;
title;


/* Alternatively run two separate models using the subsetting WHERE statement as follows for clinic 1*/

proc phreg data=surv_ana.addicts3;
	model survt*status(0)= Prison Dose;
	where clinic=1;
	title'Cox model run only on data where clinic=1';
run;
title;

/* Alternative model for clinic 2 patients only */

proc phreg data=surv_ana.addicts3;
	model survt*status(0)= Prison Dose;
	where clinic=2;
	title'Cox model run only on data where clinic=2';
run;
title;

ods pdf close;







