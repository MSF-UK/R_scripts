* Kap survey analysis
* Version 1.0
* John Guzek

* Housekeeping
cd "D:\Users\palorinya-epi\Desktop\Uganda\KAP\Datasets\Stata"
clear all
capture log close
set more off
log using kap1, append

use final_KAP_file.dta

* Renaming all vars
rename L0_q1_team_number team_num
rename L0_q4_what_zone_are_you_in zone
rename L0_q3_household_id_the_gps_point hhid
rename L0_q10_what_is_the_respondent_se hhh_sex
rename L0_q7_what_is_the_respondent_age hhh_age
rename L0_q2_has_the_respondent_given_v consent
rename L0_q12_specify_what_are_the_main mal_sign_oth
rename L0_q13_malaria_is_characterised_ mal_ever
rename L0_q14_how_do_you_think_you_beco mal_risk
rename L0_q15_specify_how_you_think_you mal_risk_oth
rename L0_q17_specify_how_you_can_prote mal_pro_oth
rename L0_q18_what_do_you_do_when_you_o mal_health_seek
rename L0_q116_specify_what_do_you_do_w mal_health_seek_oth
rename L0_q113_what_prevents_you_from_v clinic_why_not
rename L0_q114_specify_what_prevents_yo clinic_why_not_oth
rename L0_q90_how_long_do_you_wait_befo health_seek_when
rename L0_q92_please_specify_how_long_y health_seek_when_oth
rename L0_q29_how_far_is_your_nearest_h nearest_clinic
rename L0_q30_please_specify_how_far_is nearest_clinic_oth
rename L0_q31_do_you_have_a_bed_net_in_ have_net
rename L0_q32_has_somebody_explained_ho net_expl
rename L0_q33_specify_has_somebody_expl net_expl_oth
rename L0_q99_do_you_wash_your_bednets wash_net
rename L0_q98_how_often_do_you_wash_you wash_when
rename L0_q102_please_specify_how_often wash_when_oth
rename L0_q97_how_do_you_dry_the_bed_ne dry_how
rename L0_q103_specify_how_do_you_dry_t dry_how_oth
rename L0_q34_during_which_period_of_th net_season
rename L0_q35_specify_during_which_peri net_season_oth
rename L0_q37_do_you_repair_the_bed_net net_repair
rename L0_q104_does_anyone_in_household sleep_outside
rename L0_q106_does_that_person_use_a_b net_outside
rename L0_q108_specify_what_other_ways_ mosq_pro_oth
rename L0_q39_what_do_you_like_most_abo net_like
rename L0_q40_specify_what_do_you_like_ net_like_oth
rename L0_q44_if_you_had_no_bed_net_and net_use_who
rename L0_q45_specify_if_you_had_no_bed net_use_who_oth
rename L0_q53_specify_if_you_received_t net2_use_who_oth
rename L0_q49_when_do_you_and_your_fami bitten_most_when
rename L0_q50_do_you_get_bitten_by_mosq bitten_most_where
rename L0_q54_where_is_the_first_bed_ne net1_from
rename L0_q55_specify_where_the_bed_net net1_from_oth
rename L0_q56_what_is_the_age_of_the_be net1_age
rename L0_q109_what_is_the_make_of_the_ net1_make
rename L0_q110_specify_the_make_of_the_ net1_make_oth
rename L0_q111_is_the_bed_net_still_pac net1_packed
rename L0_q57_is_the_bed_net_drying_in_ net1_drysun
rename L0_q58_does_the_bed_net_has_hole net1_holes
rename L0_q59_how_many_holes_smaller_th net1_smallholes
rename L0_q60_how_many_holes_bigger_tha net1_largeholes
rename L0_q61_do_you_have_a_second_bed_ net2
rename L0_q67_where_is_the_second_bed_n net2_from
rename L0_q68_specify_where_the_second_ net2_from_oth
rename L0_q69_what_is_the_age_of_the_se net2_age
rename L0_q118_what_is_the_make_of_the_ net2_make
rename L0_q119_specidy_what_is_the_make net2_make_oth
rename L0_q120_is_the_second_net_still_ net2_packed
rename L0_q70_is_the_second_bed_net_dry net2_drysun
rename L0_q71_does_it_have_any_holes net2_holes
rename L0_q72_how_many_holes_smaller_th net2_smallholes
rename L0_q73_how_many_holes_bigger_tha net2_largeholes
rename L0_q74_do_you_have_a_third_bed_n net3
rename L0_q76_where_is_the_third_bed_ne net3_from
rename L0_q79_what_is_the_age_of_the_th net3_age
rename L0_q122_what_is_the_make_of_the_ net3_make
rename L0_q123_specify_what_is_the_make net3_make_oth
rename L0_q124_is_the_third_net_still_p net3_packed
rename L0_q80_is_the_third_bed_net_dryi net3_drysun
rename L0_q81_does_the_third_bed_net_ha net3_holes
rename L0_q82_how_many_holes_smaller_th net3_smallholes
rename L0_q83_how_many_holes_bigger_tha net3_largeholes
rename L0_q84_do_you_have_any_extra_bed more_nets
rename L0_q88_how_many_bed_nets_are_bei net_num
rename L1_q2_what_is_his_her_age_in_yea ind_age
rename L1_q3_what_is_the_person_age_in_ ind_age_mth
rename L1_q1_what_is_that_person_sex ind_sex
rename L1_q4_what_is_his_her_highest_le ind_educ
rename L1_q12_is_she_pregnant ind_preg
rename L1_q6_does_he_she_has_currently_ ind_mal
rename L1_q7_how_many_time_he_she_had_m ind_mal_num
rename L1_q5_has_he_she_slept_under_a_m ind_net
rename L1_q14_please_specify_the_reason net_reas_oth
rename L1_q13_please_specify_the_reason net_no_reas_oth

