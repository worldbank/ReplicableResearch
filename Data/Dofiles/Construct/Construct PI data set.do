/*******************************************************************************
*							Replicable Research 							   *
********************************************************************************

	** PURPOSE:  	Create indicators for descriptive statistics
	
	** OUTLINE:							
	
	** REQUIRES:	"${data_fin}/Replicable research - PI - Clean data set"
																			
	** CREATES:	  	"${data_fin}/Replicable research - PI - Constructed data set"
	
	** IDS VAR: 	key
	
	** WRITEN BY:   Luiza Cardoso de Andrade - @luizaandrade	

*******************************************************************************/

	use "${data_fin}/Replicable research - PI - Clean data set", clear
	
	
/*******************************************************************************
	Create dummies for categories in factor variables
	(so it's easier to calculate descriptive stats)
*******************************************************************************/

	tab involvement, gen(involvement_)
	
	egen versions = anymatch(versions_*), v(1)
	gen abstraction = 1- abstraction_0
	gen pi_training = 1 - trainings_0
	gen pi_training_school = 1 - trainings_school_0
	gen benefit = 1 - tranings_more_0
	gen ra_training = 1 - trainings_ra_0
	
	
/*******************************************************************************
	Save constructed data set
*******************************************************************************/
	
	saveold "${data_fin}/Replicable research - PI - Constructed data set", v(13) replace
		
****************************** End of do-file *********************************
