/*******************************************************************************
*							Replicable Research 							   *
********************************************************************************

	** PURPOSE:  	Clean raw data
	
	** OUTLINE:		PART 1: Merge data sets
					PART 2: Clean up
					PART 3: Save merged data set
					PART 4: Save de-identified PI data set
	
	** REQUIRES:	"${data_raw}\data_policy_ext.dta"
					"${data_raw}\data_policy_wb_rg.dta"
					"${data_raw}\data_policy_wb_dime.dta"
					"${data_raw}\data_policy_wb_ra.dta"
					"${doc}\Labelling.xlsx"
																			
	** CREATES:	  	"${data_int}/Replicable research - Merged data set"
					"${data_fin}/Replicable research - PI - Clean data set"
							
	** IDS VAR: 	key
	
	** WRITEN BY:   Luiza Cardoso de Andrade - @luizaandrade	

********************************************************************************
	PART 1: Merge data sets
*******************************************************************************/

	* We have 4 files, one for each sample: non-WB PIs, DIME PIs, DECRG PIs and DIME RAs
	local 	sources "ext wb_rg wb_dime wb_ra"
	
	* Load each of these files, and create a sample variable to identify them, then
	* save in a tempfile to merge later
	forvalues source = 1/4 {
	
		local source_name : word `source' of `sources'
		
		use "${data_raw}\data_policy_`source_name'.dta", clear
		
		gen sample = `source'
		
		tempfile 	 `source_name'
		save 		``source_name''
	
		
	}
	
	gen pi = 0
	
	* Append all data sets
	append using `wb_dime'
	append using `ext'
	append using `wb_rg'
	
	replace pi = 1 if missing(pi)

/*******************************************************************************
	PART 2: Clean up
*******************************************************************************/

	* Apply labels
	iecodebook apply using "${doc}\Merged data set - Labelling.xlsx", drop
	
	* Fix format of calculate field
	destring _all, replace
	
	* Order
	order key pi sample respondent
	
/*******************************************************************************
	PART 3: Save merged data set
*******************************************************************************/
	
	* This data set includes potentially identifiable data, so will save in an
	* encrypted folder
	save "${data_int}/Replicable research - Merged data set", replace
	
****************************** End of do-file *********************************