* Sort multiple response vars - ALL NEEDS AMENDMENT LATER ON!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
gen mal_sign_fev=.
recode mal_sign_fev .=1 if (L0_q11_what_are_the_main_signs_o==0|M==0|N==0|O==0|P==0|Q==0)
gen mal_sign_headache=.
recode mal_sign_headache .=1 if (L0_q11_what_are_the_main_signs_o==1|M==0|N==0|O==0|P==0|Q==0)
gen mal_sign_diar=.
recode mal_sign_diar .=1 if (L0_q11_what_are_the_main_signs_o==2|M==0|N==0|O==0|P==0|Q==0)
gen mal_sign_cough=.
recode mal_sign_cough .=1 if (L0_q11_what_are_the_main_signs_o==3|M==0|N==0|O==0|P==0|Q==0)
gen mal_sign_vom=.
recode mal_sign_vom .=1 if (L0_q11_what_are_the_main_signs_o==4|M==0|N==0|O==0|P==0|Q==0)
gen mal_sign_ab=.
recode mal_sign_ab .=1 if (L0_q11_what_are_the_main_signs_o==5|M==0|N==0|O==0|P==0|Q==0)
gen mal_sign_shiv=.
recode mal_sign_shiv .=1 if (L0_q11_what_are_the_main_signs_o==6|M==0|N==0|O==0|P==0|Q==0)
gen mal_sign_dk=.
recode mal_sign_dk .=1 if (L0_q11_what_are_the_main_signs_o==7|M==0|N==0|O==0|P==0|Q==0)
gen mal_sign_other=.
recode mal_sign_other .=1 if (L0_q11_what_are_the_main_signs_o==8|M==0|N==0|O==0|P==0|Q==0)

foreach x of varlist mal_sign_fev mal_sign_headache mal_sign_diar mal_sign_cough mal_sign_vom mal_sign_ab mal_sign_shiv mal_sign_dk mal_sign_other {
recode `x' (.=0) if `x'==.
}

gen mal_pro_water=.
recode mal_pro_water .=1 if (L0_q16_how_can_you_protect_yours==0|W==0|X==0)
gen mal_pro_net=.
recode mal_pro_net .=1 if (L0_q16_how_can_you_protect_yours==1|W==1|X==1)
gen mal_pro_sleeve=.
recode mal_pro_sleeve .=1 if (L0_q16_how_can_you_protect_yours==2|W==2|X==2)
gen mal_pro_cide=.
recode mal_pro_cide .=1 if (L0_q16_how_can_you_protect_yours==3|W==3|X==3)
gen mal_pro_other=.
recode mal_pro_other .=1 if (L0_q16_how_can_you_protect_yours==4|W==4|X==4)
gen mal_pro_trad=.
recode mal_pro_trad .=1 if (L0_q16_how_can_you_protect_yours==5|W==5|X==5)

