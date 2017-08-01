* Baseline health / mortality survey template analysis code
* Version 1.0
* John Guzek

* Housekeeping - alter the first line to the correct filepath for the dataset
cd "D:\Users\USERNAME\Desktop\Uganda\Baseline health survey\Datasets\Stata"
clear all
capture log close
set more off
log using bhs1, append

use FINAL_DATESET_YES.dta

* Data preparation - renames variables from Dharma to correct var name
* May need amendment if questions are added / removed
rename L0_q24_iq2 zone
rename L0_q56_iq2a zone_oth
rename L0_q27_iq4 hhid
rename L0_q28_cq1 pson_home
rename L0_q45_cq2 over_18
rename L0_q49_cq3 consent
rename L0_q53_cq4a no_cons_odd
rename L0_q53_cq4a000 no_cons_why
rename L0_q61_cq4b no_cons_why_oth
rename L1_q4_oqq1 sex
rename L1_q5_oqq1a pregnant
rename L1_q6_oqq2 age_yr
rename L1_q32_oqq2a age_mth
rename L1_q14_oqq2c vac_card
rename L1_q15_oqq2d oedema
rename L1_q98_oqq2e2 muac1
rename L1_q33_oqq2e muac2
rename L1_q39_oqq3 bednet
rename L1_q18_oqq4 ill_2wk
rename L1_q24_oqq4f clinic_typ
rename L1_q107_please_specify_which_cli clinic_oth
rename L1_q25_oqq4g other_care
rename L1_q26_oqq5 violence
rename L1_q27_oqq5a violence_num
rename L1_q40_oqq6 joined_hh
rename L1_q41_oqq6a joined_hh_date
rename L1_q42_oqq6b joined_why
rename L1_q43_oqq6c joined_oth
rename L1_q44_oqq7 left_hh
rename L1_q45_oqq7a left_hh_date
rename L1_q46_oqq7b left_why
rename L1_q47_oqq7c left_oth
rename L1_q48_oqq8 born_recall
rename L1_q49_oqq8a born_date
rename L1_q87_oqq9 died_recall
rename L1_q88_oqq9a died_date
rename L1_q89_oqq9b died_cod
rename L1_q91_oqq9c died_viol_typ
rename L1_q92_oqq9d died_viol_typ_oth
rename L1_q90_oqq9e died_cod_oth
rename L1_q93_oqq9f died_where
rename L1_q94_oqq9g died_where_oth
rename L1_q95_does_the_occupant_has_a_c comments
rename L1_q62_oqq10 add_comments

* The following will need to be checked / amended depending on the responses given
* There are other response options in the questionnaire which may or may not be reflected in the responses
rename L1_q8_oqq2b000 vaac0
rename L1_q8_oqq2b001 vaac1
rename L1_q8_oqq2b002 vaac2
rename L1_q8_oqq2b003 vaac3
rename L1_q8_oqq2b004 vaac4
rename L1_q8_oqq2b005 vaac5

rename L1_q19_oqq4a000 ill_type1
rename L1_q19_oqq4a001 ill_type2
rename L1_q19_oqq4a002 ill_type3
rename L1_q19_oqq4a003 ill_type4
rename L1_q20_oqq4b ill_type_oth

rename L1_q21_oqq4c000 seek_care1
rename L1_q21_oqq4c001 seek_care2
rename L1_q21_oqq4c002 seek_care3
rename L1_q21_oqq4c003 seek_care4
rename L1_q21_oqq4c004 seek_care5

rename L1_q22_oqq4d000 seek_care_no1
rename L1_q22_oqq4d001 seek_care_no2
rename L1_q22_oqq4d002 seek_care_no3
rename L1_q23_oqq4e seek_care_no_oth

rename L1_q28_oqq5b000 violence_typ1
rename L1_q28_oqq5b001 violence_typ2
rename L1_q28_oqq5b002 violence_typ3
rename L1_q28_oqq5b003 violence_typ4
rename L1_q37_oqq5c violence_typ_oth
rename L1_q35_oqq5d violence_date

rename L1_q36_oqq5e000 violence_loc1
rename L1_q36_oqq5e001 violence_loc2
rename L1_q38_oqq5f violence_loc_oth

