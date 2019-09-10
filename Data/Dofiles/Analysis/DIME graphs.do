/*******************************************************************************
*							Replicable Research 							   *
********************************************************************************

	** PURPOSE:  	Compare responses of DIME PIs and RAs 
	
	** OUTLINE:							
	
	** REQUIRES:	"${data_fin}/Replicable research - PI - Clean data set"
					"${data_fin}/Replicable research - Aggregated RA data set"
																			
	** CREATES:	  	"${output}/DIME - Benefit.png"
					"${output}/DIME - Constraints.png"
	
	** IDS VAR: 	key
	
	** WRITEN BY:   Luiza Cardoso de Andrade - @luizaandrade	

********************************************************************************
	Prepare data
*******************************************************************************/

	* Get PI data from merged data set
	use "${data_int}/Replicable research - Merged data set", clear
	
	* Keep only DIME PIs 
	keep if sample == 3
	
	* Keep variables of interest
	keep 		pi tranings_more_? constraints_?
	
	* Calculate aggregate percentages to merge with RA data set
	local 	nobs = _N					// Get number of PIs to calculate percentage
	
	* These are all dummy variables, so we'll add them up to calculate percentages
	collapse (sum) _all
	
	* Actually calculate them now
	foreach var of varlist tranings_more_? constraints_? {
		replace `var' = (`var'/`nobs')*100
	}
	
	* Merge to RA data set
	merge 1:1 pi 	using "${data_fin}/Replicable research - Aggregated RA data set" ///
					, ///
					keepusing(tranings_more* constraints_*) /// Keep variables of interest
					assert(1 2) /// They should not merge!
					nogen
	
	* Recode RAs to two to order thhe graph
	recode pi (0 = 2)

/*******************************************************************************
	Create graphs
*******************************************************************************/	

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
	lab def constraints		1 "No time to learn how to use this tool/method" ///
							2 "Does not know what are the best options" ///
							3 "Difficult for PIs to review the code" ///
							4 "Difficult to access training for PIs" ///
							5 "Difficult to access training for RAs" ///
							6 "High entry cost" ///
							7 "Low cost benefit" ///
							0 "Other"	
							
	local constraintstitle	DIME - Constraints
	
	* The actual graph
	foreach var in  tranings_more constraints {
	
		preserve
		
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
					legend(r(1) order(1 "DIME PI" 2 "DIME RA") placement(top)) ///
					ylabel(, valuelabel) ///
					ytit("%") ///
					bar(1, color("91 155 213")) ///
					bar(2, color("237 125 49"))
					
			* Save graphs
			gr export 	"${output}/``var'title'.png", width(5000) replace	
					
		restore
	}
	
******************************* End of do-file *********************************
