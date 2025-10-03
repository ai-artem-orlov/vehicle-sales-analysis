# Vehicle Sales Analysis

## Abstract
The aim of the project is to help the fictitious European car-selling company Motor123 from 2015 analyze the US vehicle market and competition landscape to plan and prepare for expansion. The project involves: basic data exploration in Excel; modeling, relational database creation, and data analysis in SQL Server; visualization in Power BI; data imputation using Python.


## Dataset
The dataset used in this project comes from Kaggle:
- Title: [Vehicle Sales Data](https://www.kaggle.com/datasets/syedanwarafridi/vehicle-sales-data/data)
- Author: [Syed Anwar](https://www.kaggle.com/syedanwarafridi)
- License: [MIT License](https://www.mit.edu/~amini/LICENSE.md)
The dataset is included in this repository under the terms of the MIT License. All credit for the dataset goes to the original author.


## Data preparation and basic exploration in Excel
At the beginning, the dataset was downloaded from Kaggle in .csv format. Then it got cleaned in Power Query by: assigning column datatypes to catch inconsistencies, trimming and aligning capitalization of text columns, and removing rows with errors and missing data. Initially, the dataset contained 558837 rows, so it was decided that the optimal way to handle missing data issue was by removing the rows as the dataset is pretty big considering the time period it covers. After the cleaning the dataset had 432602 rows, so 126235 rows were removed, which is around 23% of the initial size. The final dataset was saved as [data_in_csv](https://github.com/ai-artem-orlov/vehicle-sales-analysis/blob/main/data_in_csv.zip).
<img width="1441" height="187" alt="image" src="https://github.com/user-attachments/assets/e8433e37-72b1-41ba-b126-4670a3cc15d1" />

The next step was basic exploratory data analysis using descriptive statistics, distribution charts, and pivot tables. This allowed to understand the quantitative data better. The results were saved in excel workbook [data_and_basic_EDA_binary](https://github.com/ai-artem-orlov/vehicle-sales-analysis/blob/main/data_and_basic_EDA_binary.xlsb). Excel Binary File Format .xlsb was used to reduce the size of the file.
<img width="479" height="185" alt="image" src="https://github.com/user-attachments/assets/9b3edd73-5a61-451a-b850-396c35d17cf1" />
<img width="428" height="256" alt="image" src="https://github.com/user-attachments/assets/2c9069a0-66db-4c7d-9245-7628ac793107" />


## Data modeling and relational database creation in SQL Server
## Data analysis in SQL Server
## Data imputation using Python
## Data visualization in Power BI
## Conclusion


## License
- My code and analysis: Licensed under the [MIT License](https://github.com/ai-artem-orlov/vehicle-sales-analysis?tab=MIT-1-ov-file).
- Dataset: Licensed under the [MIT License](https://www.mit.edu/~amini/LICENSE.md) by [Syed Anwar](https://www.kaggle.com/syedanwarafridi).