* Dharma codes yes as 0 and no as 1 - the following code changes this
* Variable names may need to be changed depending on the dataset

foreach x of varlist consent pregnant pson_home over_18 vac_card oedema bednet ill_2wk violence joined_hh left_hh born_recall died_recall comments {
recode `x' (1=0) (0=1)
}

* Multiple responses are arranged sequentially by var in Dharma, rather than having specific categories.
* The following can be used as a template for creating separate vars for each response option.
* Vaccines
gen vac_measle=.
recode vac_measle .=1 if (vaac0==0|vaac1==0|vaac2==0|vaac3==0|vaac4==0|vaac5==0)
gen vac_polio=.
recode vac_polio .=1 if (vaac0==1|vaac1==1|vaac2==1|vaac3==1|vaac4==1|vaac5==1)
gen vac_men=.
recode vac_men .=1 if (vaac0==2|vaac1==2|vaac2==2|vaac3==2|vaac4==2|vaac5==2)
gen vac_penta=.
recode vac_penta .=1 if (vaac0==3|vaac1==3|vaac2==3|vaac3==3|vaac4==3|vaac5==3)
gen vac_pcv=.
recode vac_pcv .=1 if (vaac0==4|vaac1==4|vaac2==4|vaac3==4|vaac4==4|vaac5==4)
gen vac_no=.
recode vac_no .=1 if (vaac0==5|vaac1==5|vaac2==5|vaac3==5|vaac4==5|vaac5==5)
gen vac_dk=.
recode vac_dk .=1 if (vaac0==6|vaac1==6|vaac2==6|vaac3==6|vaac4==6|vaac5==6)

* Recode missing to 0 if possible that person could have received the vaccine
foreach x of varlist vac_measle vac_polio vac_men vac_penta vac_pcv {
recode `x' (.=0) if vac_no==1 & age_yr<5
}

foreach x of varlist vac_measle vac_polio vac_men vac_penta vac_pcv {
recode `x' (.=0) if `x'==. & age_yr<5
}

* As above - recoding multiple response options to unique vars. May need to be updated depending on responses.
gen ill_diarrhoea=.
recode ill_diarrhoea .=1 if (ill_type1==0|ill_type2==0|ill_type3==0|ill_type4==0)
gen ill_resp=.
recode ill_resp .=1 if (ill_type1==1|ill_type2==1|ill_type3==1|ill_type4==1)
gen ill_malnut=.
recode ill_malnut .=1 if (ill_type1==2|ill_type2==2|ill_type3==2|ill_type4==2)
gen ill_preg=.
recode ill_preg .=1 if (ill_type1==3|ill_type2==3|ill_type3==3|ill_type4==3)
gen ill_malar=.
recode ill_malar .=1 if (ill_type1==4|ill_type2==4|ill_type3==4|ill_type4==4)
gen ill_acc=.
recode ill_acc .=1 if (ill_type1==5|ill_type2==5|ill_type3==5|ill_type4==5)
gen ill_violence=.
recode ill_violence .=1 if (ill_type1==6|ill_type2==6|ill_type3==6|ill_type4==6)
gen ill_unknown=.
recode ill_unknown .=1 if (ill_type1==7|ill_type2==7|ill_type3==7|ill_type4==7)
gen ill_other=.
recode ill_other .=1 if (ill_type1==8|ill_type2==8|ill_type3==8|ill_type4==8)

foreach x of varlist ill_diarrhoea ill_resp ill_malnut ill_preg ill_malar ill_acc ill_violence ill_unknown ill_other {
recode `x' (.=0) if `x'==. 
}

* Care seeking - recoding as above
gen seek_no=.
recode seek_no .=1 if (seek_care1==0|seek_care2==0|seek_care3==0|seek_care4==0|seek_care5==0)
gen seek_self=.
recode seek_self .=1 if (seek_care1==1|seek_care2==1|seek_care3==1|seek_care4==1|seek_care5==1)
gen seek_clinic=.
recode seek_clinic .=1 if (seek_care1==2|seek_care2==2|seek_care3==2|seek_care4==2|seek_care5==2)
gen seek_trad=.
recode seek_trad .=1 if (seek_care1==3|seek_care2==3|seek_care3==3|seek_care4==3|seek_care5==3)
gen seek_oth=.
recode seek_oth .=1 if (seek_care1==4|seek_care2==4|seek_care3==4|seek_care4==4|seek_care5==4)

