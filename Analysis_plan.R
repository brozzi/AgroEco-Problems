## Analysis Plan for Data Carpentry

## Install packages
## Upload packages
## Upload data file

## Create a working file to use for analysis.
# Select each of the columns to use for analysis (In this case, looking at Carbon).
# Mutate the data to create a column for SOC_stock_tonsac in the working data.
# Filter the data so that there are no values below zero where the total carbon was non-detectable (ND).

## Demonstrate for loop with sample processing time calculation
# Make sure dates are formatted properly using the as.Date function
# Create a new vector for Processing_time_days
# Use a for loop to calculate the processing time for Date_sampled and Date_analyzed using the difftime function
# Set the new vector as a column in the soil_data data frame (df)

## Create functions "Taking_average_pre" and "taking_average_post" that can be used for any variable
# The function creates a new df for the combined average of each unit
# Filter for the specific sample type, 
# Group by the Unit 
# Summarize to create the mean
# The outputs are Average_variable_pre and Average_variable_post where in this case, the "variable" is SOC

## Create a conditional for loop to output SOC_change by unit
# Create empy df for the new output
# The loop subtracts the pre value from the post value for each unit, taking the data from the previously created functions
# It creates a new df conditionally so that only the average value is subtracted and makes sure that there is a value for both

## Create a summary table to use for visualizing the mean and standard deviation (sd)
# Group the Soil_working data by Unit and Sample_type
# Summarize SOC values to get the mean and sd for each Unit and Sample_type

## Visualize SOC stock using Soil_working data
# Assign colors to each Sample_type for easy visual
# Create a bar plot using ggplot with the fill set to sample type
# Add in facet_grid, labs, theme, and defined unit values

## Visualize Mean SOC stock using the Summary_table data
# Repeat the previous process for creating bar plot except for the facet_grid using ggplot
# Add in error bars based on the previously created means and sd's

## Obtain a new sd for the change in SOC
# Create a new summary table from the prvious one, filtering for Preplant and Postharvest Sample-types, and mutating to create a new column to use for the new sd values
# Use the new summary table (Summary_table_change) to create the sd of the change for each unit
# Merge the table of new sd's with the table for SOC_change to use in ggplot, called "change_table"

## Plot out the change in SOC using the change_table as the data
# Create a new ggplot similarly to the one used for the means
# Reorder the chart to show descending order by Unit
# Adjust table to use the newly created sd's and multiply them by 1.96 to turn them into confidence intervals
# Change the x values from unit numbers to actual variety names

## Run ANOVA test on SOC stock
# Use factors Unit, Fertilizer_treatment, and Sample_type
# Print a summary of results

## Run post hoc comparison for anova test using HSD.test on ANOVA model

## Run linear regression model on SOC stock by Unit
