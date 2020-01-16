
gr drop _all

		use "C:\Users\wb501238\Documents\GitHub\ReplicableResearch\Data\DataSets\Final\Replicable research - PI - Constructed data set.dta", clear

	forvalues cat = 1/4 {
        colorpalette viridis, n(`= 4 + 1') select(`= 1 + `cat'')
        local color`cat'    "`r(p)'"
    }
	
	
	gr hbar (percent) pi, over(prepared, relabel(1 "1 - Very unprepared" 5 "5 - Very prepared")) bar(1, fcolor(`color1') lcolor(`color1') ) /// 
                blabel(total, format(%9.1f)) bargap(2) ///
                graphregion(color(white)) ///
				ytitle(Percent of PIs surveyed) ///
                title("Self-reported preparedness" "to comply with AEA requirements") ///
				name(preparedness)
	gr export "${output}/Blog post/prepared.png", width(5000) replace
			
    collapse (sum) involvement_* tasks_? versions_* tasks versions code_review code_review_ext constraints abstraction benefit *training* constraints_* ///
			  (count) pi

	foreach var of varlist involvement_* tasks_* versions_* tasks versions code_review code_review_ext constraints abstraction benefit *training* constraints_* {
		replace `var' = (`var'/pi) * 100
	}
			
				foreach var of varlist involvement_1-constraints_8 {
		rename `var' pct`var'
	}
	
	reshape long pct, i(pi) j(variable) string
	
	sort pct
	gen order = _n


	graph hbar	pct ///
				if inlist(variable, "abstraction", "code_review", "code_review_ext", "tasks", "versions"), ///
				over(order, relabel(5 "Internal code review" ///
									4 `""Some version" "control process""' ///
									3 `""Task management" "(other than e-mail)""' ///
									2 `""Systematic process" "for improving code""' ///
									1 "External code review")) ///
				blabel(total, format(%9.1f)) bargap(2) ///
                graphregion(color(white)) ///
				title(Pratices adopted) ///
				ytitle(Percent of PIs surveyed) ///
				bar(1, fcolor(`color3') lcolor(`color3')) ///
				name(adoption)
		gr export "${output}/Blog post/tools.png", width(5000) replace
	
	graph hbar	pct ///
				if inlist(variable, "benefit", "constraints", "pi_training", "ra_training"), ///
				over(order, relabel(3 `""Work would benefit" "from adoption""' ///
									4 `""Faces constraints" "to adoption""' ///
									1 `"Received training"' ///
									2 `"RAs received training"')) ///
				blabel(total, format(%9.1f)) bargap(2) ///
                graphregion(color(white)) ///
				title("Use of reproducibility tools") ///
				ytitle(Percent of PIs surveyed) ///
				bar(1, fcolor(`color2') lcolor(`color2')) ///
				name(training)
	gr export "${output}/Blog post/training.png", width(5000) replace			
	
    graph hbar  pct if regex(variable, "involvement"), ///
				over(order, relabel(1 "Other" ///
									2 `"Never"' ///
									3 `"Sometimes"' ///
									4 `"Often"' ///
									5 `""Does most of" "the coding""')) ///
				bar(1,fcolor(`color2') lcolor(`color2') ) /// 
                blabel(total, format(%9.1f)) bargap(2) ///
                graphregion(color(white)) ///
				ytitle(Percent of Principal Investigators surveyed) ///
                title("How often does the" "Principal Investigator review the code?") ///
				name(involvement)
				
	gr export "${output}/Blog post/involvement.png", width(5000) replace	
				
	graph hbar  pct if regex(variable, "tasks_"), ///
				over(order, relabel(1 "Other" ///
									2 `"Asana"' ///
									3 `"GitHub issues"' ///
									4 `"Slack"' ///
									5 `"Google documents"' ///
									6 "DropBox/DropBox paper" ///
									7 "Email")) ///
				bar(1,fcolor(`color3') lcolor(`color3') ) /// 
                blabel(total, format(%9.1f)) bargap(2) ///
                graphregion(color(white)) ///
				ytitle(Percent of Principal Investigators surveyed) ///
                title("Task management/documentation tools used")
	gr export "${output}/Blog post/tasks.png", width(5000) replace	
	
	graph hbar  pct if regex(variable, "constraints_"), ///
				over(order, relabel(1 `""Coordination within" "research team""' ///
									2 `""Difficult for PI to" "review work""' ///
									3 `"Lack of training for RAs"' ///
									4 `"Lack of training for PIs"' ///
									5 `"Low cost-benefit"' ///
									6 `""Does not know what" "are the best options""' ///
									7 `""High entry cost/lack of" "resources""' ///
									8 "Lack of time")) ///
				bar(1,fcolor(`color4') lcolor(`color4') ) /// 
                blabel(total, format(%9.1f)) bargap(2) ///
                graphregion(color(white)) ///
				ytitle(Percent of PIs surveyed) ///
                title("Constraints to adoption") ///
				name(constraints)
	gr export "${output}/Blog post/constraints.png", width(5000) replace	
	
	graph hbar  pct if inlist(variable, "versions_1", "versions_2", "versions_3", "versions_0", "versions_4"), ///
				over(order, relabel(1 `"Separate folders"' ///
									2 `"Other"' ///
									3 `""Version-control" "software""' ///
									4 `""Version identifier" "('v1', 'v2')""' ///
									5 `""Initials and dates" "on file names""')) ///
				bar(1, fcolor(`color5') lcolor(`color5') ) /// 
                blabel(total, format(%9.1f)) bargap(2) ///
                graphregion(color(white)) ///
				ytitle(Percent of Principal Investigators surveyed) ///
                title("Version control methods used")
		gr export "${output}/Blog post/version.png", width(5000) replace			
				
		
	gr combine preparedness training adoption constraints , graphregion(color(white)) cols(2) iscale(*.65) xcommon
	
	gr export "${output}/Blog post/panel.png", width(5000) replace	