foreach x of varlist mal_pro_water mal_pro_net mal_pro_sleeve mal_pro_cide mal_pro_other mal_pro_trad {
recode `x' (.=0) if `x'==.
}

gen use_hang=.
recode use_hang .=1 if (L0_q100_could_you_please_explain==0|AL==0|AM==0)
gen use_tuck=.
recode use_tuck .=1 if (L0_q100_could_you_please_explain==1|AL==1|AM==1)
gen use_tie=.
recode use_tie .=1 if (L0_q100_could_you_please_explain==2|AL==2|AM==2)

foreach x of varlist use_hang use_tuck use_tie {
recode `x' (.=0) if `x'==. & have_net==0
}

gen pro_cide=.
recode pro_cide .=1 if (L0_q107_what_other_ways_do_you_p==0|AY==0|AZ==0)
gen pro_rep=.
recode pro_rep .=1 if (L0_q107_what_other_ways_do_you_p==1|AY==1|AZ==1)
gen pro_coil=.
recode pro_coil .=1 if (L0_q107_what_other_ways_do_you_p==2|AY==2|AZ==2)
gen pro_nowt=.
recode pro_nowt .=1 if (L0_q107_what_other_ways_do_you_p==3|AY==3|AZ==3)
gen pro_other=.
recode pro_other .=1 if (L0_q107_what_other_ways_do_you_p==4|AY==4|AZ==4)

foreach x of varlist pro_cide pro_rep pro_coil pro_nowt pro_other {
recode `x' (.=0) if `x'==. 
}

gen net2_use_fem=.
recode net2_use_fem .=1 if (L0_q48_if_you_received_two_bed_n==0|BG==0|BH==0)
gen net2_use_preg=.
recode net2_use_preg .=1 if (L0_q48_if_you_received_two_bed_n==1|BG==1|BH==1)
gen net2_use_male=.
recode net2_use_male .=1 if (L0_q48_if_you_received_two_bed_n==2|BG==2|BH==2)
gen net2_use_child=.
recode net2_use_child .=1 if (L0_q48_if_you_received_two_bed_n==3|BG==3|BH==3)
gen net2_use_old=.
recode net2_use_old .=1 if (L0_q48_if_you_received_two_bed_n==4|BG==4|BH==4)
gen net2_use_all=.
recode net2_use_all .=1 if (L0_q48_if_you_received_two_bed_n==5|BG==5|BH==5)
gen net2_use_sell=.
recode net2_use_sell .=1 if (L0_q48_if_you_received_two_bed_n==6|BG==6|BH==6)
gen net2_use_other=.
recode net2_use_other .=1 if (L0_q48_if_you_received_two_bed_n==7|BG==7|BH==7)

foreach x of varlist net2_use_fem net2_use_preg net2_use_male net2_use_child net2_use_old net2_use_all net2_use_sell net2_use_other {
recode `x' (.=0) if `x'==. 
}

gen ind_reas_clinic=.
recode ind_reas_clinic .=1 if (L1_q8_reason_to_use_a_mosquito_n==0|DB==0|DC==0)
gen ind_reas_bite=.
recode ind_reas_bite .=1 if (L1_q8_reason_to_use_a_mosquito_n==1|DB==1|DC==1)
gen ind_reas_friend=.
recode ind_reas_friend .=1 if (L1_q8_reason_to_use_a_mosquito_n==2|DB==2|DC==2)
gen ind_reas_mal=.
recode ind_reas_mal .=1 if (L1_q8_reason_to_use_a_mosquito_n==3|DB==3|DC==3)
gen ind_reas_priv=.
recode ind_reas_priv .=1 if (L1_q8_reason_to_use_a_mosquito_n==4|DB==4|DC==4)
gen ind_reas_other=.
recode ind_reas_other .=1 if (L1_q8_reason_to_use_a_mosquito_n==5|DB==5|DC==5)

foreach x of varlist ind_reas_clinic ind_reas_bite ind_reas_friend ind_reas_mal ind_reas_priv ind_reas_other {
recode `x' (.=0) if `x'==. & ind_net==0
}

