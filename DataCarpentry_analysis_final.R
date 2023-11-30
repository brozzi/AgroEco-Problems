# Load and install --------------------------------------------------------------------------------------------------------------
install.packages("tidyverse")
install.packages("agricolae")
library(tidyverse)
Soil_data <- read.csv("C:/Users/brozzi/Documents/FG3_Data_2022/MasterFiles/Plot1_soil_working_raw.csv")

# Data manipulation -------------------------------------------------------------------------------------------------------------

## Select, Filter, and Mutate to create new working file for SOC Stock 

Soil_working <- Soil_data %>%
  select(Sample_ID, Unit, Variety, Fertilizer_treatment, Sample_plot, Sample_type, 
         Active_carbon_mgkg, Total_carbon_perc, Bulk_density_gcm3, Sample_depth_cm) %>% 
  mutate(Active_carbon_mgg = Active_carbon_mgkg / 1000,
         Total_carbon_mgg = Total_carbon_perc * 10,
         Stable_carbon_mgg = Total_carbon_mgg - Active_carbon_mgg,
         SOC_stock_tonsac = Stable_carbon_mgg * Bulk_density_gcm3 * Sample_depth_cm*0.04) %>%
  filter(Stable_carbon_mgg > 0)
## Where 0.04 = conversion factor to tons/acre

# Simple For Loop ---------------------------------------------------------------------------------------------------------------
## Processing time calculation

## Formatting the dates for the loop
Soil_data$Date_sampled <- as.Date(Soil_data$Date_sampled, format="%Y-%m-%d") 
Soil_data$Date_analyzed <- as.Date(Soil_data$Date_analyzed, format="%Y-%m-%d")

## Empty vector to store processing times
Processing_time_days <- numeric(nrow(Soil_data))

## For loop to calculate processing time for each row
## Processing_time_days = Date_analyzed - Date_sampled 
for (i in 1:nrow(Soil_data)) {
  Processing_time_days[i] <- as.numeric(difftime(Soil_data$Date_analyzed[i], 
                                                 Soil_data$Date_sampled[i], units="days"))
}

Soil_data$Processing_time_days <- Processing_time_days

# Functions and For Loops -------------------------------------------------------------------------------------------------------

## Demonstrating functions and for loops by calculating SOC stock change

## Creating a function for _pre and _post treatment averages
Taking.average.post <- function(Soil_working) {
  Average_SOC_post <- Soil_working %>%
    filter(Sample_type == "Postharvest") %>%
    group_by(Unit) %>%
    summarize(Average = mean(SOC_stock_tonsac, na.rm = TRUE))
  
  return(Average_SOC_post)
}

Average_SOC_post <- Taking.average.post(Soil_working)

Taking.average.pre <- function(Soil_working) {
  Average_SOC_pre <- Soil_working %>%
    filter(Sample_type == "Preplant") %>%
    group_by(Unit) %>%
    summarize(Average = mean(SOC_stock_tonsac, na.rm = TRUE))

  return(Average_SOC_pre)
}

Average_SOC_pre <- Taking.average.pre(Soil_working)


## Conditional for loop to create SOC_change table
SOC_change <- data.frame()

for (i in 1:nrow(Average_SOC_post)) {
  
  post_value <- Average_SOC_post$Average[i]
  
  if (i <= nrow(Average_SOC_pre)) {
      pre_value <- Average_SOC_pre$Average[i]
  
      SOC_change <- rbind(SOC_change, data.frame(Unit = Average_SOC_post$Unit[i],
                                                 SOC_stock_change = post_value - pre_value))
} else {
      warning("Row not found in Average_tretment_pre for index", i)
  }
}

print(SOC_change)

# SOC visual --------------------------------------------------------------------------------------------------------------------

## Demonstrating a basic plot for SOC Stock

## Setting the color for Sample_type
sample_type_colors <- c("Preplant" = "cyan", "Postharvest" = "red")

