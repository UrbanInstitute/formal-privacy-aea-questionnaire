# Formal Privacy AEA Questionnaire

### Andres F. Barrientos, Claire Bowen, Joshua Snoke, and Aaron R. Williams

This repository contains results from a questionnaire about formal privacy distributed to American Economic Association members. 

The original data are not available for re-analysis but all code is available for examination. 

# File Description

## `analysis/`

* `analysis/01_analysis-stock-unweighted.qmd` -- Simple unweighted tabulations for all of the questions in the questionnaire.
* `analysis/01_analysis-stock-weighted.qmd` -- Simple weighted tabulations for all of the questions in the questionnaire.
* `analysis/02_analysis-text.qmd` -- Text analysis of responses to the two questions with open responses.
* `analysis/03_generate_weights.qmd` -- Generates sample weights using calibration to align sample statistics to control totals generated from a much larger collection of information about AEA members. 
* `analysis/04_analysis-paper-unweighted.qmd` -- Unweighted tabulations in the paper for all of the questions in the questionnaire.
* `analysis/04_analysis-paper-weighted.qmd` -- Weighted tabulations in the paper for all of the questions in the questionnaire.

## `data/`

* `aea_analysis_weighted.csv` -- Confidential questionnaire responses reweighted to hit control targets. 
* `aea_survey_results.xlsx` -- Confidential questionnaire responses. 
* `highest_grade_detailed.csv` -- Administrative education data about AEA members. 
* `highest_degree_summarized.csv` -- Administrative summarized education data about AEA members. 
* `memberData.xlsx` -- Administrative data about AEA members. 

# License

GNU GPL-v3

# Contact

Please contact [Aaron R. Williams](awilliams@urban.org) with questions. 