gen ind_reasno_netnum=.
recode ind_reasno_netnum .=1 if (L1_q9_reason_not_to_use_a_mosqui==0|DF==0|DG==0)
gen ind_reasno_netmis=.
recode ind_reasno_netmis .=1 if (L1_q9_reason_not_to_use_a_mosqui==1|DF==1|DG==1)
gen ind_reasno_nethang=.
recode ind_reasno_nethang .=1 if (L1_q9_reason_not_to_use_a_mosqui==2|DF==2|DG==2)
gen ind_reasno_nethot=.
recode ind_reasno_nethot .=1 if (L1_q9_reason_not_to_use_a_mosqui==3|DF==3|DG==3)
gen ind_reasno_netuseoth=.
recode ind_reasno_netuseoth .=1 if (L1_q9_reason_not_to_use_a_mosqui==4|DF==4|DG==4)
gen ind_reasno_other=.
recode ind_reasno_other .=1 if (L1_q9_reason_not_to_use_a_mosqui==5|DF==5|DG==5)

foreach x of varlist ind_reasno_netnum ind_reasno_netmis ind_reasno_nethang ind_reasno_nethot ind_reasno_netuseoth ind_reasno_other {
recode `x' (.=0) if `x'==. & ind_net==1
}

* Recode 0=1 1=0
foreach x of varlist consent mal_ever wash_net have_net net_repair net_outside net1_packed net1_drysun net1_holes net2 net2_packed net2_drysun net2_holes net3 net3_packed net3_drysun net3_holes more_nets ind_preg ind_mal ind_net {
recode `x' (0=1) (1=0)
}

* Category labels
lab def zone 0"Zone 1" 1"Zone 2" 2"Zone 3 East" 3"Zone 3 West" 4"Zone 1A/B" 5"Zone 1C/D/E" 6"Zone 1F"
lab val zone zone

lab def sex 0"Male" 1"Female"
lab val hhh_sex sex
lab val ind_sex sex

lab def yesno 0"No" 1"Yes"
foreach x of varlist consent sleep_outside mal_sign_fev mal_sign_headache net_outside net1_holes net2 net2_holes net3 net3_holes more_nets ind_preg mal_sign_diar mal_sign_cough mal_sign_vom mal_sign_ab mal_sign_shiv mal_sign_dk mal_sign_other mal_pro_water mal_pro_net mal_pro_sleeve mal_pro_cide mal_pro_other mal_pro_trad use_hang use_tuck use_tie pro_cide pro_rep pro_coil pro_nowt pro_other net2_use_fem net2_use_preg net2_use_male net2_use_child net2_use_old net2_use_all net2_use_sell net2_use_other ind_reas_clinic ind_reas_bite ind_reas_friend ind_reas_mal ind_reas_priv ind_reas_other ind_reasno_netnum ind_reasno_netmis ind_reasno_nethang ind_reasno_nethot ind_reasno_netuseoth ind_reasno_other {
lab val `x' yesno
}

lab def mal_ever 0"No" 1"Yes" 2"Don't know"
lab val mal_ever mal_ever

lab def mal_risk 0"Dirty water" 1"Mosquito bite" 2"Sharing house" 3"Don't know" 4"Other"
lab val mal_risk mal_risk

lab def mal_health_seek 0"Wait" 1"Church" 2"Trad" 3"MTI clinic" 4"MSF clinic" 5"Other" 6"Malaria point"
lab val mal_health_seek mal_health_seek 

lab def clinic_why_not 0"No cash" 1"No trust" 2"No staff" 3"Hard to reach" 4"No drugs" 5"No clinic" 6"Other"
lab val clinic_why_not clinic_why_not

lab def nearest_clinic 0"<30 mins" 1"30 mins-1 hour" 2"1-2 hours" 3"More than 2 hours" 4"Too far" 5"Other"
lab val nearest_clinic nearest_clinic

lab def health_seek_when 0"Don't seek help" 1"Same day" 2"1-2 days" 3"2-3 days" 4">3 days" 5"Other"
lab val health_seek_when health_seek_when

lab def have_net 0"No" 1"Yes" 2"Don't know"
lab val have_net have_net
lab val wash_net have_net
lab val net_repair have_net
lab val net1_packed have_net
lab val net2_packed have_net
lab val net3_packed have_net
lab val net1_drysun have_net
lab val net2_drysun have_net
lab val net3_drysun have_net
lab val ind_mal have_net
lab val ind_net have_net

lab def net_expl 0"Nobody" 1"Outreach" 2"MSF clinic" 3"Friend / family" 4"MTI clinic" 5"Other"
lab val net_expl net_expl

lab def wash_when 0"Once per week" 1"Once per month" 2"Once per year" 3"Other"
lab val wash_when wash_when

