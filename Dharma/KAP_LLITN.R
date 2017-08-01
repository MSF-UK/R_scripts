# R Code for LLITN KAP on Dharma
# Derek Johnson

library(psych)
library(dplyr)
library(tidyr)
library(gmodels)

KAP <- read.csv(file="C:/Users/XXXXXXXXXXXX/Desktop/R for KAP/CSVKAPDerek.csv", header=TRUE, sep=",")

#Creating a data set of just household respondents#
#Sorting#

attach(KAP)
KAP2 <- KAP[order(KAP$fact_0_id),]
detach(KAP)

#Re-Categorizing vars#
#where was your LLITN from#
wherenet2 <- L0_q54_where_is_the_first_bed_ne
#Does your bednet have holes in it#
nethole2 <- L0_q58_does_the_bed_net_has_hole
#Do you have a second LLITN#
secondnet2 <- L0_q61_do_you_have_a_second_bed_
unicover <-0

#Family Size#
famsize <- by(KAP2, KAP2$fact_0_id, function(x){
  count(KAP2, vars = fact_1_id)
})

#categorize malaria knolwedge#
KAP2$malaria[KAP2$L0_q13_malaria_=="No"] <- 1
KAP2$malaria[KAP2$L0_q13_malaria_=="Uns"] <- 1
KAP2$malaria[KAP2$L0_q13_malaria_=="Yes"] <- 2

#How long do you wait until you go to the clinic#
KAP2$clinicwait[KAP2$L0_q90_how_long_do_you_wait_befo == "I go the same day"] <- 1
KAP2$clinicwait[KAP2$L0_q90_how_long_do_you_wait_befo == "1-2 days"] <- 2
KAP2$clinicwait[KAP2$L0_q90_how_long_do_you_wait_befo =="2-3 days"] <- 3
KAP2$clinicwait[KAP2$L0_q90_how_long_do_you_wait_befo ==">3 days"] <- 3
KAP2$clinicwait[KAP2$L0_q90_how_long_do_you_wait_befo =="I don't seek help"] <- 4

#How far is your nearest clinic#
KAP2$walk[KAP2$L0_q29_how_far_is_your_nearest_h == "Less that a 30 mi"] <- 1
KAP2$walk[KAP2$L0_q29_how_far_is_your_nearest_h == "30 minutes to 1 h"] <- 2
KAP2$walk[KAP2$L0_q29_how_far_is_your_nearest_h == "1 to 2 hours walk"] <- 3
KAP2$walk[KAP2$L0_q29_how_far_is_your_nearest_h == "More than a 2 hou"] <- 4

#If you had one LLITN who would use it in your household#
KAP2$onenet[KAP2$L0_q44_if_you_had_no_bed_net_and == "Children under 5 years old"] <- 1
KAP2$onenet[KAP2$L0_q44_if_you_had_no_bed_net_and == "Female member of the house"] <- 2
KAP2$onenet[KAP2$L0_q44_if_you_had_no_bed_net_and == "Pregnant women" ] <- 3
KAP2$onenet[KAP2$L0_q44_if_you_had_no_bed_net_and == "Male member of the househo"] <- 4
KAP2$onenet[KAP2$L0_q44_if_you_had_no_bed_net_and == "Older / Elderly members" ] <- 4
KAP2$onenet[KAP2$L0_q44_if_you_had_no_bed_net_and == "Other"] <- 4
KAP2$onenet[KAP2$L0_q44_if_you_had_no_bed_net_and == "The whole family"] <- 4
KAP2$onenet[KAP2$L0_q44_if_you_had_no_bed_net_and == "I would sell it"] <- 5

#Where was your first LLITN from#
KAP2$wherenet[KAP2$wherenet2 == "."] <-"."
KAP2$wherenet[KAP2$wherenet2 == "Bought"] <- 1
KAP2$wherenet[KAP2$wherenet2 == "General Distribution"] <- 2
KAP2$wherenet[KAP2$wherenet2 == "MSF clnic (ANC)"] <- 3
KAP2$wherenet[KAP2$wherenet2 == "Other"] <- 3
KAP2$wherenet[KAP2$wherenet2 == "Other health center"] <- 3

#categorize holes in LLITN#
KAP2$nethole[KAP2$nethole2 == "."] <-"."
KAP2$nethole[KAP2$nethole2 == "No"] <- 1
KAP2$nethole[KAP2$nethole2 == "Yes"] <- 2

#categorize do you have a second net#
KAP2$secondnet[KAP2$secondnet2 == "."] <-"."
KAP2$secondnet[KAP2$secondnet2 == "No"] <- 1
KAP2$secondnet[KAP2$secondnet2== "Yes"] <- 2

#categorize do you have a LLITN#
KAP2$bednet[KAP2$L0_q31_do_you_have_a_bed_net_in_ == "."] <-"."
KAP2$bednet[KAP2$L0_q31_do_you_have_a_bed_net_in_ == "No"] <- 1
KAP2$bednet[KAP2$L0_q31_do_you_have_a_bed_net_in_ == "Yes"] <- 2

