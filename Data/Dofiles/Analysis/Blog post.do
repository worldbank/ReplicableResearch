

	use "C:\Users\wb501238\Documents\GitHub\ReplicableResearch\Data\DataSets\Final\Replicable research - PI - Constructed data set.dta", clear

	gr bar (percent) pi, over(prepared)
		
    collapse (sum) involvement_* tasks_* versions_* tasks versions code_review code_review_ext abstraction benefit *training* contraints_* ///
			  (count) pi

	foreach var of varlist involvement_* tasks_* versions_* tasks versions code_review code_review_ext abstraction benefit *training* contraints_* {
		replace `var' = (`var'/pi) * 100
	}
			  
	graph hbar versions tasks code_review code_review_ext abstraction benefit


	
    graph hbar  involvement_1 involvement_2 involvement_3 involvement_4 involvement_5, ///
				`colors' /// 
                xmlabel(1 "Other" 2 "Never" 3 "Sometimes" 4 "Often" 5 "Does most of the coding") ///
                bargap(2) ///
                graphregion(color(white)) ///
                legend(pos(6) cols(5) region(lcolor(white)) nobox symxsize(*.3)) ///
                title(How often does the Principal Investigator review the code?)
				
			
	forvalues cat = 1/7 {
        colorpalette viridis, n(`= 7+ 1') select(`= 1 + `cat'')
        local colors    "`colors' bar(`cat', fcolor(`r(p)') lcolor(`r(p)'))"
    }
	
	  graph hbar  tasks_1 tasks_2 tasks_3 tasks_4 tasks_5 tasks_6 tasks_0, ///
				`colors' blabel(total)
				
				
	