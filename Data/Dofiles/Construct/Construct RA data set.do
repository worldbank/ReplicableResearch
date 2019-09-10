/*******************************************************************************
*							Replicable Research 							   *
********************************************************************************

	** PURPOSE:  	Aggregate RA data
	
	** OUTLINE:							
	
	** REQUIRES:	"${data_int}/Replicable research - Merged data set"
					"${doc}\RA data set - Labelling.xlsx"
																			
	** CREATES:	  	"${data_fin}/Replicable research - Aggregated RA data set"
	
	** IDS VAR: 	key
	
	** WRITEN BY:   Luiza Cardoso de Andrade - @luizaandrade	

********************************************************************************
	Prepare data
*******************************************************************************/

	* Load data set with all surveys
	use "${data_int}/Replicable research - Merged data set", clear
	
	* Keep only RA data
	keep if pi == 0 
	
	* Keep only variables present in the RA survey
	dropmiss, force
	
	* Count number of observations so we can calculate percentages
	local nobs = _N

/*******************************************************************************
	Turn categorical variables into dummies so they can be aggregated
*******************************************************************************/

	local categoricalvars	directories directories_create protocols ///
							code_review involvement prepared time ///
							projects ras_all  coauthors code_review_ext ///
							years ras_pp
							
	foreach var of local categoricalvars 	 {
							
								
		qui tab `var', gen(`var'_)
								
	}

/*******************************************************************************
	Drop strings as they cannot be aggregated
*******************************************************************************/

	drop 	versions_other softwares_other code_review_phase_other ///
			code_review_ext_phase_other constraints_other comments key ///
			`categoricalvars'

/*******************************************************************************
	Calculate percentages
*******************************************************************************/

	* Add dummies to get count of "yes"
	collapse 	(sum) _all
	
	* Turn it into percentages
	foreach var of varlist _all {
		replace `var' = (`var'/`nobs')*100
	}
	
/*******************************************************************************
	Clean-up and save
*******************************************************************************/
	
	iecodebook apply using "${doc}\RA data set - Labelling.xlsx"
	
	saveold "${data_fin}/Replicable research - Aggregated RA data set", replace v(13)

***************************** End of do-file ************************************