#categorize age#
KAP2$age[KAP2$L1_q2_what_is_his_her_age_in_yea >=0 & KAP$L1_q2_what_is_his_her_age_in_yea<11 ] <- 1
KAP2$age[KAP2$L1_q2_what_is_his_her_age_in_yea >=11 & KAP$L1_q2_what_is_his_her_age_in_yea<21] <- 2
KAP2$age[KAP2$LL1_q2_what_is_his_her_age_in_yea >=21 & KAP$L1_q2_what_is_his_her_age_in_yea<31] <- 3
KAP2$age[KAP2$L1_q2_what_is_his_her_age_in_yea >=31 & KAP$L1_q2_what_is_his_her_age_in_yea<41] <- 4
KAP2$age[KAP2$L1_q2_what_is_his_her_age_in_yea >=41 & KAP$L1_q2_what_is_his_her_age_in_yea<51] <- 5
KAP2$age[KAP2$L1_q2_what_is_his_her_age_in_yea >=51 & KAP$L1_q2_what_is_his_her_age_in_yea<61] <- 6
KAP2$age[KAP2$L1_q2_what_is_his_her_age_in_yea >=60] <- 7

#categorize Under 5 years of age#
KAP2$under5[KAP2$L1_q2_what_is_his_her_age_in_yea >=0 & KAP2$L1_q2_what_is_his_her_age_in_yea<5] <-1
KAP2$under5[KAP2$L1_q2_what_is_his_her_age_in_yea >5] <-2

#categorize where do you go if you are sick#
KAP2$wherego[KAP2$L0_q18_what_do_you_do_when_you_o=="I go to the MSF clinic"] <- 1
KAP2$wherego[KAP2L0_q18_what_do_you_do_when_you_o=="I go to the health post"] <- 2
KAP2$wherego[KAP2L0_q18_what_do_you_do_when_you_o=="I go to a traditional"] <- 3
KAP2$wherego[KAP2L0_q18_what_do_you_do_when_you_o=="I go to the church"] <- 3
KAP2$wherego[KAP2L0_q18_what_do_you_do_when_you_o=="I wait until the fever"] <- 3

#categorize LLITN and family size#
KAP2$unicover[KAP2$L0_q31_do_you_have_a_bed_net_in_ =="Yes" & KAP2$famsize==1] <- 1
KAP2$unicover[KAP2$L0_q31_do_you_have_a_bed_net_in_ =="Ye" & KAP2$famsize==2] <- 1
KAP2$unicover[KAP2$L0_q31_do_you_have_a_bed_net_in_ =="Yes" & KAP2$famsize==3] <- 1
KAP2$unicover[KAP2$L0_q31_do_you_have_a_bed_net_in_ =="Yes" & KAP2$famsize==4] <- 1

#Frequencies of KAP variables#
CrossTable(KAP2$L1_q1_what_is_that_person_sex, KAP2$age, prop.t=TRUE, prop.r=TRUE, prop.c=TRUE)

x< c(KAP2$malaria, KAP2$L0_q14_how_do_you_think_you_beco, KAP2$L0_q18_what_do_you_do_when_you_o,
     KAP2$clinicwait, KAP2$walk, KAP2$L0_q31_do_you_have_a_bed_net_in_, KAP2$onenet, KAP2$L0_q50_do_you_get_bitten_by_mosq, 
     KAP2$wherenet, KAP2$nethole, KAP2$secondnet)
freqtables<-lapply(x, table)

#Average family size#
mean(KAP2$famsize)

#Average age#
mean(KAP2$L1_q2_what_is_his_her_age_in_yea)

#Average family size by Ofua zone#
by(KAP2, L0_q4_what_ofua_zone_are_you_in, function(x){
  mean(KAP2$famsize)
})

#Average age by Ofua zone#
by(KAP2, L0_q4_what_ofua_zone_are_you_in, function(x){
  mean(KAP2$L1_q2_what_is_his_her_age_in_yea)
})

#Under 5 by Ofua zone#
by(KAP2, L0_q4_what_ofua_zone_are_you_in, function(x){
  mean(KAP2$Under5)
})

#Number pregnant by Ofua zone#
by(KAP2, L0_q4_what_ofua_zone_are_you_in, function(x){
  mean(KAP2$L1_q12_is_she_pregnant )
})

#Education by Ofua zone#
by(KAP2, L0_q4_what_ofua_zone_are_you_in, function(x){
  mean(KAP2$L1_q4_what_is_his_her_highest_le )
})

#Age category by Ofua zone#
by(KAP2, L0_q4_what_ofua_zone_are_you_in, function(x){
  mean(KAP2$age)
})

#Sex by Ofua zone#
by(KAP2, L0_q4_what_ofua_zone_are_you_in, function(x){
  mean(KAP2$L1_q1_what_is_that_person_sex)
})