foreach x of varlist seek_no seek_self seek_clinic seek_trad seek_oth {
recode `x' (.=0) if `x'==. & ill_2wk==1
}

* Reason not to seek care - as above may need amendment
gen reas_nocash=.
recode reas_nocash .=1 if (seek_care_no1==0|seek_care_no2==0|seek_care_no3==0)
gen reas_toosick=.
recode reas_toosick .=1 if (seek_care_no1==1|seek_care_no2==1|seek_care_no3==1)
gen reas_notsickeno=.
recode reas_notsickeno .=1 if (seek_care_no1==2|seek_care_no2==2|seek_care_no3==2)
gen reas_toofar=.
recode reas_toofar .=1 if (seek_care_no1==3|seek_care_no2==3|seek_care_no3==3)
gen reas_notime=.
recode reas_notime .=1 if (seek_care_no1==4|seek_care_no2==4|seek_care_no3==4)
gen reas_notrust=.
recode reas_notrust .=1 if (seek_care_no1==5|seek_care_no2==5|seek_care_no3==5)
gen reas_security=.
recode reas_security .=1 if (seek_care_no1==6|seek_care_no2==6|seek_care_no3==6)
gen reas_refused=.
recode reas_refused .=1 if (seek_care_no1==7|seek_care_no2==7|seek_care_no3==7)
gen reas_oth=.
recode reas_oth .=1 if (seek_care_no1==8|seek_care_no2==8|seek_care_no3==8)

foreach x of varlist reas_nocash reas_toosick reas_notsickeno reas_toofar reas_notime reas_notrust reas_security reas_refused reas_oth{
recode `x' (.=0) if `x'==. & (seek_no==1|seek_self==1|seek_trad==1|seek_oth==1)
}

* Violence type - as above may need amendment
gen viol_beaten=.
recode viol_beaten .=1 if (violence_typ1==0|violence_typ2==0|violence_typ3==0|violence_typ4==0)
gen viol_sexual=.
recode viol_sexual .=1 if (violence_typ1==1|violence_typ2==1|violence_typ3==1|violence_typ4==1)
gen viol_shot=.
recode viol_shot .=1 if (violence_typ1==2|violence_typ2==2|violence_typ3==2|violence_typ4==2)
gen viol_kidnap=.
recode viol_kidnap .=1 if (violence_typ1==3|violence_typ2==3|violence_typ3==3|violence_typ4==3)
gen viol_unk=.
recode viol_unk .=1 if (violence_typ1==4|violence_typ2==4|violence_typ3==4|violence_typ4==4)
gen viol_oth=.
recode viol_oth .=1 if (violence_typ1==5|violence_typ2==5|violence_typ3==5|violence_typ4==5)

foreach x of varlist viol_beaten viol_sexual viol_shot viol_kidnap viol_unk viol_oth{
recode `x' (.=0) if `x'==. & violence==1
}

* Violence where - as above may need amendment
gen viol_loc_home=.
recode viol_loc_home .=1 if (violence_loc1==0|violence_loc2==0)
gen viol_loc_work=.
recode viol_loc_work .=1 if (violence_loc1==1|violence_loc2==1)
gen viol_loc_journey=.
recode viol_loc_journey .=1 if (violence_loc1==2|violence_loc2==2)
gen viol_loc_unk=.
recode viol_loc_unk .=1 if (violence_loc1==3|violence_loc2==3)
gen viol_loc_oth=.
recode viol_loc_oth .=1 if (violence_loc1==4|violence_loc2==4)

foreach x of varlist viol_loc_home viol_loc_work viol_loc_journey viol_loc_unk viol_loc_oth {
recode `x' (.=0) if `x'==. & violence==1
}


* Dharma creates 2 MUAC vars (not sure why) - recode to 1 var
replace muac2=muac1 if muac1!=.
recode muac2 0=.
drop muac1
rename muac2 muac