lab def dry_how 0"In sun" 1"In shade" 2"Inside" 3"Other"
lab val dry_how dry_how

lab def net_season 0"All year" 1"Rainy season" 2"Dry season" 3"Other"
lab val net_season net_season

lab def net_like 0"Protects from insects" 1"Protects from malaria" 2"Don't know" 3"Other"
lab val net_like net_like

lab def net_use_who 0"Female" 1"Pregnant" 2"Male" 3"<5" 4"Elderly" 5"Whole family" 6"Would sell" 7"Other"
lab val net_use_who net_use_who

lab def bitten_most_when 0"Day" 1"Evening" 2"Night" 3"Don't know"
lab val bitten_most_when bitten_most_when

lab def bitten_most_where 0"Inside" 1"Outside"
lab val bitten_most_where bitten_most_where

lab def netfrom 0"Bought" 1"Distribution" 2"MSF (ANC)" 3"MSF (other)" 4"Other clinic" 5"Don't know" 6"Other"
lab val net1_from netfrom
lab val net2_from netfrom
lab val net3_from netfrom

lab def netage 0"<1 year" 1"1 year" 2" 2 year" 3"3 Year" 4"4 Year" 5"5 Year" 6"Don't know" 7"6 years +"
lab val net1_age netage
lab val net2_age netage
lab val net3_age netage

lab def netmake 0"Permanet" 1"DuraNet" 2"NetProtect" 3"OlySet" 4"Interceptor" 5"Yorkool" 6"Don't know" 7"Other"
lab val net1_make netmake
lab val net2_make netmake
lab val net3_make netmake

lab def educ 0"None" 1"Primary" 2"Secondary" 3"University" 4"Don't know"
lab val ind_educ educ

* Weights TO AMEND!!!!!
gen weight=.
replace weight=0.261873 if zone==0
replace weight=2.031825 if zone==1
replace weight=1.429608 if zone==2
replace weight=1.642092 if zone==3
replace weight=1.191198 if zone==4
replace weight=0.279663 if zone==5
replace weight=0.221129 if zone==6

gen rowid=_n


svyset rowid [pweight=weight]
svy: tab mal_ever

* Responses per household - all if n1==1
drop if hhh_sex==.
drop if ind_age==.
drop if fact_0_id==216
bysort zone_hhid: gen n1=_n
tab hhh_sex if n1==1
bysort zone_hhid: gen n2=_N


* Demographics
svy,over(zone): mean ind_age
univar ind_age
svy: tab ind_sex zone,col
tab zone

svy,over(zone): mean n2 if n1==1

gen age1=.
replace age1=1 if ind_age<5
replace age1=2 if ind_age>=5 & ind_age<50
replace age1=3 if ind_age>=50
lab def age1 1"<5" 2"5-49" 3"50+"
lab val age1 age1
svy: tab age1 zone,col
svy: tab ind_educ zone, col

*Number of nets
gen hh_net_num=.
replace hh_net_num=1 if have_net==1
replace hh_net_num=2 if net2==1
replace hh_net_num=3 if net2==3
replace hh_net_num=net_num if net_num!=.
replace hh_net_num=0 if have_net==0

gen hh_net_per_p=hh_net_num/n2
tab hh_net_per_p if n1==1

gen universal=.
replace universal=1 if hh_net_per_p>=0.5
replace universal=0 if hh_net_per_p<0.5

svy: tab universal if n1==1
tab universal if n1==1
svy,over(zone): proportion universal  if n1==1
proportion universal  if n1==1,over(zone)

svy: tab hh_net_num if n1==1
tab hh_net_num zone if n1==1,col chi

svy: proportion ind_net
proportion ind_net, over(zone)
tab ind_net zone,col chi

svy,over(age1):proportion ind_net
proportion ind_net, over(zone age1)
bysort zone: tab ind_net age1,col chi

svy,over(ind_sex):proportion ind_net
proportion ind_net, over(zone ind_sex)
bysort zone: tab ind_net ind_sex,col chi

svy,over(ind_preg):proportion ind_net
proportion ind_net, over(zone ind_preg)
bysort zone: tab ind_net ind_preg,col chi

*Did anyone in the household use a bednet the previous night? 
egen hhbed=max(ind_net), by(zone_hhid)
svy: proportion hhbed if n1==1
proportion hhbed if n1==1,over(zone)


