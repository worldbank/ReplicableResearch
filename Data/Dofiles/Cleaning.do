
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


	* Apply labels
	iecodebook apply using "${doc}\Merged data set - Labelling.xlsx", drop
	
	* Fix format of calculate field
	destring _all, replace
	
	* Order
	order key pi sample respondent
	
	
	* This data set includes potentially identifiable data, so will save in an
	* encrypted folder
	save "${data_int}/Replicable research - Merged data set", replace


	* Potentially identifying variables
	drop 	sample respondent *other comments 
	
	* Drop RAs because they are few and come from a single institution
	drop if pi != 1
	
	saveold "${data_fin}/Replicable research - PI - Clean data set", replace v(13)
	
