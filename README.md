# Survival-Analysis-using-SAS-programming

A collection of SAS programs used to conduct survival analysis on addicts and bladder cancer data sets. These analyses are the same analyses done in R programming, see survival analysis R programming repository (https://github.com/samalkani/Linear-Logistic-Regression-and-Survival-Analysis). This repository has three folders as follows;

1. __SAS Survival Analysis Programs__ (https://github.com/samalkani/Survival-Analysis-using-SAS-programming/tree/main/SAS%20Survival%20Analysis%20Programs)
2. __Survival Analysis PDF output__ (https://github.com/samalkani/Survival-Analysis-using-SAS-programming/tree/main/Survival%20Analysis%20PDF%20Output)
3. __CSV and SAS Survival Analysis data sets__ (https://github.com/samalkani/Survival-Analysis-using-SAS-programming/tree/main/CSV%20%26%20SAS%20Survival%20Analysis%20Data%20Sets)

## Description of the data sets

### Addicts Data Set

A data.frame with 238 rows and the following variables:

* id - ID of subject
* clinic - Clinic (1 or 2)
* status - status (0=censored, 1=endpoint)
* survt - survival time (days)
* prison - prison record?
* dose - methodone dose (mg/day)

### Baldder Cancer Data set

A data.frame with 191 rows and the following variables:

* id
* event
* interval
* inttime
* start
* stop
* tx
* num
* size

## Analysis Performed

1. Survival Analysis loading data sets
2. Summary Statistics for Addicts data
3. KM and Life Table Survival Estimates (and Plots)
4. Cox Proportional Hazards (PH) Model
5. Stratified Cox PH Model
6. Assessing the PH assumption with a statistical test
7. Obtaining Cox adjusted Survival Curves
8. Extended Cox model including time dependent variables
9. Parametric Models with Proc LifeReg
10. Modelling recurrent events
