

/*******************************************************************************
								SET INPUTS HERE
*******************************************************************************/	
	
	local version	13		// Set Stata version
	local packages	0		// 1 to install required packages -- only needs to run 1 in each machine
	local clean		0 		// 1 to create clean data sets
	local construct	0 		// 1 to create final data sets
	local numbers	0		// 1 to print the numbers in the presentation
	local graphs	1		// 1 to create final outputs
	
	pause 			off 	// on to not pause when creating number for presentation
	
	ieboilstart, v(`version')
	`r(version)'
	
	global github 			"ADD/FOLDER/PATH"
	global encrypted 		"ADD/FOLDER/PATH"

/*******************************************************************************
								Set directories
*******************************************************************************/	

	global data 			"${github}/Data"
	global data_raw			"${encrypted}/Raw/2019-09-09"
	global data_int			"${encrypted}/Intermediate"
	global data_fin			"${data}/DataSets/Final"	
	global doc				"${data}/Documentation"
	global do 				"${data}/Dofiles"
	global output			"${data}/Output"
	

/*******************************************************************************
							   Set globals
*******************************************************************************/	

	/* Graph formatting
	global bar_graph		blabel(total, format(%9.0f)) ///
							graphregion(color(white)) ///
							yscale(off) ///
							ylab(, nogrid) ///
							bar(1, color("91 155 213"))
	
	*/
/*******************************************************************************
							   Install packages
*******************************************************************************/	
	
	if `packages' {
		
		ssc install sxpose
		ssc install ietoolkit
		ssc install labmask
		
	}

	
/*******************************************************************************
							    Run do-files
*******************************************************************************/
	
/*******************************************************************************
							Clean raw data
--------------------------------------------------------------------------------
	
	 REQUIRES:	"${data_raw}\data_policy_ext.dta"
				"${data_raw}\data_policy_wb_rg.dta"
				"${data_raw}\data_policy_wb_dime.dta"
				"${data_raw}\data_policy_wb_ra.dta"
				"${doc}\Labelling.xlsx"
																			
	 CREATES:	"${data_int}/Replicable research - Merged data set"
				"${data_fin}/Replicable research - PI - Clean data set"
					
*******************************************************************************/
	
	if `clean' 		do "${do}/Cleaning.do"
	
/******************************************************************************
					Create indicators for descriptives statistics
--------------------------------------------------------------------------------
	
	 REQUIRES:	"${data_fin}/Replicable research - PI - Clean data set"
																			
	 CREATES:	"${data_fin}/Replicable research - PI - Constructed data set"
					
*******************************************************************************/

	if `construct'	do "${do}/Construct/Construct PI data set.do"

/*******************************************************************************
						Recreate numbers in slides
--------------------------------------------------------------------------------
	
	 REQUIRES:	"${data_fin}/Replicable research - PI - Constructed data set"
																			
	 CREATES:	
					
*******************************************************************************/

	if `numbers'	do "${do}/Analysis/Numbers for slides.do"
	
/*******************************************************************************
						Descriptives of PI survey 							   
--------------------------------------------------------------------------------

	** REQUIRES:	"${data_fin}/Replicable research - PI - Clean data set"
																			
	** CREATES:	  	"${output}/Internal code review.png"
					"${output}/External code review.png"
					"${output}/Directories structure.png"
					"${output}/Version control.png"
					"${output}/Task management tool.png"
					"${output}/Process for improving code.png"
					"${output}/Benefit.png"
					"${output}/Constraints to adoption.png"

*******************************************************************************/
	
	if `graphs'	do "${do}/Analysis/PI graphs.do"
	
****************************** End of do-file **********************************
