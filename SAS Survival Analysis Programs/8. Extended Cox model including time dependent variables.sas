%let path=/home/ajay_malkani0/Survival Analysis data sets; 
libname Surv_Ana "&path";

ods pdf file="&path/8. Extended_Cox_Model_Including_Time_Dependent_Variables.pdf" style=SasWeb;

/* Extended Cox model including time dependent variables */

/* Essentially the Cox PH assumption is that the hazard ratios are constant over time, and the variables 
contained in the model are independent over time. However if one or more variables in the model have hazard 
ratios that vary over time and hence the variables are time dependent. The extended Cox model is a way
of including time dependent variables in a Cox PH model. 

Cox (PH) model

h(t,X(t))      =  h_0(t)      exp[Beta_1 (prison) + Beta_2 (dose) +  Beta_3 (Clinic)] 
Dependent      =  Baseline           Time independent predictor variables
Variable          Hazard
Time              Time
dependent         dependent

Extended Cox Model (with a time dependent variable)

h(t,X(t))      =  h_0(t)      exp[Beta_1 (prison) + beta_2 (dose) +  Beta_3 (Clinic) + delta(logt * dose)] 
Dependent      =  Baseline            Time independent predictor variables             Time dependent
Variable          Hazard
Time              Time
dependent         dependent
*/

/* 1. Time dependent continuous variable (predictor).
 * 
 * If it is expected that the hazard ratio for the effect of DOSE increases or decreases (monotonically
- in one direction) with time we could add a continuous time-varying product term with dose and some function
of time. For example LOG of SURVIVAL TIME * DOSE (LOGTDOSE).*/


proc phreg data=surv_ana.addicts;
	model survt*status(0)= Prison Dose Clinic Logtdose;
	Logtdose=Dose*Log(survt);
run;

/* 2. Time dependent categorical (classification / grouping) variable (predictor).

The categorical variable Clinic is presumed to have different hazard ratios either side of 365 days survival 
time. The survival time is split into two so called heaviside functions (hv) either side of 365 days survival 
time. the heaviside functions are substituted in for the variable clinic in the model.*/

proc phreg data=surv_ana.addicts;
	model survt*status(0)= Prison Dose HV1 HV2;
	if survt < 365 then HV1 = Clinic;
	else HV1 = 0;
	if survt >=365 then HV2 = Clinic;
	else HV2 = 0;
	contrast 'Test for equality of heavisides Null=PH assumption met' HV1 1 HV2 -1;
run;

/* Model with clinic variable included and one heaviside function */

proc phreg data=surv_ana.addicts;
model survt*status(0)=Clinic prison dose HV;
if survt >= 365 then HV = Clinic;
else HV = 0;
Contrast 'HR for clinic <365 days' Clinic 1/estimate=exp;
/* hazard ratio at 100 days = exp(-0.45956) = 0.6316 */
Contrast 'HR for clinic >=365 days' Clinic 1 HV 1/estimate=exp;
/* hazard ratio at 400 days = exp((-0.45956) +(-1.36866)) = 0.1607 */
run;

/* both the above procedures yield the same results HV p-value = 0.003 significant indicating
Hazards ratio for clinic variable is not constant over time and hence the PH assumption has
not been met. The HV p-value would have to be non-significant to meet the PH assumption.*/

/* An Extended Cox model in which the hazard ratio is first constant over time and then increases 
 or decreases monotonically over time */

proc phreg data=surv_ana.addicts;
	model survt*status(0)=Clinic Prison Dose Clintime;
	if survt < 365 then clintime=0;
	else if survt >= 365 then clintime = Clinic*(survt-365);
run;

ods pdf close;




