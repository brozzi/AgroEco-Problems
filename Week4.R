Library(tidyverse)
Soil_data <- read.csv("C:\Users\brozzi\Documents\FG3_Data_2022\MasterFiles\Plot1_soil_working_raw.csv")
  
Pre_Post <- filter(Sample_type == 'Preplant' | Sample_type == 'Postharvest') + 
select(Soil_data, Unit, Variety, Fertilizer_treatment, Sample_plot, Sample_type, Active_carbon_mgkg, Total_carbon_perc)

mutate(Pre_Post, Total_carbon_mgkg = Total_carbon_perc * 10000)
  
  