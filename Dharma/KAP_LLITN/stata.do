/*SAS Code for LLITN KAP*/
/*Derek Johnson*/

/*Importing excel data*/
/*Replace “…” with name of excel sheet!*/
PROC IMPORT OUT= KAP. 
            DATAFILE= "C:\Users\tearsofacid\Desktop\KAP data\....xls" 
            DBMS=EXCEL REPLACE;
     RANGE="'CSV KAP Derek$'"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;

/*Creating data set for just household respondent*/
/*Sorting by IDs*/
proc sort data=…;
by fact_0_id fact_1_id; run;
/*Setting just a household set*/
data …;
set …;
where fact_0_id>1 and fact_1_id =.;
run;

/*Cleaning vars*/
/*Re-Categorizing vars*/
data …;
set …;
wherenet2=L0_q54_where_is_the_first_bed_ne;
nethole2 = L0_q58_does_the_bed_net_has_hole;
secondnet2 = L0_q61_do_you_have_a_second_bed_;

if L0_q13_malaria_is_characterised_ = "No" then malaria =1;
if L0_q13_malaria_is_characterised_ = "Uns" then malaria =1;
if L0_q13_malaria_is_characterised_ = "Yes" then malaria =2;

if L0_q90_how_long_do_you_wait_befo = "I go the same day" then clinicwait=1;
if L0_q90_how_long_do_you_wait_befo = "1-2 days" then clinicwait=2;
if L0_q90_how_long_do_you_wait_befo = "2-3 days" then clinicwait=3;
if L0_q90_how_long_do_you_wait_befo = ">3 days" then clinicwait=3;
if L0_q90_how_long_do_you_wait_befo = "I don't seek help" then clinicwait=4;

if L0_q29_how_far_is_your_nearest_h = "Less that a 30 mi" then walk = 1;
if L0_q29_how_far_is_your_nearest_h = "30 minutes to 1 h" then walk = 2;
if L0_q29_how_far_is_your_nearest_h = "1 to 2 hours walk" then walk = 3;
if L0_q29_how_far_is_your_nearest_h = "More than a 2 hou" then walk = 4;
if L0_q29_how_far_is_your_nearest_h = "Too far to walk" then walk = 4;

if L0_q44_if_you_had_no_bed_net_and = "Children under 5 years old" then onenet =1;
if L0_q44_if_you_had_no_bed_net_and = "Female member of the house" then onenet =2;
if L0_q44_if_you_had_no_bed_net_and = "Pregnant women" then onenet =3;
if L0_q44_if_you_had_no_bed_net_and = "Male member of the househo" then onenet =4;
if L0_q44_if_you_had_no_bed_net_and = "Older / Elderly members" then onenet =4;
if L0_q44_if_you_had_no_bed_net_and = "Other" then onenet =4;
if L0_q44_if_you_had_no_bed_net_and = "The whole family" then onenet =4;
if L0_q44_if_you_had_no_bed_net_and = "I would sell it" then onenet =5;

if wherenet2="." then wherenet=. ;
if wherenet2="Bought" then wherenet =1;
if wherenet2="General Distribution" then wherenet =2;
if wherenet2="MSF clnic (ANC)" then wherenet =3;
if wherenet2="Other" then wherenet =3;
if wherenet2="Other health center" then wherenet =3;

if nethole2="." then nethole=. ;
if nethole2="No" then nethole =1;
if nethole2="Yes" then nethole =2;

if secondnet2="." then secondnet=. ;
if secondnet2="No" then secondnet =1;
if secondnet2="Yes" then secondnet =2;

if L0_q31_do_you_have_a_bed_net_in_ = "No" then bednet = 1;
if L0_q31_do_you_have_a_bed_net_in_ = "Ye" then bednet = 2;

