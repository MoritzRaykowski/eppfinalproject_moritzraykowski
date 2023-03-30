*analysis epp
use "C:\Users\MoritzRaykowski\Desktop\zwischen\src\epp_final_project_MoritzRaykowski\data_cleaned\surveywstata.dta" 
change
*set directory in windows
cd "C:\Users\MoritzRaykowski\Desktop\zwischen\bld\tables_statapython" change
*set directory in mac and linux
*cd ~/bld/tables_statapython

*installing required stata modules for poltting, storing and exporting results, and leebounds
ssc install coefplot
ssc install estout
ssc install leebounds

*by preserving and restoring the data in memory is unchanged, the clean data set stays the way
*it is and one can always return to tzhe initial state
preserve
*leebounds on treatment effect naive and based on covariate disability 
local dependentvariables INCLUSION RECOMMENDATION INTEREST PROBLEMSOLVING POPULARITY
foreach v of local dependentvariables {
qui eststo: leebounds `v' Treatment_binary, select( select ) vce(analytic) level(95) cieffect
qui eststo: leebounds `v' Treatment_binary, select( select ) vce(analytic) level(95) cieffect tight(disabled_encoded)
}
*exporting
esttab using leebounds.tex, ci nocons

restore
*restoring to initial state
cd "C:\Users\MoritzRaykowski\Desktop\zwischen\bld\figures_statapython"
*cd ~/bld/figures_statapython

*Figure 1: naive ITT estimates of the treatment on reported scores
preserve
*local creates a local macro in which something can be defined, stored, listed etc.
local dependentvariables INCLUSION RECOMMENDATION INTEREST PROBLEMSOLVING POPULARITY
foreach v of local dependentvariables {
qui eststo reg_`v': reg `v' Treatment_binary, vce(hc2)
}
*with qui eststo all results are quietly stored, quietly meaning stata shows no outputs and only run code
*plotting the stored reg_v's
coefplot reg_*, xline(0) drop(_cons) bgcolor(white) xtitle("coefficients with 95% CI and standard errors, full sample (N 124)")  graphregion(fcolor(white)) mlabel(string(@se,"%9.3f")) mlabposition(5) mlabsize(small) mlabgap(*2) mlabcolor(black) ciopts(color(black)) plotlabels("Inclusion" "Recommendation" "Interests" "Problemsolving" "Popularity") scheme(s2mono)

graph export "naive ITT estimates of the treatment on reported policy scores_epp.jpg"

restore
 
*Figure 2: progressed ITT estimates of the treatment on reported scores
preserve
*quietly storing regression results
local dependentvariables INCLUSION RECOMMENDATION INTEREST PROBLEMSOLVING POPULARITY
foreach v of local dependentvariables {
qui eststo reg2_`v': reg `v' Treatment_binary disabled_encoded partymember_encoded education_encoded sex_encoded age city_district_encoded council_existence_encoded, vce(hc2)
}
*plottibng stored results
coefplot reg2_*, xline(0) drop(_cons education_encoded sex_encoded age city_district_encoded council_existence_encoded) bgcolor(white) xtitle("coefficients with 95% CI and standard errors, full sample (N 124)")  graphregion(fcolor(white)) mlabel(string(@se,"%9.3f")) mlabposition(12) mlabsize(small) mlabgap(*5) mlabcolor(none) addplot(scatter @at @ul, ms(i) mlabel(@mlbl) mlabsize(small) mlabcolor(black)) ciopts(color(black)) plotlabels("Inclusion" "Recommendation" "Interests" "Problemsolving" "Popularity") scheme(s2mono) aspectratio(0.8) coeflabels( Treatment_binary = "Treatment" partymember_encoded = "Partymember(y/n)" disabled_encoded = "Disability(y/n)" )

graph export "progressed ITT estimates of the treatment on reported policy scores_epp.jpg"

restore

*Figure 3: robustness plot for all specifications on the popularity scores 
*quietly storing regression results of robustness tests
preserve 
*1 pop full sample regional scattered
qui eststo R_full_sample_scattered: reg POPULARITY Treatment_binary disabled_encoded partymember_encoded education_encoded sex_encoded age city_district_encoded council_existence_encoded, vce(cluster citydistrict_ID_encoded) 
*2 pop full sample only reps
qui eststo R_full_sample_only_reps: reg POPULARITY Treatment_binary disabled_encoded partymember_encoded education_encoded sex_encoded age city_district_encoded council_existence_encoded voluntary_full_position_encoded electoral_process_encoded electoral_terms_encoded , vce(hc2) 
*3 pop control vs attrition hc2
qui eststo R_control_attrition_hc2: reg POPULARITY ControlvsAttrition reelection_coming_encoded population disabled_encoded partymember_encoded education_encoded sex_encoded age city_district_encoded council_existence_encoded, vce(hc2) 
*4 pop control vs attrition scattered
qui eststo R_con_atr_scat: reg POPULARITY ControlvsAttrition reelection_coming_encoded population disabled_encoded partymember_encoded education_encoded sex_encoded age city_district_encoded council_existence_encoded, vce(cluster citydistrict_ID_encoded) 
*5 pop control vs attrition only reps
qui eststo R_control_attrition_reps: reg POPULARITY ControlvsAttrition disabled_encoded partymember_encoded education_encoded sex_encoded age city_district_encoded council_existence_encoded voluntary_full_position_encoded electoral_process_encoded electoral_terms_encoded reelection_coming_encoded citizen_politician_encoded population, vce(hc2) 
*6 pop control vs full treatment hc2
qui eststo R_control_full_hc2: reg POPULARITY ControlvsFull disabled_encoded partymember_encoded education_encoded sex_encoded age city_district_encoded council_existence_encoded, vce(hc2) 
*7 pop control vs full treatment scattered
qui eststo R_control_full_scattered: reg POPULARITY ControlvsFull disabled_encoded partymember_encoded education_encoded sex_encoded age city_district_encoded council_existence_encoded , vce(cluster citydistrict_ID_encoded) 
*8 pop control vs full treatment only reps
qui eststo R_control_full_only_reps: reg POPULARITY ControlvsFull voluntary_full_position_encoded electoral_process_encoded electoral_terms_encoded disabled_encoded partymember_encoded education_encoded sex_encoded age city_district_encoded council_existence_encoded, vce(hc2) 
*plotting
coefplot R_*, coeflabels(Treatment_binary = "Full Sample" ControlvsAttrition = "Control vs Attrition" ControlvsFull  = "Control vs Full" ) keep(Treatment_binary ControlvsAttrition ControlvsFull) xline(0) bgcolor(white) xtitle("coefficients with 95% CI and standard errors")  graphregion(fcolor(white)) mlabel(string(@se,"%9.3f")) mlabposition(12) mlabsize(small) mlabgap(*5) mlabcolor(none) addplot(scatter @at @ul, ms(i) mlabel(@mlbl) mlabsize(small) mlabcolor(black)) ciopts(color(black)) plotlabels("scattered on region, N 124" "only representatives, N 85" "HC2 standard errrors, N 79" "scattered on region, N 79" "only representatives, N 55" "HC2 standard errors, N 85" "scattered on region, N 85" "only representatives, N 56") scheme(s2mono)
 
graph export "robustness plot for all specifications on the popularity scores_epp.jpg"
restore

