# Overview

This repository contains the data and code for the presentation by Guadalupe Bedoya on Practical Steps to Credibility and Transparency in Research: Who Should Do What? during the [Research Symposium on Reproducibility, Transparency and Credibility](https://blogs.worldbank.org/impactevaluations/how-reproducible-research) at the World Bank on September 10, 2019.

The team includes:
- Guadalupe Bedoya         [`@gbedoyaWB`]     - Economist, DIME 
- Camila Ayala             [`@mcayala`]       - Research Assistant, DIME 
- Luiza Cardoso de Andrade [`@luizaandrade`]  - Data Coordinator, DIME
- Amy Dolinger             [`@adolinger`]     - Research Analyst, DIME 
- Thomas Escande           [`@escandethomas`] - Research Analyst, DIME 


# Documentation

The questionnaires used during this survey are available in the [`Questionnaires`](https://github.com/worldbank/ReplicableResearch/tree/master/Questionnaires) folder in this page. More documentation can be found in this repository's [`Wiki`](https://github.com/worldbank/ReplicableResearch/wiki). Navigate to it using the repository menu at the top of the page.

# Code

Code and data to replicate the results presented can be found in the [`Data`](https://github.com/worldbank/ReplicableResearch/tree/master/Data) folder. The code runs in Stata, and should be compatible with Stata versions 13 and up (but it was only tested in StataMP 15).

To run it, use the [`MASTER`](https://github.com/worldbank/ReplicableResearch/blob/master/Data/Dofiles/MASTER.do) do-file, by changing only folder paths on top of the do-file, and selecting sections to run. The [`Cleaning`](https://github.com/worldbank/ReplicableResearch/blob/master/Data/Dofiles/Cleaning.do) and [`Construct RA data set`](https://github.com/worldbank/ReplicableResearch/blob/master/Data/Dofiles/Construct/Construct%20RA%20data%20set.do) do-files will only run for people who have access to the encrypted data, containing identified information

# Contribution

For questions, requests and suggestions, please create an [`Issue`](https://github.com/worldbank/ReplicableResearch/issues) in this repository.
