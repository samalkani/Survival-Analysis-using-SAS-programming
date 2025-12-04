%let path=/home/ajay_malkani0/Survival Analysis data sets; 
libname Surv_Ana "&path";

ods pdf file="&path/2. Summary_Statistics_for_Addicts_data.pdf" style=SasWeb;

proc contents data=surv_ana.addicts varnum;
title'Addicts dataset contents';
run;
title;

proc print data=Surv_ana.addicts;
title 'Addicts dataset';
run;
title;

proc univariate data=Surv_ana.addicts;
		var survt;
		histogram survt / normal kernel;
		inset n mean median mode / position=ne;
		title 'Survival time for addicts dataset';
run;
title;

proc freq data=Surv_ana.addicts;
	tables clinic prison;
	title'Frequency tables for clinic and prison variables';
run;
title;

proc means data=surv_ana.addicts;
		class clinic;
		var survt;
		title'Survival time grouped means for clinics 1 and 2';
run;
title;

ods pdf close;