if L1_q2_what_is_his_her_age_in_yea >=0 and L1_q2_what_is_his_her_age_in_yea<11 then age=1;
if L1_q2_what_is_his_her_age_in_yea >=11 and L1_q2_what_is_his_her_age_in_yea<21 then age=2;
if L1_q2_what_is_his_her_age_in_yea >=21 and L1_q2_what_is_his_her_age_in_yea<31 then age=3;
if L1_q2_what_is_his_her_age_in_yea >=31 and L1_q2_what_is_his_her_age_in_yea<41 then age=4;
if L1_q2_what_is_his_her_age_in_yea >=41 and L1_q2_what_is_his_her_age_in_yea<51 then age=5;
if L1_q2_what_is_his_her_age_in_yea >=51 and L1_q2_what_is_his_her_age_in_yea<60 then age=6;
if L1_q2_what_is_his_her_age_in_yea >=60 then age=7;

if L1_q2_what_is_his_her_age_in_yea >=0 and L1_q2_what_is_his_her_age_in_yea<5 then Under5=1;
if L1_q2_what_is_his_her_age_in_yea >5 then Under5=2;

unicover=0;

if L0_q18_what_do_you_do_when_you_o="I go to the MSF clinic" then wherego=1;
if L0_q18_what_do_you_do_when_you_o="I go to the health pos" then wherego=2;
if L0_q18_what_do_you_do_when_you_o="I go to a traditional" then wherego=3;
if L0_q18_what_do_you_do_when_you_o="I go to the church" then wherego=3;
if L0_q18_what_do_you_do_when_you_o="I wait until the fever" then wherego=3;

if L0_q31_do_you_have_a_bed_net_in_ ="Ye" and famsize=1 then unicover=1;
if L0_q31_do_you_have_a_bed_net_in_ ="Ye" and famsize=2 then unicover=1;
if L0_q61_do_you_have_a_second_bed_ ="Yes" and famsize=2 then unicover=1;
if L0_q61_do_you_have_a_second_bed_ ="Yes" and famsize=3 then unicover=1;
if L0_q61_do_you_have_a_second_bed_ ="Yes" and famsize=4 then unicover=1;

run;

/*Family Size*/
data …;
set …;
count + 1;
by fact_0_id;
if first.fact_0_id then count = 1;
if last.fact_0_id then famsize = count;
run;

/*Statistics and Frequencies*/
/*Investigating vars where response for owning a LLITN is not missing*/

Proc freq data=…;
where bednet>.;
table malaria L0_q14_how_do_you_think_you_beco L0_q18_what_do_you_do_when_you_o
clinicwait walk L0_q31_do_you_have_a_bed_net_in_ onenet L0_q50_do_you_get_bitten_by_mosq 
wherenet nethole secondnet L0_q10_what_is_the_respondent_se L0_q31_do_you_have_a_bed_net_in_ bednet; run;

/*Individual stats!*/
/*Pregnancy, older than 12!*/
proc freq data=…;
where L1_q2_what_is_his_her_age_in_yea >12;
table L1_q12_is_she_pregnant; run;

/*Age by gender*/
Proc freq data=…;
table  L1_q1_what_is_that_person_sex*age; run;

/*Freqencies by Ofua Zone*/
Proc freq data=…;
table (malaria L0_q14_how_do_you_think_you_beco L0_q18_what_do_you_do_when_you_o
clinicwait walk L0_q31_do_you_have_a_bed_net_in_ onenet L0_q50_do_you_get_bitten_by_mosq 
wherenet nethole secondnet )*L0_q4_what_ofua_zone_are_you_in/chisq; run;

proc means data=… N mean std median p25 p75 min max;
by L0_q4_what_ofua_zone_are_you_in;
var famsize L1_q2_what_is_his_her_age_in_yea; run;
proc means data=derek.kap2a N mean std median p25 p75 min max;
var famsize L1_q2_what_is_his_her_age_in_yea; run;

Proc freq data=…;
table (Under5 L1_q12_is_she_pregnant L1_q4_what_is_his_her_highest_le age
 L1_q1_what_is_that_person_sex L0_q10_what_is_the_respondent_se)*L0_q4_what_ofua_zone_are_you_in/chisq; run;


