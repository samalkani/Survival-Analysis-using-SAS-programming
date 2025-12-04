%let path=/home/ajay_malkani0/Survival Analysis data sets; 
libname Surv_Ana "&path";

ods pdf file="&path/10. Modelling_Recurrent_events.pdf" style=SasWeb;

/* Modelling recurrent events */

/* Printing observations 12 to 20 of the bladder cancer dataset */

proc print data=surv_ana.Bladder2 (firstobs=12 obs=20) split='*';
var id Recurrence Time_interval Start Stop Treatment Tumour_number Tumour_size;
		label Time_interval='Time*Interval'
			  Tumour_number='Tumour*Number'
			  Tumour_size='Tumour*Size'
			  Start='Start*(Day)'
			  Stop='Stop*(Day)'
			  Recurrence='Tumour*Recurrence';
title 'Observations 12 to 20 of the bladder cancer dataset';
run;
title;

/* PHREG statement is used for data in the counting process format to construct Cox PH model*/

proc phreg data=surv_ana.Bladder2 covs(aggregate);
	model (start, stop)*Recurrence(0)= Treatment Tumour_number Tumour_Size;
	id id;
	title 'Cox PH model using data in counting process format';
run;
title;

/* Stratified Cox Model or Stratified (counting process) CP approach model */

/* The time interval variable is stratified to indicate whether the subject was at risk for their
1st, 2nd, 3rd or 4th event. This approach is called the stratified CP approach. It tells the investigator
the order in which recurrent events occur. */

proc phreg data=surv_ana.Bladder2 covs(aggregate);
	model (start, stop)*Recurrence(0)= Treatment Tumour_number Tumour_Size;
	strata Time_interval;
	id id;
	title 'Cox PH model using data in counting process format';
run;
title;

/* Testing for an interation between variables in the model */

/* 1. Define the interactions with a DATA step first then insert the interactions in the model */

data surv_ana.Bladder3;
	set surv_ana.Bladder2;
	Time_Tr=Time_Interval*Treatment;
	Time_Tum_Num=Time_Interval*Tumour_number;
	Time_Tum_Size=Time_Interval*Tumour_Size;
run;

/* 2. Insert interactions defined above into Cox PH model, The contrast statement
 tests the two interactions simultaneously with a generalized Wald test*/

proc phreg data=surv_ana.Bladder3 covs(aggregate);
	model (start, stop)*Recurrence(0)= Treatment Tumour_number Tumour_Size Time_Tr Time_Tum_Num Time_Tum_Size;
	strata Time_interval;
	id id;
	contrast "TEST INTERACTION" Time_Tr 1, Time_Tum_Num 1, Time_Tum_Size 1;
	title1 'Cox PH model using data in counting process format and testing';
	title2 'for interation between time interval and treatment';
run;
title;



/* 3. Likelihood ratio statistic (LRT) to simultaneously test the two product terms in the model
 (Full Model) with the model without the product terms included (Reduced Model) by subtracting the 
 -2log-likelihood terms for both models to obtain p-value from chi-square tests. */

/* Use a DATA step */

data test;
reduced = -639.718;
full = -637.471;
diff = full - reduced;
df = 3;

/* 1 - probchi needs to be written to obtain the area under the Chi-square probability density function */

P_value = 1 - probchi(diff, df); 
run;

proc print data=test;
title 'The Likelihood Ratio Test (LRT) for three product terms in the model';
run;
title;

/* Cox PH model with Gap time Approach */

/* There is no difference in the time intervals when the subjectz are at risk for their first event.
The starting time at risk gets reset to zero for each subsequent event */

/* Data step resets the starting time, hence 'sets up' the Gap time approach model */

data surv_ana.Bladder4;
	set surv_ana.BLADDER2;
	start2=0;
	stop2=stop-start;
run;

/* Gap time approach Cox PH Model */

proc phreg data=surv_ana.Bladder4 covs(aggregate);
	model (start2, stop2)*Recurrence(0)= Treatment Tumour_number Tumour_Size;
	strata Time_interval;
	id id;
	title 'Cox PH model using data in counting process format';
run;
title;

ods pdf close;






