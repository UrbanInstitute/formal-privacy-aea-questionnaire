##################################
##
## Author: Joshua Snoke
## Purpose: Make AEA survey anaylses data
##          with weights
##
##
##################################


##################################
## Survey data with edits
##################################
## load in survey file
aea_survey = readxl::read_excel(here('data', 'aea_survey_results.xlsx'))

## start edits
aea_questions = aea_survey[1, ]

## drop previews
aea_survey = aea_survey %>%
  filter(Status == 'IP Address')

## change some data
aea_survey = aea_survey %>%
  separate(Q1_7, sep = '(?<!\\s),(?!\\s)', into = c('Q1_7_1', 'Q1_7_2', 'Q1_7_3')) %>%
  mutate_at(vars(contains('Q1_7')), function(varr){sub('\\..*', '', varr)}) %>%
  mutate_at(vars(Q1_4,
                 contains('Q4')),
            as.numeric) %>%
  ## add orders for some questions
  mutate_at(vars(contains('Q2_1')),
            ordered,
            levels = c('Never', 'Infrequently', 'Frequently', 'Always')) %>%
  mutate_at(vars(contains('Q2_3')),
            ordered,
            levels = c('Not at all important', 'Somewhat important', 'Important', 'Very important')) %>%
  mutate(Q3_1 = ordered(Q3_1, levels = c('Have never heard of the concept',
                                         'Have heard the term but am not familiar with any details',
                                         'Have read a blog, newspaper, or non-academic report or discussion on the topic',
                                         'Have read an academic paper on the topic',
                                         'Feel confident implementing these methods on my own')),
         Q3_2 = ordered(Q3_2, levels = c('Have never heard of the concept',
                                         'Have heard the term in relation to Differential Privacy, but I do not know the difference',
                                         'Am familiar with the concept and the distinction from differential privacy'))) %>%
  mutate_at(vars(Q3_3, Q3_4),
            ordered,
            levels = c('None', 'A minority', 'A majority', 'All'))

## add indicators for each JEL code
## first define new variables
jel_tibble = as_tibble(matrix(0, 
                              ncol = length(unique(na.omit(c(aea_survey$Q1_7_1, aea_survey$Q1_7_2, aea_survey$Q1_7_3)))), 
                              nrow = nrow(aea_survey), 
                              dimnames = list(rep('', nrow(aea_survey)), 
                                              paste('Q1_7_', sort(unique(c(aea_survey$Q1_7_1, aea_survey$Q1_7_2, aea_survey$Q1_7_3))), sep = '')))) %>%
  mutate(ResponseId = aea_survey$ResponseId, .before = `Q1_7_A`)
## add flags for each jel code
for(temp_code in grep('Q1_7', colnames(jel_tibble), value = TRUE)){
  sub_code = sub('Q1_7_', '', temp_code)
  
  temp_id = aea_survey %>% 
    select(ResponseId,
           contains('Q1_7')) %>%
    filter(Q1_7_1 == sub_code |
             Q1_7_2 == sub_code |
             Q1_7_3 == sub_code) %>%
    pull(ResponseId)
  
  jel_tibble[jel_tibble$ResponseId %in% temp_id, temp_code] = 1
}

## add to aea survey frame
aea_survey = aea_survey %>%
  left_join(jel_tibble,
            by = 'ResponseId')


## add new demographic variables
## separate JEL by H (public economics, including public finance); I (health and education)
## J (labor economics), and possibly R (urban/regional/housing/transportation). 
## if anyone selected any they are "target", otherwise not
aea_analysis = aea_survey %>%
  mutate(Q1_4 = cut(Q1_4, c(1949, 2002, 2012, 2050),
                    labels = c('Early-Career', 'Mid-Career', 'Late-Career')),
         Q1_7_target = case_when(Q1_7_H + Q1_7_I + Q1_7_J + Q1_7_R >= 1 ~ 1,
                                 TRUE ~ 0)) %>%
  mutate_if(is.character, forcats::fct_na_level_to_value, 'NA') %>%
  mutate_if(is.factor, forcats::fct_na_level_to_value, 'NA')

## lastly, drop those with more than 90% missing
indiv_missing_perc = aea_analysis %>%
  select(contains('Q'), 
         -contains('Q1_7_')) %>%
  is.na %>%
  rowMeans

## dropping 11 people who missed more than 90% of questions
table(indiv_missing_perc >= 0.9)

aea_analysis = aea_analysis %>%
  filter(indiv_missing_perc < 0.9)


## remove unneeded objects - everything but analysis file
rm(list = setdiff(ls(), "aea_analysis"))






