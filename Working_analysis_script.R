install.packages(tidyverse)
library(tidyverse)
Soil_data <- read.csv("C:/Users/brozzi/Documents/FG3_Data_2022/MasterFiles/Plot1_soil_working_raw.csv")

# Create new data for Stable Carbon

Soil_working <- Soil_data %>%
  select(Unit, Variety, Fertilizer_treatment, Sample_plot, Sample_type, Active_carbon_mgkg, Total_carbon_perc) %>% 
  mutate(Total_carbon_mgkg = Total_carbon_perc * 1000) %>%
  mutate(Stable_carbon_mgkg = Total_carbon_mgkg -Active_carbon_mgkg) %>%
  filter(Stable_carbon_mgkg > 0)


# Next, is to visualize stable carbon

hist_plot <- ggplot(data = Soil_working, aes(x = Stable_carbon_mgkg)) +
  geom_histogram(binwidth = 10, fill = "blue", color = "red", alpha = 0.7) +
  labs(title = "Histogram of Stable_carbon_mgkg", x = "Stable_carbon_mgkg", y = "Frequency")

# Summarizing data to create the mean and SD

summary_table <- Soil_working %>%
  group_by(Unit) %>%
  summarize(
     Mean_stable_carbon_mgkg = mean(Stable_carbon_mgkg, na.rm = TRUE),
     SD_stable_carbon_mgkg = sd(Stable_carbon_mgkg, na.rm = TRUE))

# Create a visualization of the Mean and SD

bar_plot <- ggplot(data = summary_table, aes(x = Unit, y = Mean_stable_carbon_mgkg)) +
  geom_bar(stat = "identity", position = "dodge", fill = "blue") +
  geom_errorbar(aes(ymin = Mean_stable_carbon_mgkg - SD_stable_carbon_mgkg, 
                    ymax = Mean_stable_carbon_mgkg + SD_stable_carbon_mgkg), 
                width = 0.2, position = position_dodge(0.9), color = "red") +
  labs(title = "Mean and SD of stable_carbon_mgkg by Unit", 
       x = "Unit", y = "Mean_stable_carbon_mgkg") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

  
  