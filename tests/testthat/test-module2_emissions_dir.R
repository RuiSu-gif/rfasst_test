library(rfasst)
library(testthat)
library(magrittr)
library(rprojroot)

#-----------------------------
# Example using Module 2 with rescaled emission CSVs

test_that("module 2 reads emissions from csv files", {
  db_path <- paste0(rprojroot::find_root(rprojroot::is_testthat), "/testOutputs")
  emissions_dir <- paste0(rprojroot::find_root(rprojroot::is_testthat), "/output/m1")

  `%!in%` <- Negate(`%in%`)
  pm25_reg <- dplyr::bind_rows(
    m2_get_conc_pm25(
      db_path = db_path,
      query_path = "./inst/extdata",
      db_name = "database_basexdb_ref",
      prj_name = "scentest.dat",
      scen_name = "Reference",
      queries = "queries_rfasst.xml",
      final_db_year = 2030,
      emissions_dir = emissions_dir,
  ) %>% dplyr::filter(region %!in% c("RUE", "AIR", "SHIP"))

  regions_pm25 <- length(unique(pm25_reg$region))
  expectedResult <- length(unique(as.factor(rfasst::fasst_reg$fasst_region)))
  testthat::expect_equal(regions_pm25, expectedResult)
})
