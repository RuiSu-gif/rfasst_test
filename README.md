[![build](https://github.com/JGCRI/rfasst/actions/workflows/build.yml/badge.svg)](https://github.com/JGCRI/rfasst/actions/workflows/build.yml)
[![docs](https://github.com/JGCRI/rfasst/actions/workflows/pkgdown.yaml/badge.svg?branch=main)](https://github.com/JGCRI/rfasst/actions/workflows/pkgdown.yaml)
[![codecov](https://codecov.io/gh/JGCRI/rfasst/branch/main/graph/badge.svg?token=2IBODRZKVF)](https://codecov.io/gh/JGCRI/rfasst)
[![test_coverage](https://github.com/JGCRI/rfasst/actions/workflows/test_coverage.yml/badge.svg)](https://github.com/JGCRI/rfasst/actions/workflows/test_coverage.yml)
[![DOI](https://zenodo.org/badge/344924589.svg)](https://zenodo.org/badge/latestdoi/344924589)
[![DOI](https://joss.theoj.org/papers/10.21105/joss.03820/status.svg)](https://doi.org/10.21105/joss.03820)


<!-- ------------------------>
<!-- ------------------------>
# <a name="Contents"></a>Contents
<!-- ------------------------>
<!-- ------------------------>

- [Key Links](#KeyLinks)
- [Introduction](#Introduction)
- [Citation](#Citation)
- [Installation Guide](#InstallGuide)
- [How-to guide](#howto) 
- [Publications](#Publications)

<!-- ------------------------>
<!-- ------------------------>
# <a name="KeyLinks"></a>Key Links
<!-- ------------------------>
<!-- ------------------------>

[Back to Contents](#Contents)

- Github: https://github.com/JGCRI/rfasst
- Webpage: https://jgcri.github.io/rfasst/

<!-- ------------------------>
<!-- ------------------------>
# <a name="Introduction"></a>Introduction
<!-- ------------------------>
<!-- ------------------------>

[Back to Contents](#Contents)

`rfasst` reports a consistent range of adverse health and agricultural effects attributable to air pollution for any scenario run by the Global Change Analysis Model ([GCAM](http://www.globalchange.umd.edu/gcam/)), by replicating the calculations of the air quality reduced-form model [TM5-FASST]( https://ec.europa.eu/jrc/en/publication/tm5-fasst-global-atmospheric-source-receptor-model-rapid-impact-analysis-emission-changes-air).


<!-- ------------------------>
<!-- ------------------------>
# <a name="Citation"></a>Citation
<!-- ------------------------>
<!-- ------------------------>

[Back to Contents](#Contents)

Sampedro, J., Khan, Z., Vernon, C.R., Smith, S.J., Waldhoff, S. and Van Dingenen, R., 2022. rfasst: An R tool to estimate air pollution impacts on health and agriculture. Journal of Open Source Software, 7(69), p.3820.


<!-- ------------------------>
<!-- ------------------------>
# <a name="InstallGuide"></a>Installation Guide
<!-- ------------------------>
<!-- ------------------------>

[Back to Contents](#Contents)

1. Download and install:
    - R (https://www.r-project.org/)
    - R studio (https://www.rstudio.com/)  
    - (For cloning the repo) Git (https://git-scm.com/downloads) 
    
    
2. Open R studio:

```r
install.packages("devtools")
devtools::install_github("JGCRI/rfasst")
```

(Optional) 

To clone the repository to the local machine: Git bash in the working directory (right click "Git Bash Here") -> In the Git console type:  

```r
git clone https://github.com/JGCRI/rfasst.git
```

Then, open the Rproject (rfasst.Rproj): In the Rstudio menu, click "Build -> Install and restart" (Ctrl+Shift+B)
  

<!-- ------------------------>
<!-- ------------------------>
# <a name="keyfunctions"></a> How to guides
<!-- ------------------------>
<!-- ------------------------>

[Back to Contents](#Contents)

The package consists of a set of functions divided in four different modules:
- Module 1. Emissions re-scaling: Process emissions by GCAM-region and re-scale them to TM5-FASST regions, and make some additional pollutant-related adjustments. More details in the [Module1 emissions](https://jgcri.github.io/rfasst/articles/Module1_emissions.html) page. 
- Module 2. Concentration: Estimate fine particulate matter (PM2.5) and ozone (O3) concentration levels (measured by different indicators) for each region. More details in the [Module2 concentration](https://jgcri.github.io/rfasst/articles/Module2_concentration.html) page. 
- Module 3. Health: Report adverse health effects attributable to exposure to fine particulate matter (PM2.5) and ozone (O3; M6M). More details in the [Module3 health](https://jgcri.github.io/rfasst/articles/Module3_health.html) page. 
- Module 4. Agriculture: Estimate adverse agricultural impacts associated to ozone exposure, including relative yield losses (RYLs) and production and revenue losses. More details in the [Module4 agriculture](https://jgcri.github.io/rfasst/articles/Module4_agriculture.html) page. 

## Using Module 2 with CSV emissions

Module 2 functions now accept an optional `emissions_dir` argument. If you supply the path to the folder containing the rescaled emission CSVs written by Module 1 (`m1_emissions_rescale(..., saveOutput = TRUE)`), the functions will read these files directly instead of querying the GCAM database.

```r
library(rfasst)

db_path <- "path_to/testOutputs"
em_dir  <- "path_to/output/m1"   # contains Reference_2015.csv, etc.

em_data <- lapply(c(2015, 2020), function(yr) {
  read.csv(file.path(em_dir, paste0("Reference_", yr, ".csv"))) %>%
    dplyr::mutate(year = yr) %>%
    tidyr::gather(pollutant, value, -COUNTRY, -year) %>%
    dplyr::rename(region = COUNTRY)
})

pm25 <- m2_get_conc_pm25(
  db_path       = db_path,
  query_path    = "./inst/extdata",
  db_name       = "database_basexdb_ref",
  prj_name      = "scentest.dat",
  scen_name     = "Reference",
  queries       = "queries_rfasst.xml",
  final_db_year = 2030,
  emissions_data = em_data,
  saveOutput    = FALSE
)
```

CSV files must follow the naming pattern `<SCENARIO>_<YEAR>.csv` and reside in the directory given by `emissions_dir`.


In addition, the package includes some default input files (.Rda), that are read by the different functions. These can be changed by the user. Some of these constants include:
- GCAM crop categories to be included in the analysis
- Shares to allocate emissions between Russia Eastern (RUE) and Russia Western (RUS)
- Coefficients and/or counterfactual values for exposure-response functions applied to estimate adverse health and agricultural impacts.
- Baseline moratlity rates.
- Median values for the health impact economic assessment (Value of Statistical Life)
- Other


<!-- ------------------------>
<!-- ------------------------>
# <a name="Publications"></a>Publications
<!-- ------------------------>
<!-- ------------------------>

[Back to Contents](#Contents)

Previous to the development of this package, different studies have combined the use of GCAM and TM5-FASST:

- Sampedro, J., Smith, S.J., Arto, I., González-Eguino, M., Markandya, A., Mulvaney, K.M., Pizarro-Irizar, C. and Van Dingenen, R., 2020. Health co-benefits and mitigation costs as per the Paris Agreement under different technological pathways for energy supply. Environment international, 136, p.105513.

- Markandya, A., Sampedro, J., Smith, S.J., Van Dingenen, R., Pizarro-Irizar, C., Arto, I. and González-Eguino, M., 2018. Health co-benefits from air pollution and mitigation costs of the Paris Agreement: a modelling study. The Lancet Planetary Health, 2(3), pp.e126-e133.

- Sampedro, J., Waldhoff, S.T., Van de Ven, D.J., Pardo, G., Van Dingenen, R., Arto, I., Del Prado, A. and Sanz, M.J., 2020. Future impacts of ozone driven damages on agricultural systems. Atmospheric Environment, 231, p.117538.
