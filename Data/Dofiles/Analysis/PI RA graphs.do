
	 use "${data_fin}/Replicable research - Clean data set", clear
	 
	 merge 1:1 key using "${data_int}/Replicable research - Merged data set", nogen update
	 
	 keep if inlist(sample, 3, 4)

	 * Could benefit from adoption of tools
	lab def tranings_more	1 "Version control software" ///
							2 "Data managements tools" ///
							3 "Code automation" ///
							4 "Coding practices	" ///
							5 "Internal code review" ///
							6 "External code review" ///
							0 "None of the above"
							
	local tranings_moretitle	DIME - Benefit
	
	* Constraints to adoption
	lab def constraints		1 "No time to learn" ///
							2 "Does not know the best options" ///
							3 "Difficult for PIs to review the code" ///
							4 "Difficult to access PI training" ///
							5 "Difficult to access RA training" ///
							6 "High entry cost" ///
							7 "Low cost benefit" ///
							8 "Coordination with coauthors" ///
							0 "Other"	
							
	lab def prepared		0 "Very unprepared" ///
							4 "Very prepared", replace
							
	lab def involvement			1 "Other" 2 "Never" 3 "Sometimes" 4 "Often" 5 "Does most of the coding", replace
	lab def code_review			1 "No" 2 "Yes" 3 "It varied by team" 4 "Do not know" ,replace
	lab def code_review_ext		1 "No" 2 "Yes" 3 "It varied by team" 4 "Do not know" ,replace
	lab def trainings			1 "Version control" 2 "Data management" 3 "Code automation" 4 "Coding practices" 0 "None" 
	lab def abstraction			1 "Internal code review" 2 "External code review" 3 "Encouraged, but not systematic" 4 "Don't know" 0 "None" 
	lab def versions			1 "Version identifier" 2 "Initials and dates" 3 "Version control software" 4 "Separate folders" 0 "Other" 
	lab def tasks				1 "E-mail" 2 "Google docs" 3 "Asana" 4 "Slack" 0 "Other" 5 "GitHub issues" 6 "DropBox paper"
	lab def code_review_phase	1 "Before WP submission" 2 "Before journal submission" 3 "At specific milestones" 4 "At fixed intervals" 5 "As per RA/PI request" 0 "Other"
							
 	 foreach var in  directories protocols involvement code_review code_review_ext prepared  {
		tab `var', gen(`var'_)
	 }

	 collapse 	(sum) 	tasks_? versions_? softwares_? abstraction_? ///
						code_review_phase_? code_review_ext_phase_? ///
						trainings_? trainings_school_? tranings_more_? ///
						constraints_? trainings_ra_? /// 
						directories_? protocols_? involvement_? code_review_? prepared_? code_review_ext_? ///
				(count) years, ///
				by(pi)
	 
	 foreach var of varlist tasks_? versions_? softwares_? abstraction_? prepared_? ///
						code_review_phase_? code_review_ext_phase_? ///
						trainings_? trainings_school_? tranings_more_? ///
						constraints_? trainings_ra_? /// 
						directories_? protocols_? involvement_? code_review_? code_review_ext_? {
	
		replace `var' = (`var'/years)*100
	}
	 
	 foreach var in tasks versions abstraction ///
					code_review_phase ///
					trainings tranings_more ///
					constraints directories protocols ///
					involvement code_review code_review_ext prepared {
	
		preserve
		
			keep `var'_? pi
			
			* Reshape to long by option
			reshape long `var'_, i(pi) j(tool)
			lab val tool `var'
			
			* Round so it looks prettier
			replace `var'_ = round(`var'_ , 10)
			
				
			* Sample code from https://github.com/worldbank/Stata-IE-Visual-Library/blob/master/Library/Bar%20plots/Bar%20plot%20of%20two%20variables/do.do
			graph hbar `var'_ ///
					, over(pi) asy bargap(20) over(tool) nofill ///
					blabel(bar, format(%9.0f)) ///
					graphregion(color(white)) ///
					legend(r(1) order(2 "PI" 1 "RA") placement(top)) ///
					ylabel(, valuelabel) ///
					ytit("%") ///
					bar(1, color("91 155 213")) ///
					bar(2, color("237 125 49"))
					
			* Save graphs
			gr export 	"${output}/`var'.png", width(5000) replace	
					
		restore
	}
	