*data management stata
*automatically setting windows or mac/linux directory
*windows
*tempfile temp
*shell echo %USERPROFILE% > `temp'
*file open myfile using `temp', read
*file read myfile line
*file close myfile
*local home = trim("`line'")
*cd "`home'\Desktop\epp_repo\eppfinalproject_moritzraykowski\src\epp_final_project_MoritzRaykowski\data"
*import excel "surveydataraw.xls", sheet("Sheet1") firstrow  

* macOS/Linux
tempfile temp
shell echo $HOME > `temp'
file open myfile using `temp', read
file read myfile line
file close myfile
local home1 = trim("`line'")
cd "`home1'/Desktop/epp_repo/eppfinalproject_moritzraykowski/src/epp_final_project_MoritzRaykowski/data"
import excel "surveydataraw.xls", sheet("Sheet1") firstrow  


*renaming variables that are too long for stata
rename council_member_politiciancitizen counc_memb_polcit
rename council_electoral_process counc_elec_proc

*encoding of categorial and ordinal variables
*local creates a local macro in which something can be defined, stored, listed etc.
local strings1 DistributionChannel city_district citydistrict_ID sex position_respondent citizen_politician electoral_process polical_power council_member counc_memb_polcit counc_elec_proc council_power disabiilty_type
foreach v of local strings1 {
  encode `v', gen(`v'_encoded)
}

*replacing unclear survey answers with missings
ds, has(type string)
foreach var of varlist `r(varlist)' {
    qui replace `var' = subinstr(`var', "no value", ".", .)
}
ds, has(type string)
foreach var of varlist `r(varlist)' {
    qui replace `var' = subinstr(`var', "unknown", ".", .)
}
ds, has(type string)
foreach var of varlist `r(varlist)' {
    qui replace `var' = subinstr(`var', "no ans", ".", .)
}
ds, has(type string)
foreach var of varlist `r(varlist)' {
    qui replace `var' = subinstr(`var', "not fixed", ".", .)
}

*destringing, making variables numeric
local strings2 date_position_established budget duration_terms_in_years council_term_length date_council_established disability_degree INCLUSION RECOMMENDATION INTEREST PROBLEMSOLVING POPULARITY age population
foreach v of local strings2 {
  destring `v', replace
}

*encoding dummy variables with yes and no
local strings3 partymember disabled reelection_coming council_terms council_existence electoral_terms existence_representative
foreach v of local strings3 {
  encode `v', gen(`v'_encoded)
  replace `v'_encoded=0 if `v'_encoded==2
}

*encoding the complex ordinal variables
local strings4 voluntary_full_position education partyname
foreach v of local strings4 {
  gen `v'_encoded=.
}
replace education_encoded=1 if education=="Hauptschulabschluss"
replace education_encoded=2 if education=="Realschulabschluss"
replace education_encoded=3 if education=="Gymnasialabschluss"
replace education_encoded=4 if education=="Bachelor"
replace education_encoded=5 if education=="Master"
replace education_encoded=6 if education=="Doktor/PhD"
replace education_encoded=7 if education=="Professur"

replace voluntary_full_position_encoded=1 if voluntary_full_position=="Kommissarisch"
replace voluntary_full_position_encoded=2 if voluntary_full_position=="Ehrenamtlich"
replace voluntary_full_position_encoded=3 if voluntary_full_position=="Nebenamtlich"
replace voluntary_full_position_encoded=4 if voluntary_full_position=="Hauptamtlich"

replace partyname_encoded=1 if partyname=="Christlich Soziale Union in Bayern (CSU)"
replace partyname_encoded=2 if partyname=="Christlich Demokratische Union Deutschlands (CDU)"
replace partyname_encoded=3 if partyname=="Freie Wähler"
replace partyname_encoded=4 if partyname=="Sozialdemokratische Partei Deutschlands (SPD)"
replace partyname_encoded=5 if partyname=="Bündnis 90/Die Grünen"
replace partyname_encoded=6 if partyname=="Die Linke"

*generating variables that are used to differentiate treatment groups in different models
generate Treatment_binary = Treatment_ID
replace Treatment_binary=1 if Treatment_ID==2
generate Treatment_full = (Treatment_ID==1)
generate Treatment_attrition = (Treatment_ID==2)
gen ControlvsAttrition=.
replace ControlvsAttrition=0 if Treatment_ID==0 
replace ControlvsAttrition=1 if Treatment_ID==2
gen ControlvsFull=.
replace ControlvsFull=0 if Treatment_ID==0
replace ControlvsFull=1 if Treatment_ID==1
gen select=0 
replace select=1 if ControlvsFull!=.

*cd "`home'\Desktop\epp_repo\eppfinalproject_moritzraykowski\src\epp_final_project_MoritzRaykowski\data_cleaned"
cd "`home1'/Desktop/epp_repo/eppfinalproject_moritzraykowski/src/epp_final_project_MoritzRaykowski/data_cleaned"


save "surveywstata.dta"