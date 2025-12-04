%let path=/home/ajay_malkani0/Survival Analysis data sets; 
libname Surv_Ana "&path";

ods pdf file="&path/9. Parametric_Models_with_Proc_LifeReg.pdf" style=SasWeb;

/* Parametric Models with Proc LifeReg */

/* Proc lifetest can be used to plot Kaplan-Meier (KM) log-log curves against log of time. If the curves are
approximately straight lines and parallel then the assumption for the Weibull distribution has been met. If the
KM curves additionally have a slope of 1 (special case of Weibull distribution) the model fits an exponential
distribution. */

ods select SurvivalPlot LogNegLogSurvivalPlot;
proc lifetest data=surv_ana.addicts method=km plots=(LLS);
	time survt*status(0);
	strata clinic prison;
	title1'KM log-log survival curves against log survival time for';
	title2'predictors Clinic and Prison on Drug addict relapse';
	label survt='Survival time in days';
run;
title;

/* The log-log curves do not look straight but lets assume that the Weibull assumption is appropriate. First the 
exponential model will be run where the shape parameter = 1 which forces the hazard to be constant. Then the 
Weibull model will be fitted. */

/* Exponential model */

proc lifereg data=surv_ana.addicts;
	model survt*status(0) = Prison Dose Clinic / dist = exponential;
	title 'Parametric model - Exponential distribution';
run;
title;

/* Weibull model */

proc lifereg data=surv_ana.addicts;
	model survt*status(0) = Prison Dose Clinic / dist = Weibull;
	title 'Parametric model - Weibull distribution';
run;
title;

/* Log-logistic model */

proc lifereg data=surv_ana.addicts;
	model survt*status(0) = Prison Dose Clinic / dist = llogistic;
	title 'Parametric model - Log-Logistic distribution';
run;
title;

/* Testing assumptions with the Log-Logistic model */

/* The Log-Logistic model assumption can be tested by plotting log-suvival or log-failure odds against the log
of time 

Log-Survival odds = In [S(t) / (1-S(t))]

or

Log-Failure odds = In [(1-S(t)) / S(t)]

/* Storing KM survival estimates in a SAS dataset, to gain more control on how variables are plotted*/
/* The KM survival estimates are stored in the SAS dataset called surv_ana.km_est under a variable */
/* called SURVIVAL*/

proc lifetest data=Surv_ana.addicts method=km outsurv=surv_ana.km_est1;
time survt*status(0);
strata clinic;
run;


/* The log odds of the KM survival estimates and Log of time values are obtained
 using the following data step */

data surv_ana.km_logodds;
	set surv_ana.km_est1;
	Logodds=log(survival/(1-survival));
	Logtime=log(survt);
run;

/* Printing KM and log odds KM Survival estimates*/

proc print data=surv_ana.km_logodds;
title 'KM Survival estimates & log odds KM Survival) estimates';
run;
title;

/* Plot of Log-Survival odds against log of time */
		  
proc sgscatter data=surv_ana.km_logodds;
		compare y=Logodds x=Logtime /  group=clinic ;	
		title 'Plot of log odds KM survival estimates against log of time for the clinic variable';
		label Logodds='log odds KM survival estimates';
		label Logtime='Log of Survival time';
run;
title;


/* The log-logistic model contructed above is a multiplicative model with respect to survival time or
equivalently an additive model with respect to the log of time. */

/* An example of an ADDITIVE FAILURE TIME MODEL, is created by suppressing the log-link function,
which means that time rather than log(time), is modelled as a linear function of the regression parameters.*/

proc lifereg data=surv_ana.addicts;
	model survt*status(0) = Prison Dose Clinic / dist=llogistic nolog;
	title 'Additive Failure time Logistic model';
run;

/* The parameter estimate for clinic is 214.2525. The interpretation for this estimate is that the 
MEDIAN SURVIVAL TIME (or time to any fixed value of S(t)) is estimated at 214 days more for clinic=2
compared to clinic=1. In other words, you add 214 days to the estimated MEDIAN SURVIVAL TIME for clinic=1
to get the estimated MEDIAN SURVIVAL TIME for clinic=2. This contrasts from the previous AFT model in which
you multiply estimated MEDIAN SURVIVAL TIME for clinic=2. THE ADDITIVE MODEL CAN BE VIEWED AS A SHIFTING
OF SURVIVAL TIME WHILE THE AFT MODEL CAN BE VIEWED AS A SCALING OF SURVIVAL TIME.

/* Testing assumptions of Additive failure time model */

/* Plot log odds of survival (using KM estimates) against time, rather than against the log of time as 
analogously used for evaluation of the log-logistic assumption. */

proc lifetest data=Surv_ana.addicts method=km outsurv=surv_ana.km_est2;
time survt*status(0);
strata clinic;
run;


/* The log odds of the KM survival estimates are obtained
 using the following data step */

data surv_ana.km_logodds1;
	set surv_ana.km_est2;
	Logodds=log(survival/(1-survival));
run;

/* Printing KM and log odds KM Survival estimates*/

proc print data=surv_ana.km_logodds;
title 'KM Survival estimates & log odds KM Survival) estimates';
run;
title;

/* Plot of Log-Survival odds against log of time */
		  
proc sgscatter data=surv_ana.km_logodds;
		compare y=Logodds x=survt /  group=clinic ;	
		title 'Plot of log odds KM survival estimates against time for the clinic variable';
		label Logodds='log odds KM survival estimates';
		label survt='Log of Survival time';
run;
title;

ods pdf close;





