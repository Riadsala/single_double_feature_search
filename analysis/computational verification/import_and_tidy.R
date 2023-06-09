library(tidyverse)
library(readxl)

import_experiment <- function(sheet, d_labels, exp_number, exp_part) {
  
  read_excel(
    "../../data/buetti2019/OSF_originaldata_corrected.xlsx", 
    sheet = sheet) %>%
    # use tidier variable names
    select(
      p_id = "Subject",
      trial = "Trial",
      t_id = "tid",
      N_T = "numd",
      d_feature = "dcolors",
      rt = "RT",
      response = "resp",
      error = "Error",
      starts_with("loc")) %>%
    pivot_longer(loc1:loc36, names_to = "location", values_to = "item") %>%
    filter(item == 1) %>%
    select(-item) %>%
    # code up p_id, t_id and distracter colour as a factor
    mutate(
      exp_id = paste(exp_number, exp_part, sep = ""),
      p_id = paste(exp_id, p_id, sep="-"),
      p_id = as_factor(p_id),
      d_feature = as_factor(d_feature),
      d_feature = fct_recode(d_feature, !!!d_labels),
      d_feature = fct_recode(d_feature, "no distractors" = "0"),
      t_id = as_factor(t_id),
      t_id = fct_recode(t_id, left = "0", right = "1"))  -> d
  
  return(d)
}


d <- list()

d$e1a <- import_experiment(2,  c(orange = "1", blue = "2", yellow = "3"), 1, "a")
d$e1b <- import_experiment(4,  c(diamond = "1", circle = "2", triangle = "3"), 1, "b")
d$e2a <- import_experiment(6,  c(`orange diamond` = "1", `blue circle` = "2", `yellow triangle` = "3"), 2, "a")
d$e2b <- import_experiment(8,  c(`orange circle` = "1", `yellow diamond` = "2", `blue triangle` = "3"), 2, "b")
d$e2c <- import_experiment(10, c(`blue diamond` = "1", `yellow circle` = "2", `orange triangle` = "3"), 2, "c")
d$e3a <- import_experiment(12, c(orange = "1", blue = "2", yellow = "3"), 3, "a")
d$e3b <- import_experiment(14, c(diamond = "1", circle = "2", semicircle = "3"), 3, "b")
d$e4a <- import_experiment(16, c(`orange diamond` = "1", `blue circle` = "2", `yellow semicircle` = "3"), 4, "a")
d$e4b <- import_experiment(18, c(`orange circle` = "1", `yellow diamond` = "2", `blue semicircle` = "3"), 4, "b")
d$e4c <- import_experiment(20, c(`blue diamond` = "1", `yellow circle` = "2", `orange semicircle` = "3"), 4, "c")

d <- bind_rows(d)


# convert locations to ring idea
r_inner <- c(1,2,3,10,11,12,19,20,21,28,29,30)
r_middle <- c(4,5,6,13,14,15,22,23,24,31,32,33)
r_outer <- c(7,8,9,16,17,18,25,26,27,34,35,36)


d %>% mutate(location = str_remove(location, "loc"),
             location = parse_integer(location),
             ring = if_else(location %in% r_inner, "inner", "missing"),
             ring = if_else(location %in% r_middle, "middle", ring),
             ring = if_else(location %in% r_outer, "outer", ring)) %>%
  select(-location) -> d 



# # remove error trials 
# print(dim(d))
 d <- d %>%
   filter(error == 0) 

account_for_zero_distracters <- function(experiment)
{
  # Little helper function to sort out the quirk with N_T = 0
  # i.e, in this case, d_feature is undefined
  # So, well, copy this row once for each value of d_feature
  
  d %>% filter(exp_id == experiment) %>%
    mutate(d_feature = as.character(d_feature)) -> df
  
  df_no_distarcors <- filter(df, N_T == 0)
  df <- filter(df, N_T > 0)
  
  for (lvl in unique(df$d_feature))
  { 
    no_dist_lvl <- df_no_distarcors %>% mutate(d_feature = lvl)
    df <- bind_rows(df, no_dist_lvl)
  }
  
  return(df)
}

d <- map_dfr(unique(d$exp_id), account_for_zero_distracters)

rm(account_for_zero_distracters, import_experiment)

