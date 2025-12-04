%let path=/home/ajay_malkani0/Survival Analysis data sets; 
libname Surv_Ana "&path";

ods pdf file="&path/4. Cox_Proportional_Hazard_(PH)_Model.pdf" style=SasWeb;

/*Cox PH model with default method for tied events being the Breslow method*/

proc phreg data=surv_ana.addicts;
	model survt*status(0)=Prison Dose Clinic / rl=pl;
run;

/*Cox PH model with the Exact method for tied events, the method is prefered if there are many tied events*/

proc phreg data=surv_ana.addicts;
	model survt*status(0)=Prison Dose Clinic / ties=exact rl=pl;
run;

/* Cox PH model with Efron method for tied events */

proc phreg data=surv_ana.addicts;
	model survt*status(0)=Prison Dose Clinic / ties=efron rl=pl;
run;

/* Testing for an interation between variables in the model */

/* 1. Define the interactions with a DATA step first then insert the interactions in the model */

data surv_ana.addicts2;
	set surv_ana.addicts;
	Clin_Pr=Clinic*Prison;
	Clin_Do=Clinic*dose;
run;

/* 2. Insert interactions defined above into Cox PH model, The contrast statement
 tests the two interactions simultaneously with a generalized Wald test*/

proc phreg data=surv_ana.addicts2;
	model survt*status(0)= Prison Dose Clinic Clin_Pr Clin_Do;
	contrast "TEST INTERACTION" Clin_Pr 1, Clin_Do 1;
run;

/* 3. Likelihood ratio statistic (LRT) to simultaneously test the two product terms in the model
 (Full Model) with the model without the product terms included (Reduced Model) by subtracting the 
 -2log-likelihood terms for both models to obtain p-value from chi-square tests. */

/* Use a DATA step */

data test;
reduced = -1346.805;
full = -1343.199;
df = 2;
diff = full - reduced;
/* 1 - probchi needs to be written to obtain the area under the Chi-square probability density function */
P_value = 1 - probchi(diff, df); 
run;

proc print data=test;
title 'The Likelihood Ratio Test (LRT) for both product terms in the model';
run;
title;

/* Notice the p-value is similar to the result obtained by the generalized wald test */

ods pdf close;