* Categorise MUAC to healthy, at risk, MAM, SAM. Will need amendment if MUAC band used has even and odd numbers.
gen muac_cat=.
recode muac_cat .=1 if muac>135 & age_yr<5
recode muac_cat .=2 if muac>125 & muac<135 & age_yr<5
recode muac_cat .=3 if muac>115 & muac<125 & age_yr<5
recode muac_cat .=4 if muac<115 & age_yr<5

* Define labels - can be used for each var, this is included below but may need amendment
lab def muac_cat 1"Normal" 2"At risk" 3"MAM" 4"SAM"
lab val muac_cat muac_cat
lab var muac_cat muac_category

* Overall GAM var
gen gam=.
recode gam .=1 if muac_cat==3|muac_cat==4
recode gam .=0 if muac_cat==1|muac_cat==2
lab def gam 0"Healthy" 1"GAM"
lab val gam gam
lab var gam gam

* Create 6 month to 5 years var to ensure malnutrition results are limited to the right age group
gen age_screen=.
replace age_screen=1 if age_yr<5 & age_mth>5

* Variable category labels - will need amendment to specific dataset
lab def zone 10"Z3 East" 11"Z3 West" 6"Z1" 7"Z1 Ext" 9"Z2"
lab val zone zone

lab def sex 0"Male" 1"Female"
lab val sex sex

lab def yesno 0"No" 1"Yes"
foreach x of varlist consent pregnant pson_home over_18 vac_card bednet violence joined_hh left_hh born_recall died_recall comments {
lab val `x' yesno
}

lab def oedema 0"No" 1"Yes" 2"Less than 6 months" 3"Not home or dead"
lab val oedema oedema

lab def ill_2wk 0"No" 1"Yes" 2"Not around or dead"
lab val ill_2wk ill_2wk

lab def clinic_typ 0"MSF" 1"MTI" 2"Other"
lab val clinic_typ clinic_typ

lab def hhchange 0"Displacement" 1"Other"
lab val joined_why hhchange
lab val left_why hhchange

lab def cod 0"Diarrhoea" 1"Respiratory" 2"Malnutrition" 3"Pregnancy-related" 4"Malaria/fever" 5"Trauma/accident" 6"Violence" 7"Unknown" 8"Other"
lab val died_cod cod

lab def codviol 0"Beaten" 1"Sexual" 2"Shot" 3"Detained/kidnapped" 4"Unknown" 5"Other"
lab val died_viol_typ codviol

lab def diedwhere 0"Home" 1"Work" 2"Unknown" 3"Other"
lab val died_where diedwhere

foreach x of varlist vac_measle vac_polio vac_men vac_penta vac_pcv vac_no vac_dk ill_diarrhoea ill_resp ill_malnut ill_preg ill_malar ill_acc ill_violence ill_unknown ill_other seek_no seek_self seek_clinic seek_trad seek_oth reas_nocash reas_toosick reas_notsickeno reas_toofar reas_notime reas_notrust reas_security reas_refused reas_oth viol_beaten viol_sexual viol_shot viol_kidnap viol_unk viol_oth viol_loc_home viol_loc_work viol_loc_journey viol_loc_unk viol_loc_oth {
lab val `x' yesno
}


