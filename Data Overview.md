# Data Overview of ACLED and IDP 
## 1. IDP Overlay of DRC
<img width="500" alt="image" src="https://github.com/user-attachments/assets/6249cd1b-4aca-48b3-b090-b497690d57e1" />

This heatmap shows that the highest concentration of IDPs is located in the eastern provinces of the DRC, such as North Kivu and South Kivu, characterized by persistent conflict and insecurity, which are primary drivers of displacement.

This finding can otherly be demonstrated using the line graph showing that the data for IDPs were most consistent in Ituri, North, and South Kivu, showing that the overlay DRC is more concentrated in the east due to the amount of data concentrated from the Eastern region. 

(graph created using generative AI)

<img width="700" alt="image" src="https://github.com/user-attachments/assets/caf55c26-94e7-4b6e-9132-b66483ce9dc1" />

(map from the IOM report)

<img width="500" alt="image" src="https://github.com/user-attachments/assets/c9f611e6-a064-43e5-b91a-9a7dec738341" />


According to the IDP Democratic Republic of the Congo Internal Displacement Report published by IOM in August 2024, the three main drivers of displacements are: 
(1) Conflict and Insecurity: 87% of internally displaced persons (IDPs) were forced to leave their homes due to armed conflict and general insecurity, particularly in the eastern provinces of North Kivu, South Kivu, Ituri, and Tanganyika.
Major drivers include attacks by armed groups, inter-community violence, and instability from militant activities like the M23 Crisis.

(2) Natural Disasters: 13% of displacements were due to natural disasters, such as flooding, landslides, and other environmental hazards, particularly in provinces like Haut-Lomami, Tshopo, and Equateur.

(3) Other Causes: Less than 1% of displacement was attributed to disease outbreaks or health-related crises.

## 2. ACLED Heatmap of DRC 

<img width="800" alt="image" src="https://github.com/user-attachments/assets/c593e88f-abab-4dbc-b4fd-61091f70f4ad" />
http://127.0.0.1:3098


## 3. IDP, ACLED Correlation

<img width="500" alt="image" src="https://github.com/user-attachments/assets/6ea7a7cb-211e-4a6a-ba8d-db0b0b8e1f68" />

Pearson's product-moment correlation

data:  merged_data_clean$event_count and merged_data_clean$total_idps
t = 7.0145, df = 70, p-value = 1.175e-09
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval: 0.4826390 0.7608889
sample estimates: cor 0.6424714 

## 4. Time Series Analysis

<img width="500" alt="image" src="https://github.com/user-attachments/assets/2f538167-fc79-46bd-940e-3292ee0fd582" />


<img width="500" alt="image" src="https://github.com/user-attachments/assets/9e2708fe-c314-4172-a624-ce46a7cb5516" />

Findings: both total number of internally displaced people and the number of conflicts is closely related to the observation at the t-1 (the month before) timestamp. 


