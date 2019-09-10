/*******************************************************************************
*							Replicable Research 							   *
********************************************************************************

	** PURPOSE:  	Descriptives of PI survey 
	
	** OUTLINE:							
	
	** REQUIRES:	"${data_fin}/Replicable research - PI - Clean data set"
																			
	** CREATES:	  	"${output}/Internal code review.png"
					"${output}/External code review.png"
					"${output}/Directories structure.png"
					"${output}/Version control.png"
					"${output}/Task management tool.png"
					"${output}/Process for improving code.png"
					"${output}/Benefit.png"
					"${output}/Constraints to adoption.png"
					"${output}/PI trainings.png"
					"${output}/RA trainings.png"
	
	** IDS VAR: 	key
	
	** WRITEN BY:   Luiza Cardoso de Andrade - @luizaandrade	

*******************************************************************************/	
	
	use "${data_fin}/Replicable research - PI - Clean data set", clear
	
/*******************************************************************************
	Select one variables: just sum the percentage of PIs
*******************************************************************************/	

	* Define names to save graphs
	local code_review_title			Internal code review
	local code_review_ext_title		External code review
	local directories_title			Directories structure
	
	* Loops over variables
	foreach var in code_review code_review_ext directories {
	
		preserve
			
			* Calculate percent of PIS that addopt tools
			collapse (percent) pi if !missing(`var'), by(`var')
			
			
			* Round number
			replace pi = round(pi, 1)
			
			* Sort so graph is more intuitive
			sort 	pi
			
			* Graph in sorter order
			gen  	order = _N - _n
			
			* With original labels
			labmask order, values(`var') decode
			
			* Create graph
			gr hbar 	pi, ///
						over(order) ///
						${bar_graph} ///
						ytitle(Percent of principal investigators)
					
			* Save graph
			gr export 	"${output}/``var'_title'.png", width(5000) replace			

		restore
	}
	
/*******************************************************************************
	Select multiple variables: Also need to rehspae and label the values
*******************************************************************************/	
	
	* SLIDE 8: Version control tools
	lab def versions 	3 "Version control software" ///
						1 `"Version identifiers ("v1", "v2")"' ///
						2 "Date and/or initials"
	
	local versionstitle Version control					
	local versionscond	"if tool != 0"	// Drop "None"
	
	* SLIDE 9: Task management tools	
	lab def tasks	 	1 "E-mail" ///
						2 "Google docs" ///
						3 "Asana" ///
						4 "Slack" ///
						0 "Other"
	local taskstitle	Task management tool
									
	* SLIDE 10: Abstraction
	local abstractiontitle	Process for improving code
	local abstractionlab 	, relabel(2 `""Yes, through internal" "training/review""' ///
									  3 `""Yes, through external" "training/review""' ///
									  1 `""Peer review/collaboration encourages" "but no systematic process in place""' ///
									  5 "No" ///
									  4 "Do not know")
						
	* SLIDE 12: What tools could the team benefit from
	lab def tranings_more	1 "Version control software" ///
							2 "Data managements tools" ///
							3 "Code automation" ///
							4 "Coding practices	" ///
							5 "Internal code review" ///
							6 "External code review" ///
							0 "None of the above"
	local tranings_moretitle Benefit
							
	* SLIDE 12: Constraints to adoption
	lab def constraints		1 "No time to learn how to use this tool/method" ///
							2 "Does not know what are the best options" ///
							3 "Difficult for PIs to review the code" ///
							4 "Difficult to access trainings for PIs" ///
							5 "Difficult to access trainings for RAs" ///
							6 "Entry cost is too high for the team" ///
							7 "Cost benefit is low"
	local constraintstitle Constraints to adoption
	
	* SLIDE 14: Trainings attended
	label def 	trainings 	1 "Version control software" ///
							2 "Data managements tools" ///
							3 "Code automation" ///
							4 "Coding practices	" ///
							0 "None of the above"
							
	local 		trainingstitle		PI trainings
	label copy 	trainings	 		trainings_ra
	lab   def	trainings_ra		5 "Does not know", add
	local 		trainings_ratitle	RA trainings
	
	* Create graphs
	foreach method in tasks versions abstraction tranings_more constraints trainings trainings_ra {
	
		preserve
		
			* Calculate proportion of users
			collapse 	(mean) 	`method'_?, by(pi)
			
			* Make long per option to make graphing easier
			reshape 	long 	`method'_,  i(pi) j(tool)
			
			* Turn proportion to percent
			replace `method'_ = `method'_ * 100
			replace `method'_	 = round(`method'_	,10)
			
			* Sort from highest to lowest to make graph more intuitive
			sort 	`method'_	
			gen 	order = _N - _n + 1
			replace order = _N + 1 		 if tool == 0
			
			* Keep original label
			cap lab val 			  tool `method'
			cap labmask order, values(tool) decode

			* Create graphs
			gr hbar 	`method'_ ``method'cond', ///
						over(order ``method'lab') ///
						${bar_graph} ///
						ytitle(Percent of principal investigators)
						
			* Save graphs
			gr export 	"${output}/``method'title'.png", width(5000) replace	
						
		restore
	}
	
***************************** End of do-file ***********************************
