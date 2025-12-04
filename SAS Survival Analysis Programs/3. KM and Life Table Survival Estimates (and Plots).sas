%let path=/home/ajay_malkani0/Survival Analysis data sets; 
libname Surv_Ana "&path";

ods pdf file="&path/3. KM_and_Life_Table_Survival_Estimates_(and_Plots).pdf" style=SasWeb;

/*Demonstrating proc lifetest to obtain KM and life table survival estimates (and plots)*/

proc lifetest data=Surv_ana.addicts method=km plots=survival;
time survt*status(0);
run;


/*producing log-log survival curves for the clinic variable*/

proc lifetest data=Surv_ana.addicts method=km plots=(s, lls);
time survt*status(0);
strata clinic;
run;

/*producing log-log survival curves for the prison variable*/

proc lifetest data=Surv_ana.addicts method=km plots=(s, lls);
time survt*status(0);
strata prison;
run;

/* Storing KM survival estimates in a SAS dataset, to gain more control on how variables are plotted*/
/* The KM survival estimates are stored in the SAS dataset called surv_ana.km_est under a variable */
/* called SURVIVAL*/

proc lifetest data=Surv_ana.addicts method=km outsurv=surv_ana.km_est;
time survt*status(0);
strata clinic;
run;


/* The log(-(log)) of the survival estimates is obtained using the following data step */

data surv_ana.km_log;
	set surv_ana.km_est;
	LLS=log(-log(survival));
run;

/* Printing KM and log(-log KM Survival) estimates*/

proc print data=surv_ana.km_log;
title 'KM Survival estimates & log(-log KM Survival) estimates';
run;
title;

/* More 'tailor made' graphical plot of KM and log(-log) KM estimates*/

proc gplot data=surv_ana.km_log;
plot LLS*Survt=Clinic;
symbol color=Blue;
symbol2 color=Red;
run;

   /* gplot not found in this SAS version */

		  
proc sgscatter data=surv_ana.km_log;
		compare y=LLS x=Survt /  group=clinic ;	
		title 'Plot of log(-log) KM estimates against time for the clinic variable';
		label LLS='log(-log) KM estimates';
		label Survt='Survival time';
run;
title;

/* Obtain survival estimates using life tables. This method is useful if you do not have */
/* individual level survival information but rather  have group survival information for */
/* specified time intervals */

proc lifetest data=surv_ana.addicts method=lt intervals= 50 100 150 200 to 1000 by 100 plots=(s);
time survt*status(0);
run;

ods pdf close;


