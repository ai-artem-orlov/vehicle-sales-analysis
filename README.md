# Vehicle Sales Analysis

## Abstract
The goal of this project is to help the fictitious European car-selling company **Motor123** (as of 2015) analyze the U.S. vehicle market and competitive landscape to plan and prepare for expansion. The project involves: basic data exploration in Excel; data modeling, relational database creation, and analysis in SQL Server; data imputation using Python; and visualization in Power BI.

## Dataset
The dataset used in this project comes from Kaggle:  
- **Title:** [Vehicle Sales Data](https://www.kaggle.com/datasets/syedanwarafridi/vehicle-sales-data/data)  
- **Author:** [Syed Anwar](https://www.kaggle.com/syedanwarafridi)  
- **License:** [MIT License](https://www.mit.edu/~amini/LICENSE.md)  

The dataset is included in this repository under the terms of the MIT License. Full credit for the dataset goes to the original author.

## Data Preparation and Basic Exploration in Excel
The dataset was downloaded from Kaggle in `.csv` format and cleaned in Power Query by assigning proper data types, standardizing text capitalization, and removing rows with errors or missing data.  

Initially, the dataset contained **558,837 rows**, but after cleaning, **432,602 rows** remained—**126,235 rows** (around 23%) were removed as it was decided that the optimal way to handle missing data issue was by removing the rows because the dataset is pretty big considering the time period it covers. The cleaned dataset was saved as [data_in_csv](https://github.com/ai-artem-orlov/vehicle-sales-analysis/blob/main/data_in_csv.zip).

<img width="1441" height="187" alt="image" src="https://github.com/user-attachments/assets/e8433e37-72b1-41ba-b126-4670a3cc15d1" />

Basic exploratory data analysis was then performed using descriptive statistics, distribution charts, and pivot tables to better understand the quantitative data. The results were saved in [data_and_basic_EDA_binary](https://github.com/ai-artem-orlov/vehicle-sales-analysis/blob/main/data_and_basic_EDA_binary.xlsb) (Excel Binary File Format `.xlsb` used to reduce file size).

<img width="597" height="230" alt="image" src="https://github.com/user-attachments/assets/9b3edd73-5a61-451a-b850-396c35d17cf1" />
<img width="385" height="230" alt="image" src="https://github.com/user-attachments/assets/2c9069a0-66db-4c7d-9245-7628ac793107" />


## Data Modeling and Relational Database Creation in SQL Server
After the Excel analysis, the cleaned data was imported as a flat file into a new database named **vehicle_sales** in SQL Server Management Studio.  
Basic transformations were performed, including adjusting column data types and splitting the “saledate” column into parts for easier analysis. The full SQL code can be found here: [modeling_query](https://github.com/ai-artem-orlov/vehicle-sales-analysis/blob/main/modeling_query.sql).

Next, a relational database structure was created and populated with data. Primary and foreign key constraints were added to ensure data consistency.  
The resulting schema followed a **snowflake structure**, with the **sale** table as the fact table and other tables as dimensions.

<img width="690" height="449" alt="image" src="https://github.com/user-attachments/assets/eac66338-905c-48e6-80ea-fa65c54369f8" />

## Data Analysis in SQL Server
This stage focused on uncovering insights related to **competition** and **portfolio** performance.  
Using SQL, additional data exploration was performed to examine structures and distributions in more depth. The analysis revealed inconsistencies in sales distribution over time, leading to the decision to filter the dataset to the first six months of 2015.  
After filtering, the dataset included **397,682 sales** across **34 states**, involving **11,661 sellers** and **767 car models**.

<img width="385" height="270" alt="image" src="https://github.com/user-attachments/assets/e19c1ca0-26cc-4a67-bdb7-d634894dcdf3" />

| price_category |	number_of_sales |
|:--------------|--------------|
| 1	 | 391379 |
| 2 |	5974 |
| 3 |	269 |
| 4 |	47 |
| 5 |	12 |
| 6 |	1 |

### Competition Analysis
The competition analysis identified key revenue drivers, with **Ford Motor Credit Company LLC**, **The Hertz Corporation**, and **Nissan Infiniti LT** leading in total sales value.  
It also measured month-to-month revenue growth to detect the fastest-expanding sellers and compared average selling prices to market value (MMR) to assess sales efficiency.  
The analysis revealed that competition was most intense in **California**, **Florida**, and **Texas**, where over **1,000 sellers** were active.

<img width="735" height="324" alt="image" src="https://github.com/user-attachments/assets/f4a1eb5f-e8e4-4292-a4be-1c0f95bddf29" />

| Seller                                     | Avg Revenue Change |
|:--------------------------------------------|--------------------:|
| PORSCHE FINANCIAL SERVICES                 | 924,625            |
| WORLD OMNI FINANCIAL CORPORATION           | 832,360            |
| GM REMARKETING                             | 828,325            |
| MIDWEST CAR CORPORATION/ALLY FINANCIAL     | 792,800            |
| HYUNDAI MOTOR FINANCE                      | 733,900            |

### Portfolio Analysis
This part shifted focus from sellers to vehicles.  
The analysis identified best-selling models for each seller and determined which models and brands most often achieved bestseller status.  
The **Ford F-150**, **Honda Accord**, and **BMW 3 Series** emerged as the most frequent bestsellers, while **Ford**, **Chevrolet**, and **Honda** dominated overall.

Month-to-month trend analysis highlighted models such as the **Nissan Leaf**, **GMC Savana Cargo**, and **Chevrolet Sonic** as gaining popularity.  
Additionally, the **Aston Martin Rapide** and **Cadillac CTS-V Wagon** showed the highest average margins when sold above market value.

<img width="1441" height="882" alt="image" src="https://github.com/user-attachments/assets/ef3ecdad-ac82-46b7-ab41-c6395480f6e7" />

| Make       | Model         | Sum M2M Sale Changes |
|:-------------|:---------------|--------------------:|
| NISSAN      | LEAF           | 273                 |
| GMC         | SAVANA CARGO   | 160                 |
| CHEVROLET   | SONIC          | 148                 |
| HYUNDAI     | ELANTRA        | 44                  |
| INFINITI    | JX             | 30                  |


## Data Imputation Using Python
The deeper exploration in SQL Server revealed an unusually low number of sales between March and May 2015, suggesting missing data.  
To address this, **time series imputation** was performed on sales and revenue using Python ([data_imputation](https://github.com/ai-artem-orlov/vehicle-sales-analysis/blob/main/data_imputation.ipynb)).  
Libraries used included `pandas`, `numpy`, `matplotlib`, `sklearn`, and `statsmodels`.

After filtering and aggregating the dataset for analysis, data was split into training and testing sets.  
The **Augmented Dickey–Fuller test** confirmed time series stationarity, so the assumption for autocorrelation analysis was met. It identified clear **weekly seasonality**.  

<img width="470" height="355" alt="image" src="https://github.com/user-attachments/assets/be18c3b4-e3c5-465e-8331-dd7d1c1c491c" />
<img width="470" height="355" alt="image" src="https://github.com/user-attachments/assets/a92a0805-3eb2-4782-8278-f59fa86e6b85" />

For modeling the **seasonality coefficients method** was chosen because the time series exhibits stable, repeating seasonal patterns that can be quantified and applied as additive adjustments.
A trend line was fitted, residuals calculated, and seasonal effects averaged for each weekly cycle.  
After some iterations with trend lines the model evaluation showed:  
- **Mean Absolute Error (MAE):** 1,738  
- **Root Mean Square Error (RMSE):** 2,946  

Given the sales range (0 to ~12k), these errors were moderate (MAE ≈ 1/6, RMSE ≈ 1/4 of range length).  

<img width="480" height="371" alt="image" src="https://github.com/user-attachments/assets/e8836f6b-8140-49f7-95b3-ab2f40b036d2" />

The imputed time series corrected potential data collection issues, making the dataset more reliable.

<img width="486" height="372" alt="image" src="https://github.com/user-attachments/assets/f7187d9f-c122-43d8-91b1-9e5c64e8af3e" />

Finally, the **revenue series** was imputed using linear regression based on the strong correlation between sales and revenue (**Pearson’s r=0.995**).

<img width="489" height="370" alt="image" src="https://github.com/user-attachments/assets/87f51034-52be-449b-8fca-49da5d8f5ac8" />

## Data Visualization in Power BI
The final part involved presenting the data, so that stakeholders in Motor123 can easily access it and draw new insights from it. Therefore, the universal Power BI report was created, which enables users to slice the data in various ways and analyze it from different perspectives.   
A Power BI report was built with three key pages — **Competition**, **Portfolio**, and **Estimation** — stored as [vehicle_market_report](https://github.com/ai-artem-orlov/vehicle-sales-analysis/blob/main/vehicle_market_report.pbix).

After connecting to the SQL Server relational model and performing minor cleaning in Power Query, the **Competition** page was developed to show market size, competition structure, and seller distribution across the U.S.  
It identifies leading sellers and visualizes market fluctuations over time.  

<img width="1086" height="610" alt="image" src="https://github.com/user-attachments/assets/d6b3b52d-9719-4163-8c4e-7057c819c5e7" />

A dynamic DAX-based pie chart was implemented to display only sellers with at least **3%** market share, grouping others as “Other.” This ensured clarity and readability.

<img width="962" height="245" alt="image" src="https://github.com/user-attachments/assets/fac03efd-6736-4bc7-bdc9-e8f143e5fe73" />

The **Portfolio** page presents sales performance by model and brand, helping stakeholders identify bestsellers, understand demand patterns, and assess customer preferences.

<img width="1086" height="610" alt="image" src="https://github.com/user-attachments/assets/d6aa4c4d-c22f-44ee-b146-0039a7f03b93" />

Finally, the **Estimation** page compares actual and imputed data from Python, allowing stakeholders to evaluate the potential risks of decision-making based on the actual dataset only. It is a great alternative, which may be considered as optimistic version of history.

<img width="1086" height="610" alt="image" src="https://github.com/user-attachments/assets/fc5d144d-3442-4430-ab11-8f24affa7704" />

## Conclusion
The project successfully delivers a comprehensive, multi-angle analysis of the U.S. vehicle market, helping the fictitious European company **Motor123** prepare for expansion.  
It enables data-driven decision-making in key areas such as competition strategy, product portfolio selection, and market entry planning.

From an analytics perspective, the tools used include **Excel**, **Power Query**, **SQL Server**, **Python**, and **Power BI**.  
All project materials and files are available in the GitHub repository.  
I hope you enjoy exploring this project!

## License
- **My code and analysis:** Licensed under the [MIT License](https://github.com/ai-artem-orlov/vehicle-sales-analysis/blob/main/LICENSE).  
- **Dataset:** Licensed under the [MIT License](https://www.mit.edu/~amini/LICENSE.md) by [Syed Anwar](https://www.kaggle.com/syedanwarafridi).