* Variable labels - will need amendment for specific dataset
lab var zone zone
lab var zone_oth "Other zone"
lab var hhid hhid
lab var pson_home "Person at home"
lab var over_18 "Person over 18"
lab var consent consent
lab var sex sex
lab var pregnant pregnant
lab var age_yr "age in years"
lab var age_mth "age in months"
lab var vac_card "vaccine card"
lab var oedema oedema
lab var muac "muac measure"
lab var bednet bednet
lab var ill_2wk "sick in last 2 weeks"
lab var ill_type_oth "Other sickness"
lab var seek_care_no_oth "Other reason not to seek care"
lab var clinic_typ "type of clinic"
lab var clinic_oth "other type of clinic"
lab var other_care "other type of care"
lab var violence "experienced violence"
lab var violence_num "number of violent experiences"
lab var violence_typ_oth "other type of violence"
lab var violence_date "date of most recent violence"
lab var violence_loc_oth "other location of violence"
lab var joined_hh "joined household in recall period"
lab var joined_hh_date "joined household date"
lab var joined_why "joined household reason"
lab var joined_oth "joined household for another reason"
lab var left_hh "left household in recall period"
lab var left_hh_date "left household date"
lab var left_why "left household reason"
lab var left_oth "left household for another reason"
lab var born_recall "born during recall period"
lab var born_date "born during recall period DOB"
lab var died_recall "died during recall period"
lab var died_date "died on date"
lab var died_cod "cause of death"
lab var died_viol_typ "type of violence for deaths"
lab var died_viol_typ_oth "type of violence for deaths other"
lab var died_cod_oth "other cause of death"
lab var died_where "place of death"
lab var died_where_oth "other place of death"
lab var comments comments
lab var vac_measle "measles vaccine"
lab var vac_polio "polio vaccine"
lab var vac_pcv "pcv vaccine"
lab var vac_men "meningitis vaccine"
lab var vac_penta "penta vaccine"
lab var vac_no "no vaccines"
lab var vac_dk "unsure of vaccines"
lab var ill_diarrhoea "sick with diarrhoea"
lab var ill_resp "sick with respiratory"
lab var ill_malnut "sick with malnutrition"
lab var ill_preg "sick with pregnancy complication"
lab var ill_malar "sick with malaria"
lab var ill_acc "sick due to accident"
lab var ill_violence "sick due to violence"
lab var ill_unknown "sick with unknown complaint"
lab var ill_other "sick with other illness"
lab var seek_no "did not seek care"
lab var seek_self "self medicated"
lab var seek_clinic "sought care from clinic"
lab var seek_trad "traditional medicine"
lab var seek_oth "sought other type of care"
lab var reas_nocash "did not seek care due to no money"
lab var reas_toosick "did not seek care as too sick"
lab var reas_notsickeno "did not seek care as not sick enough"
lab var reas_toofar "did not seek care as clinic too far away"
lab var reas_notime "did not seek care as no time"
lab var reas_notrust "did not seek care due to no trust in clinic"
lab var reas_security "did not seek care due to lack of security"
lab var reas_refused "did not seek care as care refused"
lab var reas_oth "did not seek care for other reason"
lab var viol_beaten "type of violence beaten"
lab var viol_sexual "type of violence sexual"
lab var viol_shot "type of violence shot"
lab var viol_kidnap "type of violence detained / kidnap"
lab var viol_unk "type of violence unknown"
lab var viol_oth "type of violence other"
lab var viol_loc_home "violence occurred at home"
lab var viol_loc_work "violence occurred at work"
lab var viol_loc_journey "violence occurred during journey"
lab var viol_loc_unk "violence occurred at unknown location"
lab var viol_loc_oth "violence occurred at other location"

* Generate 5 year age groups
egen agecat=cut(age_yr), at(0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95) label

* Drop hh identifier as variable - Dharma creates a specific ID for the household ID which is not needed for analysis
* Variable was created in Excel prior to import to Stata, based on the first observation for each household ID
drop if hh_id_drop==1

* ANALYSIS
* Creates dates and days in study based on the recall period
* 42552 is the Excel conversion of date for the start of the recall period
* Excel time starts 01/01/1900, Stata time starts 01/01/1960 so need to subtract 60 years from Excel date.
* This could be done in a better way!

* Start of recall period
gen recallstart=42552-((365.25*60)+1)

* Format all dates appropriately for longitudinal analysis in Stata
format recallstart %td
format born_date %td
format violence_date %td
format joined_hh_date %td
format left_hh_date %td
format died_date %td

* Date num was created in Excel as a numerical version of the date from Dharma which needs to be reformatted
* IDRISS TO UPDATE ON THE CUSTOM FORMATTING NEEDED IN EXCEL
* Date_r corrects this to the correct date in Stata
gen date_r=date_num-((365.24*60)+1)
format date_r %td

* Generates date of entry to study
gen enterdate=recallstart
replace enterdate=born_date if born_r==1
replace enterdate=joined_hh_date if joined_hh==1 
format enterdate %td

