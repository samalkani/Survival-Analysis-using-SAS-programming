%let path=/home/ajay_malkani0/Survival Analysis data sets; 
libname Surv_Ana "&path";

ods pdf file="&path/6. Assessing_the_PH_ assumption_with_a_statistical_test.pdf" style=SasWeb;

/* Generating Schoenfeld Residuals in preparation for statistical test of PH assumption */

proc phreg data=surv_ana.addicts;
model survt*status(0)=Clinic Prison Dose;
output out = Surv_Ana.Residuals ressch=Rclinic Rprison Rdose;
run;

/* Printing Schoenfeld Residuals */

proc print data= Surv_Ana.Residuals;
title 'Schoenfeld Residuals';
run;
title;

/* Create sas dataset that deletes censored observations, i.e. only contains
 addicts that have relapsed therapy. */

data Surv_Ana.events;
set Surv_Ana.residuals;
if status=1;
run;

proc print data=surv_ana.events;
title 'Schoenfeld residuals for addicts that have relapsed on therapy';
run;
title;

/* Ranking the order of failure times */

proc rank data=surv_ana.events out=surv_ana.ranked ties=mean;
  var survt;
  ranks timerank;
run;

proc print data=surv_ana.ranked;
title'Schoenfeld residuals for addicts that have relapsed on therapy (time ranked)';
run;
title;

/* Correlations between the ranked failure time variable timerank and 
the variables containing the Schoenfeld residuals */

proc corr data=surv_ana.ranked nosimple;
	var rclinic rprison rdose;
	with timerank;
	title'Schoenfeld residuals for predictors in the model vs ranked relapse time';
run;
title;

/*Alternatively p-values can be obtained by running Proc reg for each variable, one at a time */

ods select ParameterEstimates;
proc reg data=surv_ana.ranked;
model timerank=Rclinic;
title'Schoenfeld residual Rclinic significance test';
run;


proc reg data=surv_ana.ranked;
model timerank=Rprison;
title'Schoenfeld residual Rprison significance test';
run;


proc reg data=surv_ana.ranked;
model timerank=Rdose;
title'Schoenfeld residual Rdose significance test';
run;


ods pdf close;







