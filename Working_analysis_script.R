install.packages(tidyverse)
library(tidyverse)
Soil_working <- read.csv("C:/Users/brozzi/Documents/FG3_Data_2022/MasterFiles/Plot1_soil_working_raw.csv")

# Create new data for Stable Carbon

Soil_working <- Soil_working %>%
  select(Unit, Variety, Fertilizer_treatment, Sample_plot, Sample_type, Active_carbon_mgkg, Total_carbon_perc) %>%
  filter(Fertilizer_treatment %in% c("preplant", "postharvest")) %>%
  mutate(Total_carbon_mgkg = Total_carbon_perc * 1000) %>%
  mutate(Stable_carbon_mgkg = Total_carbon_mgkg -Active_carbon_mgkg)

# Next, is to visualize stable carbon

hist_plot <- ggplot(data = Soil_working, aes(x = Stable_carbon_mgkg)) +
  geom_histogram(binwidth = 10, fill = "blue", color = "red", alpha = 0.7) +
  labs(title = "Histogram of Stable_carbon_mgkg", x = "Stable_carbon_mgkg", y = "Frequency")

# Summarizing data to create the mean and SD

summary_table <- Soil_working %>%
  group_by(Fertilizer_treatment) %>%
  summarize(
     Mean_stable_carbon_mgkg = mean(Stable_carbon_mgkg),
     SD_stable_carbon_mgkg = sd(Stable_carbon_mgkg))

# Create a visualization of the Mean and SD

bar_plot <- ggplot(data = summary_table, aes(x = Fertilizer_treatment)) +
  geom_bar(stat = "identity", position = "dodge", fill = "blue") +
  geom_errorbar(aes(ymin = Mean_stable_carbon_mgkg - SD_stable_carbon_mgkg, 
                    ymax = Mean_stable_carbon_mgkg + SD_stable_carbon_mgkg), 
                width = 0.2, position = position_dodge(0.9), color = "red") +
  labs(title = "Mean and SD of stable_carbon_mgkg by Fertilizer Treatment", 
       x = "Fertilizer Treatment", y = "Mean_stable_carbon_mgkg") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

  
  