* Generates date of exit (died, censored)
gen daternd=date_r
replace daternd=died_date if died1date!=.
replace daternd=left_hh_date if left_hh_date!=. 
replace daternd=date_r if joined_hh_date>left_hh_date & died_recall!=1

format daternd %td

* Generate weights by zone - may not be needed depending on the sampling method, defines zone name
* Weights will need to be generated
lab def zone_f 6"Z1" 7"Z1E" 9"Z2" 10"Z3E" 11"Z3W"
lab val zone_f zone_f

gen weight=.
replace weight=0.197061 if zone_f==6
replace weight=1.205242 if zone_f==7
replace weight=1.288844 if zone_f==9
replace weight=0.898994 if zone_f==10
replace weight=1.588507 if zone_f==11

* Svyset to apply weights - Stata needs to know how to apply the weights
svyset fact_1_id [pweight=weight]
svy: tab died_r sex,row

* Mortality rates
* stset tells Stata about longintudinal data, use help file to understand more if needed
* strate generates the relevant weights
stset daternd [pweight=weight], failure (died_recall=1) origin(time enterdate) exit(time daternd) id(fact_1_id) scale(1)
strate,per(10000)
strate zone_f,per(10000)
strate sex,per(10000)

* Mortality rates by age and sex - generates different age groups for mortality analysis
gen age3=.
replace age3=1 if age_yr<15
replace age3=2 if age_yr>=15 & age_yr<50
replace age3=3 if age_yr>=50
lab def age3 1"<15" 2"15-49" 3"50+"
lab val age3 age3

strate age3,per(10000)
strate age3 sex,per(10000)

gen age6=.
replace age6=1 if age_yr<5
replace age6=2 if age_yr>=5
lab def age6 1"<5" 2"5+"
lab val age6 age6

strate age6,per(10000)

gen age4=.
replace age4=1 if age_yr<15
replace age4=2 if age_yr>=15
lab def age4 1"<15" 2">=15"
lab val age4 age4

strate age4,per(10000)
strate age4 sex,per(10000)

svy: tab sex age3 if died_r==1,row

strate age5,per(10000)
strate age5 sex,per(10000)

* Cause of death
svy: tab died_cod zone_f,col
tab died_cod zone_f

* Mortality rates for different time periods
* This code splits each record by dates of arrival in the camp, for each zone
* This will be specific to context
* stsplit is the command to split records at a certain point in time
gen zonesplit=.
recode zonesplit .=20789 if zone_f==6
recode zonesplit .=20789 if zone_f==9
recode zonesplit .=20861 if zone_f==7
recode zonesplit .=20789 if zone_f==10
recode zonesplit .=20851 if zone_f==11
tab zonesplit,m

format zonesplit %td

stsplit timesplit, at(0) after(time=zonesplit) 
strate timesplit,per(10000)
drop timesplit
stjoin

* Persontime in study - used for calculating average recall period
gen persontime=daternd-enterdate
svy: mean persontime, over(zone_f)
svy: mean persontime

* Arrivals and departures from the population
replace joined_hh=1 if born_r==1
tab joined_hh
replace left_hh=1 if died_r==1
tab left_hh
tab joined_hh left_hh
tab joined_hh_date
tab left_hh_date

tab left_hh zone_f,col chi
tab joined_hh zone_f,col chi

* Demographics
tab zone_f
tab sex zone_f,col
svy: tab agecat sex,col
univar age_yr
univar age_yr, by(zone_f)
bysort zone_f: tab agecat sex,col nofreq

* Morbidity
svy: tab ill_2wk if ill_2wk!=2
tab ill_2wk zone_f if ill_2wk!=2, col chi
svy: tab ill_2wk sex if ill_2wk!=2,col
svy: tab ill_2wk age3 if ill_2wk!=2,col

gen age5=.
replace age5=1 if age_yr<5
replace age5=2 if age_yr>=5 & age_yr<50
replace age5=3 if age_yr>=50
lab def age5 1"<5" 2"5-49" 3"50+"
lab val age5 age5

