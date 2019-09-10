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
	
	
/*******************************************************************************
	Save constructed data set
*******************************************************************************/
	
	saveold "${data_fin}/Replicable research - PI - Constructed data set", v(13) replace
		
****************************** End of do-file *********************************
