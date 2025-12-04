%let path=/home/ajay_malkani0/Survival Analysis data sets; 
libname Surv_Ana "&path";

ods pdf file="&path/7. Obtaining_Cox_Adjusted_Survival_Curves.pdf" style=SasWeb;

/* Obtaining Cox Adjusted Survival Curves */

/* There are three steps involved in general:

1) Create the input dataset containing the pattern (values) of covariates used for the adjusted survival
curves. 

2) Run a Cox model with PROC PHREG using the BASELINE statement to input the dataset from step (1) and 
output a dataset containing the adjusted survival estimates.

3) Plot the adjusted survival estimates from the output dataset created in step (2).


/* Exercise 1 - Run a PH model using PRISON, DOSE, and CLINIC and obtain adjusted survival curves where 
PRISON=0, DOSE=70MG, and CLINIC=2 */

/* 1*/

data surv_ana.in1;
input prison dose clinic;
cards;
0 70 2
;

/* 2*/

proc phreg data=surv_ana.addicts;
model survt*status(0)=Prison Dose Clinic;
Baseline covariates=surv_ana.in1 out=surv_ana.out1 survival=s1/nomean;
run;

/* 3*/

proc sgscatter data=surv_ana.out1;
		plot s1*survt;
		title 'Adjusted survival for prison=0, dose=70, clinic=2';
		label survt='Survival time in days';
run;
title;


/* Exercise 2 - Run a stratified Cox model (by CLINIC). Obtain two adjusted survival curves using the 
mean value of PRISON and DOSE for CLINIC=1 and CLINIC=2. Use the log log curves to assess the PH assumption
for CLINIC adjusted for PRISON and DOSE. */

/*1 and 2 - There is no need for an input dataset as in exercise 1 because the PROC PHREG step creates a 
dataset based on the mean values of the covariates in the model as long as the NOMEAN option in the 
baseline statement is NOT used. */

proc phreg data=surv_Ana.addicts;
model survt*status(0)= Prison Dose / RL;
strata clinic;
Baseline out=surv_ana.out2 survival=S2 loglogs=LS2;
run;

/* 3 */

/* Adjusted survival curve stratified by clinic */

proc sgscatter data=surv_ana.out2;
		plot S2*survt / group=clinic;
		title 'Adjusted survival stratified by clinic';
		label survt='Survival time in days';
run;
title;

/* Adjusted log-log survival curves stratified by clinic adjusted for prison and dose */

proc sgscatter data=surv_ana.out2;
		plot LS2*survt / group=clinic;
		title 'log-log curves stratified by clinic, adjusted for prison and dose';
		label survt='Survival time in days';
run;
title;



/* Excercise 3 - Run a stratified Cox model (by CLINIC) and obtain adjusted survival curves for PRISON=0, 
DOSE=70 and for PRISON=1, DOSE=70. This yields four survival curves in all, two for CLINIC=1 and two for
 CLINIC=2. */

/*1*/

data surv_ana.in3;
input prison dose;
cards;
1 70
0 70
;

/*2*/

proc phreg data=surv_ana.addicts;
model survt*status(0)= Prison Dose;
strata clinic;
Baseline covariates=surv_ana.in3 out=surv_ana.out4 survival=S3/nomean;
title'Cox PH model stratified for clinic';
run;
title;

/*3*/

proc sgscatter data=surv_ana.out4;
		plot S3*survt / group=clinic;
		title 'Adjusted survival stratified by clinic for both levels of prison';
		label survt='Survival time in days';
run;
title;

ods pdf close;