bysort sex zone_f: tab ill_2wk age5 if ill_2wk!=2,col
svy: proportion ill_2wk if ill_2wk!=2, over(sex age5)
svy: proportion ill_2wk if ill_2wk!=2, over(sex)
svy: tab ill_2wk age5 if ill_2wk!=2,col

* Number of symptoms
gen ill_sym_num=ill_diarrhoea+ill_resp+ill_malnut+ill_preg+ill_malar+ill_acc+ill_violence+ill_unknown+ill_other
svy: tab ill_sym_num if ill_2wk==1

svy: tab ill_diarrhoea if ill_2wk==1
svy: tab ill_resp if ill_2wk==1
svy: tab ill_malnut if ill_2wk==1
svy: tab ill_preg if ill_2wk==1
svy: tab ill_malar if ill_2wk==1
svy: tab ill_acc if ill_2wk==1
svy: tab ill_violence if ill_2wk==1
svy: tab ill_unknown if ill_2wk==1
svy: tab ill_other if ill_2wk==1

tab ill_diarrhoea zone_f if ill_2wk==1,col chi
tab ill_resp zone_f if ill_2wk==1,col chi
tab ill_malnut zone_f if ill_2wk==1,col chi
tab ill_preg zone_f if ill_2wk==1,col chi
tab ill_malar zone_f if ill_2wk==1,col chi
tab ill_acc zone_f if ill_2wk==1,col chi
tab ill_violence zone_f if ill_2wk==1,col chi
tab ill_unknown zone_f if ill_2wk==1,col chi
tab ill_other zone_f if ill_2wk==1,col chi

svy: tab ill_diarrhoea age6 if ill_2wk==1,col
svy: tab ill_resp age6 if ill_2wk==1,col
svy: tab ill_malnut age6 if ill_2wk==1,col
svy: tab ill_preg age6 if ill_2wk==1,col
svy: tab ill_malar age6 if ill_2wk==1,col
svy: tab ill_acc age6 if ill_2wk==1,col
svy: tab ill_violence age6 if ill_2wk==1,col
svy: tab ill_unknown age6 if ill_2wk==1,col
svy: tab ill_other age6 if ill_2wk==1,col

* Care seeking
svy: tab seek_clinic
svy: tab seek_no
svy: tab seek_self
svy: tab seek_trad
svy: tab seek_oth

tab seek_clinic zone_f,col chi
tab seek_no zone_f,col chi
tab seek_self zone_f,col chi
tab seek_trad zone_f,col chi
tab seek_oth zone_f,col chi

svy: tab reas_nocash
svy: tab reas_toosick
svy: tab reas_notsickeno
svy: tab reas_toofar
svy: tab reas_notime
svy: tab reas_notrust
svy: tab reas_security
svy: tab reas_refused
svy: tab reas_oth

tab reas_nocash zone_f,col chi
tab reas_toosick zone_f,col chi
tab reas_notsickeno zone_f,col chi
tab reas_toofar zone_f,col chi
tab reas_notime zone_f,col chi
tab reas_notrust zone_f,col chi
tab reas_security zone_f,col chi
tab reas_refused zone_f,col chi
tab reas_oth zone_f,col chi

* Clinic type
svy: tab clinic_typ
tab clinic_typ zone_f, col chi

* Violence
svy: tab violence
tab violence zone_f, col chi

recode violence_num 0=1 1=2 2=3 3=4 4=5 5=6 6=7 7=8 8=9
svy: tab violence_num
svy: mean violence_num

tab violence_date sex

svy: tab viol_beaten sex,col
svy: tab viol_sexual sex,col
svy: tab viol_shot sex,col
svy: tab viol_kidnap sex,col
svy: tab viol_unk sex,col
svy: tab viol_oth sex,col

svy: tab violence died_recall,row

svy: tab viol_loc_home
svy: tab viol_loc_work
svy: tab viol_loc_journey
svy: tab viol_loc_unk
svy: tab viol_loc_oth

* Under 5 health - vaccines
svy: tab vac_measle
tab vac_measle zone_f, col chi
svy: tab vac_polio
tab vac_polio zone_f, col chi
svy: tab vac_men
tab vac_men zone_f, col chi
svy: tab vac_penta
tab vac_penta zone_f, col chi
svy: tab vac_pcv
tab vac_pcv zone_f, col chi
svy: tab vac_no
tab vac_no zone_f, col chi
svy: tab vac_dk
tab vac_dk zone_f, col chi
svy: tab vac_any
tab vac_any zone_f, col chi

