# Vehicle Sales Analysis


## Abstract
The aim of the project is to help the fictitious European car-selling company Motor123 from 2015 analyze the US vehicle market and competition landscape to plan and prepare for expansion. The project involves: basic data exploration in Excel; modeling, relational database creation, and data analysis in SQL Server; visualization in Power BI; and data imputation using Python.


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

<img width="597" height="230" alt="image" src="https://github.com/user-attachments/assets/9b3edd73-5a61-451a-b850-396c35d17cf1" />
<img width="385" height="230" alt="image" src="https://github.com/user-attachments/assets/2c9069a0-66db-4c7d-9245-7628ac793107" />


## Data modeling and relational database creation in SQL Server
After the analysis in Excel, the data was imported as a flat file into the created database "vehicle_sales" in SQL Server Management Studio. Then a basic data transformations were performed in SQL: changing column datatypes to more appropriate ones and splitting "saledate" column into parts that can be more easily analyzed. The entire SQL code can be viewed here: [modeling_query](https://github.com/ai-artem-orlov/vehicle-sales-analysis/blob/main/modeling_query.sql).

In the next step the relational database structure was created and then filled with data. Besides that, primary key and foreign key constrains were specified to ensure data consistency. As a result the database had the following snowflake schema with "sale" table as a fact and other tables as dimensions:

<img width="690" height="449" alt="image" src="https://github.com/user-attachments/assets/eac66338-905c-48e6-80ea-fa65c54369f8" />


## Data analysis in SQL Server
This part of the project focused on finding useful insights about two major areas: competition and portfolio. Having the relational database created earlier, the analysis was started from additional data exploration using SQL. This allowed to examine data structures and distributions more deeply. The EDA allowed to observe the issue with the sales distribution over time, which resulted in decision to crop the dataset to only six first months of 2015. The dataset after filtering covered 397682 sales across 34 states and involved 11661 sellers and 767 car models.

<img width="385" height="270" alt="image" src="https://github.com/user-attachments/assets/e19c1ca0-26cc-4a67-bdb7-d634894dcdf3" />

| price_category |	number_of_sales |
|:--------------|--------------|
| 1	 | 391379 |
| 2 |	5974 |
| 3 |	269 |
| 4 |	47 |
| 5 |	12 |
| 6 |	1 |

---

The competition analysis identified the main revenue drivers, with Ford Motor Credit Company LLC, The Hertz Corporation, and Nissan Infiniti LT leading in total sales value. It also measured month-to-month revenue growth to detect the fastest-expanding sellers, and compared average selling prices and price differences relative to market value (MMR) to assess sales efficiency. Finally, it analyzed the sellers’ operational reach across states and revealed that competition was the most intense in California, Florida, and Texas, where over 1,000 sellers were active.

<img width="735" height="324" alt="image" src="https://github.com/user-attachments/assets/f4a1eb5f-e8e4-4292-a4be-1c0f95bddf29" />

| Seller                                     | Avg Revenue Change |
|:--------------------------------------------|--------------------:|
| PORSCHE FINANCIAL SERVICES                 | 924,625            |
| WORLD OMNI FINANCIAL CORPORATION           | 832,360            |
| GM REMARKETING                             | 828,325.8          |
| MIDWEST CAR CORPORATION/ALLY FINANCIAL     | 792,800            |
| HYUNDAI MOTOR FINANCE                      | 733,900            |

---

In the portfolio analysis, the focus shifted from sellers to the cars themselves. The analysis determined best-selling models for each seller and identified which models and brands most frequently achieved bestseller status across the dataset. Ford F-150, Honda Accord, and BMW 3 Series stood out as the most common bestsellers, with Ford, Chevrolet, and Honda dominating overall. Further exploration of month-to-month trends highlighted models such as Nissan Leaf, GMC Savana Cargo, and Chevrolet Sonic as those gaining the most popularity. Additionally, the analysis identified car models sold significantly above their market value, with Aston Martin Rapide and Cadillac CTS-V Wagon showing particularly high average margins.

<img width="1441" height="882" alt="image" src="https://github.com/user-attachments/assets/ef3ecdad-ac82-46b7-ab41-c6395480f6e7" />

| Make       | Model         | Sum M2M Sale Changes |
|:-------------|:---------------|--------------------:|
| NISSAN      | LEAF           | 273                 |
| GMC         | SAVANA CARGO   | 160                 |
| CHEVROLET   | SONIC          | 148                 |
| HYUNDAI     | ELANTRA        | 44                  |
| INFINITI    | JX             | 30                  |


## Data imputation using Python
The deeper exploratory analysis in SQL Server allowed to identify unproportionally small number of sales in the March-May 2015 period, which suggested that some data might be missing. Therefore, it was decided to conduct time series imputation on number of sales and revenue. It was performed using Python in the following notebook: [data_imputation](https://github.com/ai-artem-orlov/vehicle-sales-analysis/blob/main/data_imputation.ipynb). Libraries used in the notebook involve: pandas, numpy, matplotlib, sklearn, statsmodels, etc.

At the beginning, the dataset was filtered and aggregated to achieve the structure required for analysis. The next step was splitting data into training and testing parts and starting modeling on the former one. Firstly, the stationarity of the time series was tested with the Augmented Dickey–Fuller test, which confirmed that mean and variance are stable through time. This allowed to check the time series for seasonality using autocorrelation and partial autocorrelation charts, which identified weekly seasonality. 

<img width="927" height="716" alt="image" src="https://github.com/user-attachments/assets/11c60686-bbba-44db-b548-f6b313aa2696" />
<img width="940" height="710" alt="image" src="https://github.com/user-attachments/assets/03508bf8-e66d-4a1a-ae60-321cabcd592c" />

For the modeling the seasonality coefficients method was used. It required fitting the trend line to the time series, calculating residuals from it, and then avereging those residuals for each phase of weekly seasonality cycle. After some iterations with trend lines, the model started fitting the dataset pretty well. Mean absolute error (MAE) indicated that the estimated number of sales differs from the actual number on average by 1738. Also, root mean square error (RMSE) indicated that the average error in a model's predictions equals 2946. In a context of sales number range (0 to around 12k) MAE and RMSE are quite moderate as their ratios to the range lenth are around 1/6 and 1/4 correspondingly.

<img width="959" height="743" alt="image" src="https://github.com/user-attachments/assets/192bce5f-e132-4980-99bb-562a27b625b7" />

As a result, the number of sales time series was imputed and probably became more trustworthy as it solved probable data collection issues.

<img width="972" height="744" alt="image" src="https://github.com/user-attachments/assets/5b42ddbb-5029-4256-bec8-b16a9ba592e7" />

Finally, based on the model for the number of sales, the revenue time series was also imputed. There was a very strong linear dependency between number of sales and revenue confirmed by Perason's correlation coefficient r=0.995. Based on that, estimated revenue values were calculated using linear regression and estimated number of sales values.

<img width="978" height="741" alt="image" src="https://github.com/user-attachments/assets/ea900985-9f54-4fdd-a4c5-bf056bb7a299" />


## Data visualization in Power BI
## Conclusion


## License
- My code and analysis: Licensed under the [MIT License](https://github.com/ai-artem-orlov/vehicle-sales-analysis?tab=MIT-1-ov-file).
- Dataset: Licensed under the [MIT License](https://www.mit.edu/~amini/LICENSE.md) by [Syed Anwar](https://www.kaggle.com/syedanwarafridi).
