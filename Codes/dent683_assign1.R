#R script for Assignment 1

#The R script will be saved in the Codes sub-folder of the local repo
#The excel files were saved to the Data sub-folder of the local repo


#preparatory step: loading the libraries that I will use
library(readxl)
library(tidyverse)
library(here)


#task 6.1: importing each sheet of the excel files as separate data-set
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


####################

#task 6.2:creating a single data set that includes SEQ and variables ending with CTC from the ohx data-sets

#before creating a single data set, checking that the variables' names are identical between the 4 oh data-set
identical(names(oh2012), names(oh2014))
identical(names(oh2012), names(oh2016))
identical(names(oh2012), names(oh2018))
#results: identical names between oh2012 and oh2014, but not when compared to oh2016 and oh2018

#now I want to check what are the different variables?
oh2012vsoh2016 <- setdiff(names(oh2012), names(oh2016))
oh2012vsoh2018 <- setdiff(names(oh2012), names(oh2018))
identical(oh2012vsoh2016,oh2012vsoh2018)
#results: identical (TRUE)

#so the differences between oh2012 (and oh2014 because they are identical) and oh2016 and oh2018 are the same
#now I will check if the names of oh2016 and oh 2018 are identical
identical (names(oh2016), names(oh2018))
#results: identical (TRUE)

#So, in sum: the variables of oh2012 are the same in oh2014
#            the variables of oh2016 are the same in oh2018
#            the differences between the sets are the same

#now I want to know how many variables are the same?
intersect(names(oh2012), names(oh2016)) %>% length()
#So, all the 110 variables in oh2012 (and oh2014 obviously) are included in oh2016 (and oh2018 obviously)

#now I want to know if the variables of interest are coded the same way in all the sets before merging
oh2012 %>% select(ends_with("CTC")) 
oh2014 %>% select(ends_with("CTC"))
oh2016 %>% select(ends_with("CTC"))
oh2018 %>% select(ends_with("CTC"))
#in a randomly check, they seem to be coded the same, 
#and there are 28 variables ending with CTC in the 4 data-sets

#now I will select the variables of interest only for those who completed oral examinations
#this will be saved in new objects
oh2012_int <- oh2012 %>%filter(OHDDESTS==1,OHDEXSTS==1)%>%
  select("SEQN", ends_with("CTC"))

oh2014_int <- oh2014 %>%filter(OHDDESTS==1,OHDEXSTS==1)%>%
  select("SEQN", ends_with("CTC"))

oh2016_int <- oh2016 %>%filter(OHDDESTS==1,OHDEXSTS==1)%>%
  select("SEQN", ends_with("CTC"))

oh2018_int <- oh2018 %>%filter(OHDDESTS==1,OHDEXSTS==1)%>%
  select("SEQN", ends_with("CTC"))

#now I will create a new data-set from the above ones
oh_mrg <- bind_rows(oh2012_int, oh2014_int, oh2016_int, oh2018_int)
view(oh_mrg)

#finally, checking for duplicates in the id variable (SEQ)
table(duplicated(oh_mrg$SEQN))
#results: there are 8857 duplicated rows based in SEQN variable

#removing duplicate rows based on SEQN, saving to a new object
library(dplyr)
oh_mrg_nodup <- oh_mrg %>% distinct(SEQN, .keep_all = TRUE)

view(oh_mrg_nodup)

#checking for duplicates in SEQN in the final data-set "oh_mrg_nodup"
table(duplicated(oh_mrg_nodup$SEQN))
#results: no duplicates in oh_mrg_nodup (FALSE)


#commit+push


####################

#task 6.3: adding a new variable (year) to the demo data-sets
#saving the new data frame to new objects

library(dplyr)
demo2012yr <- demo2012 %>% mutate(year=2012, .before = "SEQN")
demo2014yr <- demo2014 %>% mutate(year=2014, .before = "SEQN")
demo2016yr <- demo2016 %>% mutate(year=2016, .before = "SEQN")
demo2018yr <- demo2018 %>% mutate(year=2018, .before = "SEQN")

#viewing the new data-sets
view(demo2012yr)
view(demo2014yr)
view(demo2016yr)
view(demo2018yr)


#commit+push


####################

#task 6.4: creating a new data-set, based on the 4 demo data-sets, that includes the variables SEQN, year, RIDAGEYR

#before creating a new merged data-set, I want to know if the variable of interest (RIDAGEYR) is coded the same way in all the sets
demo2012yr %>% select(ends_with("AGEYR"))
demo2014yr %>% select(ends_with("AGEYR"))
demo2016yr %>% select(ends_with("AGEYR"))
demo2018yr %>% select(ends_with("AGEYR"))
#in a randomly check, they seem to be coded the same, 

#now I will create new 4 data-sets with the variables of interest
demo2012_int <- demo2012yr %>%select("year","SEQN", ends_with("AGEYR"))
demo2014_int <- demo2014yr %>%select("year","SEQN", ends_with("AGEYR"))
demo2016_int <- demo2016yr %>%select("year","SEQN", ends_with("AGEYR"))
demo2018_int <- demo2018yr %>%select("year","SEQN", ends_with("AGEYR"))

#now I will create a new data-set from the above ones
demo_mrg <- bind_rows(demo2012_int, demo2014_int, demo2016_int, demo2018_int)
view(demo_mrg)

#finally, checking for duplicates in the id variable (SEQ)
table(duplicated(demo_mrg$SEQN))
#results: no duplicates (FALSE)


#commit+push


####################

#task 6.5: merging the data sets created in tasks 6.2 and 6.4, ignoring participants who are not present in both data-sets
#i.e. merging oh_mrg_nodup and demo_mrg by SEQN, a horizontal merging (including participants present on both data-sets)

final_mrg <- merge(demo_mrg, oh_mrg_nodup, by="SEQN", all=FALSE)
view(final_mrg)


#commit+push


####################