svy: tab vac_card
svy: tab vac_card vac_any
tab vac_card zone_f if vac_any==1,col
tab vac_card zone_f,col chi

gen vac_num=vac_measle + vac_polio + vac_men + vac_penta + vac_pcv
svy: tab vac_num
tab vac_num zone_f,col chi

* Malnutrition
svy: tab oedema
svy: tab oedema if oedema<2
tab oedema zone_f if oedema<2,col chi

sum muac
svy: mean muac
mean muac, over(zone_f)

svy: tab gam
svy: tab muac_cat

tab gam zone_f,col chi
tab muac_cat zone_f,col chi

*Bednets
replace bednet=. if bednet==2
svy: tab bednet
tab bednet zone_f, col chi
svy: tab bednet age5, col
svy: tab bednet sex, col

* Regression on ill in the last 2 weeks
* <5s
svy: logistic ill_2wk i.sex
svy: logistic ill_2wk i.zone_f
svy: logistic ill_2wk ib2.age5
svy: logistic ill_2wk i.gam
svy: logistic ill_2wk i.sex i.zone_f i.gam
* Final model
svy: logistic ill_2wk i.sex ib2.age5 i.zone_f

* Bednets?
svy: logistic bednet i.sex i.age5 i.zone_f
* Mortality?
svy: logistic died_recall ib1.sex
svy: logistic died_recall ib1.sex i.age3
svy: logistic died_recall ib1.sex i.age3 i.zone_f
svy: logistic died_recall ib1.sex i.age3 i.zone_f i.ill_2wk

* Household analysis - avergae household size
* _n gives counts the observations for each unique observation in var
* _N gives the highest count for each observation
bysort Z_HHID: gen n1=_n
bysort Z_HHID: gen n2=_N

svy: mean n2 if n1==1 & left_hh==0
svy, over (zone_f): mean n2 if n1==1

bysort Z_HHID sex: gen n1m=_n if sex==0
bysort Z_HHID sex: gen n2m=_N if sex==0
svy: mean n2m if n1m==1
svy,over(zone_f): mean n2m if n1m==1

bysort Z_HHID sex: gen n1f=_n if sex==1
bysort Z_HHID sex: gen n2f=_N if sex==1
svy: mean n2f if n1f==1
svy,over(zone_f): mean n2f if n1f==1

bysort Z_HHID age6: gen n15=_n if age6==1
bysort Z_HHID age6: gen n25=_N if age6==1
svy: mean n25 if n15==1 & left_hh==0

svy,over(zone_f): mean n25 if n15==1

tab n1 zone_f
svy,over(zone_f): mean age_yr

by Z_HHID, sort: gen nvals = _n == 1 
count if nvals 

* Care seeking by type of illness
svy: proportion ill_diarrhoea seek_no  if ill_diarrhoea==1
svy: proportion ill_diarrhoea seek_clinic  if ill_diarrhoea==1

svy: proportion ill_resp seek_no if ill_resp==1
svy: proportion ill_resp seek_clinic if ill_resp==1

svy: proportion ill_malnut seek_no if ill_malnut==1
svy: proportion ill_malnut seek_clinic if ill_malnut==1

svy: proportion ill_preg seek_no if ill_preg==1
svy: proportion ill_preg seek_clinic if ill_preg==1

svy: proportion ill_malar seek_no if ill_malar==1
svy: proportion ill_malar seek_clinic if ill_malar==1

svy: proportion ill_acc seek_no if ill_acc==1
svy: proportion ill_acc seek_clinic if ill_acc==1

svy: proportion ill_violence seek_no if ill_violence==1
svy: proportion ill_violence seek_clinic if ill_violence==1

svy: proportion ill_unknown seek_no if ill_unknown==1
svy: proportion ill_unknown seek_clinic if ill_unknown==1

svy: proportion ill_other seek_no if ill_other==1
svy: proportion ill_other seek_clinic if ill_other==1



