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

Stable_Carbon <- ggplot(data = Soil_working, aes(x = Unit, y = Stable_carbon_mgkg, fill = Sample_type)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  labs(title = "Bar Plot of stable_carbon_mgkg by Unit and Sample Type", x = "Unit", y = "stable_carbon_mgkg") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Summarizing data to create the mean and SD for preplant

summary_table <- Soil_working %>%
  group_by(Unit, Sample_type) %>%
  summarize(
     Mean_stable_carbon_mgkg = mean(Stable_carbon_mgkg, na.rm = TRUE),
     SD_stable_carbon_mgkg = sd(Stable_carbon_mgkg, na.rm = TRUE))

# Create a visualization of the Mean and SD

Mean_stable_C <- ggplot(data = summary_table, aes(x = Unit, y = Mean_stable_carbon_mgkg, fill = Sample_type)) +
  geom_bar(stat = "identity", position = "dodge", fill = "cyan") +
  geom_errorbar(aes(ymin = Mean_stable_carbon_mgkg - SD_stable_carbon_mgkg, 
                    ymax = Mean_stable_carbon_mgkg + SD_stable_carbon_mgkg), 
                width = 0.2, position = position_dodge(0.9), color = "black") +
  labs(title = "Mean Stable Carbon", 
       x = "Unit", y = "Mean_stable_carbon_mgkg") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

  # Summarizing data to create the mean and sd for postharvest

summary_table_post <- Soil_working %>%
  group_by(Unit, Sample_type == "Postharvest") %>%
  summarize(
    Mean_stable_carbon_mgkg = mean(Stable_carbon_mgkg, na.rm = TRUE),
    SD_stable_carbon_mgkg = sd(Stable_carbon_mgkg, na.rm = TRUE))

# Create a visualization of the Mean and SD

bar_plot_post <- ggplot(data = summary_table, aes(x = Unit, y = Mean_stable_carbon_mgkg)) +
  geom_bar(stat = "identity", position = "dodge", fill = "cyan") +
  geom_errorbar(aes(ymin = Mean_stable_carbon_mgkg - SD_stable_carbon_mgkg, 
                    ymax = Mean_stable_carbon_mgkg + SD_stable_carbon_mgkg), 
                width = 0.2, position = position_dodge(0.9), color = "black") +
  labs(title = "Mean Postharvest Stable Carbon", 
       x = "Unit", y = "Mean_stable_carbon_mgkg") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
  