svy: proportion ind_reasno_netnum 
svy: proportion ind_reasno_netmis 
svy: tab ind_reasno_nethang 
svy: tab ind_reasno_nethot 
svy: tab ind_reasno_netuseoth 
svy: tab ind_reasno_other

svy: tab net_expl if n1==1
svy: proportion net_expl if n1==1
tab net_expl_oth if n1==1
tab net_expl zone if n1==1, col chi
proportion net_expl if n1==1, over(zone)

* Info on nets - should reshape and do by zone TO DO
tab net1_age
tab net2_age
tab net3_age

tab net1_age zone
tab net2_age zone
tab net3_age zone

tab net1_holes
tab net2_holes
tab net3_holes

tab net1_holes zone,m
tab net2_holes zone,m
tab net3_holes zone,m

tab net1_smallholes zone,m
tab net2_smallholes zone,m
tab net3_smallholes zone,m

tab net1_largeholes zone,m
tab net2_largeholes zone,m
tab net3_largeholes zone,m

* <3 years with / without holes OR >3 years without holes
* > 3 years with holes


* Malaria knowledge
svy: tab mal_sign_fev if n1==1
tab mal_sign_fev zone if n1==1, col chi

svy: tab mal_sign_headache  if n1==1
tab mal_sign_headache zone if n1==1, col chi

svy: tab mal_sign_diar  if n1==1
tab mal_sign_diar zone if n1==1, col chi

svy: tab mal_sign_cough  if n1==1
tab mal_sign_cough zone if n1==1, col chi

svy: tab mal_sign_vom  if n1==1
tab mal_sign_vom zone if n1==1, col chi

svy: tab mal_sign_ab  if n1==1
tab mal_sign_ab zone if n1==1, col chi

svy: tab mal_sign_shiv  if n1==1
tab mal_sign_shiv  zone if n1==1, col chi

svy: tab mal_sign_dk  if n1==1
tab mal_sign_dk zone if n1==1, col chi

svy: tab mal_sign_other if n1==1
tab mal_sign_other zone if n1==1, col chi

tab mal_sign_oth if n1==1

svy: tab mal_risk if n1==1
tab mal_risk zone if n1==1, m col chi

tab mal_risk_oth if n1==1


* bysort zone: tab *NET VAR HH* mal_risk, col chi


svy: tab mal_pro_water if n1==1
tab mal_pro_water zone if n1==1, col chi
svy: tab mal_pro_net  if n1==1
tab mal_pro_net zone if n1==1, col chi
svy: tab mal_pro_sleeve  if n1==1
tab mal_pro_sleeve zone if n1==1,col chi
svy: tab mal_pro_cide  if n1==1
tab mal_pro_cide zone if n1==1,col chi
svy: tab mal_pro_other  if n1==1
tab mal_pro_other zone if n1==1,col chi
svy: tab mal_pro_trad if n1==1
tab mal_pro_trad zone if n1==1,col chi
tab mal_pro_oth if n1==1
tab mal_pro_oth zone if n1==1,col chi


svy: logistic use_hang ib0.net_expl if n1==1
svy: logistic use_tuck ib0.net_expl if n1==1
svy: logistic use_tie ib0.net_expl if n1==1

svy: tab net_like if n1==1
tab net_like zone if n1==1, m col chi
tab net_like_oth if n1==1

svy: tab use_hang if n1==1
tab use_hang zone if n1==1,col chi
svy: tab use_tuck if n1==1
tab use_tuck zone if n1==1,col chi
svy: tab use_tie if n1==1
tab use_tie zone if n1==1,col chi
svy: tab wash_net if n1==1
tab wash_net zone if n1==1,col chi
svy: tab dry_how if n1==1
tab dry_how zone if n1==1,col chi

svy: tab wash_when if n1==1
tab wash_when zone if n1==1,col chi

svy: tab net_repair if n1==1
tab net_repair zone if n1==1,col chi

svy: tab ind_reas_clinic 
tab ind_reas_clinic zone,col chi
svy: tab ind_reas_bite 
tab ind_reas_bite zone,col chi
svy: tab ind_reas_friend 
tab ind_reas_friend zone,col chi
svy: tab ind_reas_mal 
tab ind_reas_mal zone,col chi
svy: tab ind_reas_priv 
tab ind_reas_priv zone,col chi
svy: tab ind_reas_other
tab ind_reas_other zone,col chi
tab net_reas_oth