SOC_stock_plot <- ggplot(data = Soil_working, aes(x = Unit, y = SOC_stock_tonsac, fill = Sample_type)) +
  geom_bar(stat = "identity", position = "dodge", color = "black") +
  facet_grid(. ~ Sample_type) +
  labs(title = "SOC Stock", x = "Unit", y = "SOC (tons/ac)") +
  theme(axis.text.x = element_text(angle = 0, hjust = 0.5), plot.title = element_text(hjust = 0.5)) +
  scale_x_discrete(limits=c("1", "2","3","4","5","6","7","8","9","10","11","12"))


print(SOC_stock_plot)

# Mean SOC summary and visual ---------------------------------------------------------------------------------------------------

## Summary table of the mean and sd for visualization

summary_table <- Soil_working %>%
  group_by(Unit, Sample_type) %>%
  summarize(
     Mean_SOC_tonsac = mean(SOC_stock_tonsac, na.rm = TRUE),
     SD_SOC_tonsac = sd(SOC_stock_tonsac, na.rm = TRUE))


## Demonstrating more detailed plot for mean and SD of SOC stock

mean_SOC_plot <- ggplot(data = summary_table, aes(x = Unit, y = Mean_SOC_tonsac, fill = Sample_type)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_errorbar(aes(ymin = Mean_SOC_tonsac - SD_SOC_tonsac, 
                    ymax = Mean_SOC_tonsac + SD_SOC_tonsac), 
                width = 0.4, position = position_dodge(0.9), color = "black") +
  labs(title = "Mean SOC Stock", 
       x = "Unit", y = "SOC (tons/ac)", fill = "Sample Type") +
  theme(axis.text.x = element_text(angle = 0, hjust = 0.5), plot.title = element_text(hjust = 0.5)) +
  scale_x_discrete(limits=c("1", "2","3","4","5","6","7","8","9","10","11","12"))


print(mean_SOC_plot)

# SOC Change and combining skills -----------------------------------------------------------------------------------------------

## Creating the SD for SOC stock change plot

summary_table_change <- summary_table %>%
  filter(Sample_type %in% c("Postharvest", "Preplant")) %>%
  mutate(Sample_SOC_change = -1 * (Mean_SOC_tonsac - lag(Mean_SOC_tonsac, default = first(Mean_SOC_tonsac))))

summary_table_change_sd <- summary_table_change %>%
  summarize(sd_SOC_change = sd(Sample_SOC_change, na.rm = TRUE))

change_table <- merge(SOC_change, summary_table_change_sd)


## Visual for SOC Stock Change with 95% confidence intervals, showing a final figure that I would use in my research

change_SOC_plot <- ggplot(data = change_table, aes(x = reorder(Unit, -SOC_stock_change), 
                                                   y = SOC_stock_change)) +
  geom_bar(stat = "identity", position = "dodge", fill = "green4") +
  geom_errorbar(aes(ymin = SOC_stock_change - 1.96 * sd_SOC_change, 
                    ymax = SOC_stock_change + 1.96 * sd_SOC_change), 
                width = 0.2, color = "black") +
  labs(title = "SOC Stock Change", 
       x = "Unit", y = "SOC Stock Change (tons/ac)") +
  theme(axis.text.x = element_text(angle = 30, hjust = 0.5), 
        plot.title = element_text(hjust = 0.5)) +
  scale_x_discrete(labels = c("SS-2", "SS-1", "Yuma", "Dongma", "Han-NW", "Han-FNQ",
                              "Zhongma", "SH-1", "Puma", "Han-NW", "SH-2", "Yuma-S")) 


print(change_SOC_plot)

# Statistics  -------------------------------------------------------------------------------------------------------------------

## Demonstrating ANOVA test on SOC stock
anova_SOC <- aov(SOC_stock_tonsac ~ Unit * Fertilizer_treatment * Sample_type, data = Soil_working)
summary(anova_SOC)

## Demonstrating Post-hoc test on ANOVA model
library(agricolae)
PostHoc_test <- HSD.test(anova_SOC, "Unit", alpha = 0.05, group = TRUE, console = TRUE, main = "SOC Stock by unit")

plot(PostHoc_test)

## Demonstrating Linear regression of SOC stock
lm_SOC <- lm(SOC_stock_tonsac ~ Unit, data = Soil_working)
summary(lm_SOC)


 