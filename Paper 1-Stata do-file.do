** DATA ANALYSIS FOR PAPER 1 (CHAPTER 3) - HOUSEHOLD FOOD WASTE DISPOSAL BEHAVIOURS
* Install fmlogit
ssc install fmlogit

* Table 1: Summary statistics of socio-demographic and household charactertistics (n=1030)
sum gender_v1 age Q25_uni_degree income_num Aus_life Q27_unit Q30 Q31_child_5 Q12_caddy Q28_compost Q29_pet
****************************

* Table 2: Summary statistics of key independent variables (n=1030)
* Mean scores of four index variables
sum Perceived_benefit Inconvenience_control Q17D_env_identity Q19_proenv

* Cronbach's alpha values of the above variables
* 1) Perceived_benefit (0.68)
alpha Q10D_1 Q10D_7 Q10D_8

* 2) Inconvenience_control (0.82)
alpha Q10D_4 Q10D_5 Q10D_6 Q10D_10 Q10D_11

* 3) Environmental self-identity (alpha=0.93)
alpha Q17D_1 Q17D_2 Q17D_3

* 4) Recycling habits (alpha=0.81)
alpha Q19_1 Q19_2 Q19_3
****************************

* Table 3: dependent variables (n=1027)
summarize Q10B2_1_1v1 Q10B2_1_2v1 Q10B2_1_3v1 Q10B2_1_4v1 Q10B2_1_5v1 Q10B2_1_698v1, detail

****************************
* fmlogit model:
* Check collinearity
ssc install collin
search collin
* choose: package name:  collin.pkg from: https://stats.oarc.ucla.edu/stat/stata/ado/analysis/

* Check collinearity of the independent variables
collin Perceived_benefit Inconvenience_control Q17D_env_identity Q12_caddy Q19_proenv Q28_compost Q29_pet gender_v1 age Q25_uni_degree Aus_life Q30 Q27_unit Q31_child_5 income_num 

* Table 4: fmlogit run (n=1027)
fmlogit Q10B2_1_1v1 Q10B2_1_2v1 Q10B2_1_3v1 Q10B2_1_4v1 Q10B2_1_5v1 Q10B2_1_698v1, eta (Perceived_benefit Inconvenience_control Q17D_env_identity i.Q12_caddy Q19_proenv i.Q28_compost i.Q29_pet i.gender_v1 age i.Q25_uni_degree Aus_life Q30 i.Q27_unit i.Q31_child_5 income_num) nolog

**Green bin
margins, dydx (*) predict(outcome(Q10B2_1_2v1))

**Compost
margins, dydx (*) predict(outcome(Q10B2_1_4v1))

**Pets
margins, dydx (*) predict(outcome(Q10B2_1_5v1))

**Red bin
margins, dydx (*) predict(outcome(Q10B2_1_1v1))

**Yellow bin
margins, dydx (*) predict(outcome(Q10B2_1_3v1))

**Sink and other
margins, dydx (*) predict(outcome(Q10B2_1_698v1))
						