svy: tab ind_reasno_netnum 
tab ind_reasno_netnum zone,col chi
svy: tab ind_reasno_netmis
tab ind_reasno_netmis zone,col chi
svy: tab ind_reasno_nethang
tab ind_reasno_nethang zone,col chi
svy: tab ind_reasno_nethot
tab ind_reasno_nethot zone,col chi
svy: tab ind_reasno_netuseoth
tab ind_reasno_netuseoth zone,col chi
svy: tab ind_reasno_other
tab ind_reasno_other zone,col chi
tab net_no_reas_oth zone

svy: tab net_season if n1==1
tab net_season zone if n1==1,col chi
tab net_season_oth if n1==1

svy: tab sleep_outside if n1==1
tab sleep_outside zone if n1==1,col chi

svy: tab net_outside if n1==1
tab net_outside zone if n1==1,col chi

gen age2=.
replace age2=1 if ind_age<15
replace age2=2 if ind_age>=15 & ind_age<50
replace age2=3 if ind_age>=50

lab def age2 1"<15" 2"15-49" 3"50+"
lab val age2 age2

svy: tab ind_mal
tab ind_mal zone,m col chi
svy: proportion ind_mal
proportion ind_mal, over(zone)
proportion ind_mal, over(ind_sex)
proportion ind_mal, over(age2)
proportion ind_mal, over(ind_preg)
svy: tab ind_mal_num

gen ind_malhad=.
replace ind_malhad=1 if ind_mal_num>0
replace ind_malhad=0 if ind_mal_num==0
svy: proportion ind_malhad
svy,over(zone): proportion ind_malhad
svy,over(ind_sex): proportion ind_malhad
svy,over(ind_preg): proportion ind_malhad


svy,over(age1): proportion ind_malhad
svy,over(age2): proportion ind_malhad

svy,over(ind_preg): proportion ind_malhad

proportion ind_malhad,over(zone)
tab ind_malhad zone,col
svy,over(zone ind_sex): proportion ind_malhad
svy,over(zone ind_sex age1): proportion ind_malhad
svy,over(zone ind_sex): proportion ind_malhad
svy,over(zone age2): proportion ind_malhad
svy,over(zone age2): proportion ind_malhad
svy,over(zone ind_preg): proportion ind_malhad
svy,over(zone ): proportion ind_malhad
svy,over(ind_sex age2 ): proportion ind_malhad
svy,over(ind_sex  ): proportion ind_malhad
svy,over(ind_preg  ): proportion ind_malhad
svy,over(age2  ): proportion ind_malhad
svy: proportion ind_malhad


tab net1_age
tab net2_age
tab net3_age

tab net1_age zone
tab net2_age zone
tab net3_age zone

gen net1age3=.
replace net1age3=0 if net1_age<3
replace net1age3=1 if net1_age>=3
replace net1age3=. if net1_age==6

gen net2age3=.
replace net2age3=0 if net2_age<3
replace net2age3=1 if net2_age>=3
replace net2age3=. if net2_age==6

gen net3age3=.
replace net3age3=0 if net3_age<3
replace net3age3=1 if net3_age>=3
replace net3age3=. if net3_age==6

gen largeholesbin1=.
replace largeholesbin1=0 if net1_largeholes==0
replace largeholesbin1=1 if net1_largeholes>0
replace largeholesbin1=. if net1_largeholes==.

gen largeholesbin2=.
replace largeholesbin2=0 if net2_largeholes==0
replace largeholesbin2=1 if net2_largeholes>0
replace largeholesbin2=. if net2_largeholes==.

gen largeholesbin3=.
replace largeholesbin3=0 if net3_largeholes==0
replace largeholesbin3=1 if net3_largeholes>0
replace largeholesbin3=. if net3_largeholes==.

by zone: tab largeholesbin1 net1age3
by zone: tab largeholesbin2 net2age3
by zone: tab largeholesbin3 net3age3


* Looking at n people sleeping under LLITNs as per comment from Ruby
bysort zone_hhid: gen n1nets=_n if ind_net==1
gen npernet=n1nets/hh_net_num
svy: mean npernet
univar npernet
tab ind_net hh_net_num

* Gen all non-preg
gen nonpreg=.
replace nonpreg=1 if ind_sex!=.
replace nonpreg=0 if ind_preg==1

svy,over(nonpreg): proportion ind_net
proportion ind_net, over(zone)
tab ind_net zone,col chi





