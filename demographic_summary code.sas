PROC IMPORT DATAFILE="C:\Users\Aishwarya\Desktop\project+notes\SAS Project Table-DM Raw data.xlsx"
OUT= DM
DBMS= XLSX REPLACE;
RUN;

DATA DM1;
SET DM;
RUN;

PROC SORT DATA= DM;
BY TRT;
RUN;

DATA DM1;
SET DM; OUTPUT;
TRT=2; OUTPUT;
RUN;
PROC SORT DATA= DM1;
BY TRT;
RUN;

PROC SUMMARY DATA=DM1;
BY TRT;
VAR AGE;
OUTPUT OUT= AGE_1
            N=_n
			Mean=_mean
			std=_std
			Median=_mdn
			Min=_min
			Max=_max;
Run;

DATA AGE_2;
SET AGE_1;
MeanSD= PUT(_mean,5.1) ||'('||PUT(_std,6.2)||')';
Median= PUT(_mdn,5.1);
MinMax= PUT(_min,4.0)||'('||PUT(_max,4.0)||')';
N= PUT(_n,4.0);
DROP _:;
RUN;

PROC TRANSPOSE DATA=AGE_2 OUT= AGE_3 PREFIX= TRT_;
ID TRT;
VAR N MeanSD Median MinMax;
RUN;

DATA AGE_4;
Length Desc $60.;
SET AGE_3;
IF _Name_ = 'N' then Desc= '   N';
ELSE IF _Name_ = 'MeanSD' Then Desc= '   Mean(SD)';
ELSE IF _Name_ ='Median' then Desc = '   Median';
ELSE IF _Name_ ='MinMax' then Desc ='   Min,Max';
Drop _Name_;
run;

DATA MOCKDATA;
Length Desc $60.;
Desc='Age(Years)';
RUN;

DATA AGE;
SET MOCKDATA AGE_4;
ORDER=1;
RUN;

PROC SORT DATA=DM1;
BY TRT;
RUN;

PROC FREQ DATA=DM1;
BY TRT;
TABLE GENDER/OUT=GEN_1;
WHERE GENDER NE .;
RUN;

DATA GEN_2;
SET GEN_1;
NP=PUT(COUNT,4.0)||'('||PUT(PERCENT,4.1)||')';
RUN;

PROC SORT DATA=GEN_2;
BY GENDER;
RUN;

PROC TRANSPOSE DATA=GEN_2 OUT=GEN_3 (DROP = _NAME_) PREFIX=TRT_;
ID TRT;
VAR NP;
BY GENDER;
RUN;

DATA GEN_4;
LENGTH Desc $60.;
SET GEN_3;
IF GENDER= 1 THEN Desc=' Male';
ELSE IF GENDER= 2 THEN Desc=' Female';
DROP GENDER;
RUN;

DATA DUMMY1;
DESC='Gender[n(%)]^a';
run;

DATA GENDER;
LENGTH Desc $40.;
SET DUMMY1 GEN_4;
ORDER=2;
RUN;

PROC SORT DATA=DM1;
BY TRT;
RUN;

PROC FREQ DATA=DM1;
BY TRT;
TABLE ETHNIC/OUT=ETH_1;
WHERE ETHNIC NE .;
RUN;

DATA ETH_2;
SET ETH_1;
NP=PUT(COUNT,4.0)||'('||PUT(PERCENT,5.1)||')';
RUN;

PROC SORT DATA=ETH_2; BY ETHNIC; RUN;

PROC TRANSPOSE DATA=ETH_2 OUT=ETH_3 (DROP=_Name_) PREFIX=TRT_;
ID TRT;
VAR NP;
BY ETHNIC;
RUN;

DATA ETH_4;
LENGTH Desc $50.;
SET ETH_3;
IF ETHNIC=1 THEN Desc='  Hispanic';
ELSE IF ETHNIC=2 THEN Desc ='  Not Hispanic or Latino';
DROP ETHNIC;
RUN;

DATA DUMMY;
LENGTH Desc $50.;
DESC='Ethinicity[n(%)]^a';
Run;

DATA ETHNIC;
SET DUMMY ETH_4;
ORDER=3;
RUN;

PROC SORT DATA=DM1; 
BY TRT; 
RUN;

PROC FREQ DATA=DM1;
BY TRT;
TABLE RACE/OUT=RACE_1;
WHERE RACE NE .;
RUN;

DATA RACE_2;
SET RACE_1;
NP=PUT(COUNT,4.0)||'('||PUT(PERCENT,5.1)||')';
RUN;

PROC SORT DATA=RACE_2;
BY RACE;
RUN;

PROC TRANSPOSE DATA= RACE_2 OUT=RACE_3 (DROP=_Name_) PREFIX=TRT_;
ID TRT;
VAR NP;
BY RACE;
RUN;

DATA RACE_4;
LENGTH Desc $50.;
SET RACE_3;
IF RACE=1 THEN Desc='  White';
ELSE IF RACE=2 THEN Desc='  Black';
ELSE IF RACE=3 THEN Desc='  Asian';
DROP Race;
run;

DATA DUMMY2;
LENGTH Desc $50.;
Desc='Race[n(%)]^a';
RUN;

DATA RACE;
SET DUMMY2 RACE_4;
ORDER=4;
RUN;

DATA FINAL;
LENGTH Desc $60.;
SET AGE GENDER ETHNIC RACE;
RUN;

PROC REPORT DATA=FINAL SPLIT=',';
COLUMN (ORDER Desc TRT_1 TRT_0 TRT_2);
DEFINE ORDER/GROUP NOPRINT;
DEFINE Desc/'' WIDTH=40;
DEFINE TRT_1/'BP3301,(N=31)';
DEFINE TRT_0/'Placebo,(N=29)';
DEFINE TRT_2/'Overall,(N=60)';

BREAK AFTER ORDER/SKIP;
COMPUTE BEFORE _PAGE_;
LINE ' ';
LINE @2 ' 14.1.2.1 Demographic and baseline characteristic';
LINE @5 'Safety Population';
ENDCOMP;

COMPUTE AFTER;
LINE @4 'Reference:Listing 16.2.4.1';
LINE @4 'Summary Table';
ENDCOMP;
RUN;



