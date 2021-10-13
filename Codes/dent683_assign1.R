#R script for Assignment 1

#The R script will be saved in the Codes sub-folder of the local repo
#The excel files were saved to the Data sub-folder of the local repo


#preparatory step: loading the libraries that I will use
library(readxl)
library(tidyverse)
library(here)


#task 6.1: importing each sheet of the excel files as separate data set
oh2012 <- read_xlsx(path = here("Data","nhanes_ohx_12_18.xlsx"),
                    sheet = "oh2012")
oh2014 <- read_xlsx(path = here("Data","nhanes_ohx_12_18.xlsx"),
                    sheet = "oh2014")
oh2016 <- read_xlsx(path = here("Data","nhanes_ohx_12_18.xlsx"),
                    sheet = "oh2016")
oh2018 <- read_xlsx(path = here("Data","nhanes_ohx_12_18.xlsx"),
                    sheet = "oh2016")
demo2012 <- read_xlsx(path = here("Data","nhanes_demo_12_18.xlsx"),
                    sheet = "demo2012")
demo2014 <- read_xlsx(path = here("Data","nhanes_demo_12_18.xlsx"),
                    sheet = "demo2014")
demo2016 <- read_xlsx(path = here("Data","nhanes_demo_12_18.xlsx"),
                    sheet = "demo2016")
demo2018 <- read_xlsx(path = here("Data","nhanes_demo_12_18.xlsx"),
                    sheet = "demo2018")


#commit+push Data+Codes


