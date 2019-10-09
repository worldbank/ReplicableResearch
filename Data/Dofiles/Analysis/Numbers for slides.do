/*******************************************************************************
*							Replicable Research 							   *
********************************************************************************

	** PURPOSE:  	Recreate numbers in the presentation
	
	** OUTLINE:		SLIDE 5:  PI profile
					SLIDE 8:  Share of GitHub users 
					SLIDE 6:  Preparedness
					SLIDE 13: Availability of training material
					
	
	** REQUIRES:	"${data_fin}/Replicable research - PI - Constructed data set"
																			
	** CREATES:	  	
	
	** IDS VAR: 	key
	
	** WRITEN BY:   Luiza Cardoso de Andrade - @luizaandrade	

*******************************************************************************/	
		
/*******************************************************************************
	SLIDE 5: PI profile
*******************************************************************************/

	use "${data_fin}/Replicable research - PI - Constructed data set", clear
	
	preserve
	
		collapse (mean) 	years coauthors ras_all ras_pp projects prepared ///
							involvement_2 - involvement_5 ///
				 (count)	pi

		br
		pause
		
	restore		 

/*******************************************************************************
	SLIDE 8: Share of GitHub users 
*******************************************************************************/		 
	
	sum softwares_1
	
	pause
	
/*******************************************************************************
	SLIDE 6: Preparedness
*******************************************************************************/		 
	
	sum prepared
	
	pause
	

/*******************************************************************************
	SLIDE 13: Availability of training material
*******************************************************************************/		 

	foreach var of varlist 	trainings_git trainings_structure trainings_auto ///
							trainings_code {
	
		sum `var'
		
	}
	
	pause
	
	
****************************** End of do-file *********************************
