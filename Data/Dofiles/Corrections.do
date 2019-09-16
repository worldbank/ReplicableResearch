
	use "C:\Users\wb501238\Dropbox\WB\Transparency\Data\DataSets\Intermediate\Replicable research - Merged data set.dta", clear
	
	replace tasks_0 = 0 if inlist(tasks_other, ///
									"Sporadic conversations", ///
									"in person/ call", ///
									"face to face", ///
									"in person", ///
									"Skype", ///
									"dropbox", ///
									"Box, face-to-face meetings", ///
									"Common folder", ///
									"DROPBOX") ///
							| inlist(tasks_other, ///
									"Whatsapp", ///
									"Dropbox", ///
									"Discuss in face to face meetings.", ///
									"Discussions over the phone and in person.", ///
									"dropbox", ///
									"Face to face meetings, Skype, and direct explanations/notes in Stata codes", ///
									"Verbal communication with note taking") ///
							| inlist(tasks_other, ///
									"working side by side, sharing screens on skype etc.", ///
									"In person", ///
									"In-person meetings", ///
									"calls, face-to-face meetings", ///
									"skype, phone, whatsapp")
									
	replace tasks_other = lower(tasks_other)
	gen tasks_5 = regex(tasks_other, "git") | regex(tasks_other, "review")
	gen tasks_6 = regex(tasks_other, "dropbox") | regex(tasks_other, "paper")
	
	drop tasks_other
	replace tasks_0 = 0 if tasks_5 == 1 | tasks_6 == 1
	egen tasks = anymatch(tasks_*), v(1)
	replace tasks_p_other_c = 0 if tasks_0 == 0 & tasks_5 == 0 & tasks_6 == 0
	
	lab def protocols 0 "There are none", modify
	drop protocols_other
	
	replace versions_0 = 0 if inlist(versions_other, ///
									 "No well defined system", /// None
									 "Dropbox has version control now automatically", /// Dropbox has very limited version control, with very different results from the other methods listed
									 "We dont use version control")
									 
	gen versions_4 = inlist(versions_other, "Archiving old do files when a revised one has been produced", "Separate folders")
	lab var versions_4 "Version control tool: separate folders"
	drop versions_other
	
	replace versions_p_other_c = . if versions_0 == 0
	gen versions_p_folder_c = versions_p_other_c if versions_4 == 1
	
	egen version_control = anymatch(versions_*), v(1)
	lab var version_control "Uses version control"
	
	replace softwares_0 = 0 if softwares_other == "Dropbox"
	drop softwares_other
	egen softwares = anymatch(softwares_*), v(1)
	
	replace code_review_phase_3 = 1 if code_review_phase_other == "At completion of each task"
	replace code_review_phase_5 = 1 if code_review_phase_other == "At request of RAs and collaborators, or when I think it is necessary"
	lab var code_review_phase_5 "Interval code review phase: As per PI/RA request"
	
	replace code_review_phase_0 = 0 if inlist(code_review_phase_other, ///
											  "At request of RAs and collaborators, or when I think it is necessary", ///
											  "At completion of each task")
	
	replace code_review_ext_phase_4 = 1 if code_review_ext_phase_0 == 1
	drop code_review_ext_phase_0 code_review_ext_phase_other
	
	gen constraints_8 = inlist(constraints_other, ///
							"PIs tend to not prioritize time to data quality. It is always on their agenda but has the lowest priority and never reaches the top of the pile.", ///
							"No internal or external staff resources for code review", ///
							"Project funding from donors is not sufficient to support training for me and my RAs") | ///
					  regex(comments, "ressources") | ///
					  regex(comments, "99.9")
							
	gen constraints_9 = inlist(constraints_other, ///
								"Psychological resistance from RAs and other CI", ///
								"Coordination issues with other PIs" , ///
								"Want solutions that work well offline when travelling; coordination issues among many co-authors makes take-up of any new program difficult since you need everyone to buy in.") | ///
						regex(comments, "co-authors")
								
	replace constraints_2 = 1 if constraints_other == "Want solutions that work well offline when travelling; coordination issues among many co-authors makes take-up of any new program difficult since you need everyone to buy in."
	replace constraints_2 = 1 if constraints_other == "Hard to establish if new practices or softwares (e.g. Github) are worth the cost. Trying not to be early adopter to see how it works out for other researchers and for what type of projects and team structure each  practice is most appropriate."
	
	drop constraints_other constraints_0
	
	drop code_review_phase_other
	
	 save "C:\Users\wb501238\Dropbox\WB\Transparency\Data\DataSets\Intermediate\Replicable research - Corrected data set.dta", replace
	 
	 	* Potentially identifying variables
	drop 	sample respondent *other comments respondent 
	
	foreach var of varlist years coauthors ras_all ras_pp projects {
		replace `var' = . if pi == 0
	}
	
	saveold "${data_fin}/Replicable research - Clean data set", replace v(13)
