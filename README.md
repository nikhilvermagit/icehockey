![](https://private-user-images.githubusercontent.com/60595515/294884577-962bb838-2f51-41ba-87e2-44def38f3968.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDQ3MTMzNjIsIm5iZiI6MTcwNDcxMzA2MiwicGF0aCI6Ii82MDU5NTUxNS8yOTQ4ODQ1NzctOTYyYmI4MzgtMmY1MS00MWJhLTg3ZTItNDRkZWYzOGYzOTY4LnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNDAxMDglMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjQwMTA4VDExMjQyMlomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTAwMmMwYzRmMGY3ZDU2ODNhMDgzZjIzM2RjYTQyZTQ4MDg5M2E1ZWJhZmNkODllNmJiNDU0Y2ZjMzQ0NWU0MTcmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0JmFjdG9yX2lkPTAma2V5X2lkPTAmcmVwb19pZD0wIn0.HUE3ervhfoUMHwIgJGlbAislxD6ggqzVwEEieutArTU)

# Women's Ice Hockey Performance Modeling and Strategic Insights Project

## Introduction

This repository contains the code and analysis for a sports analytics project focused on women's ice hockey. The analysis aims to identify key factors predicting a player's performance using data from the 2023 IIHF World Women's Championship.

## Executive Summary

Ice hockey is a fast-paced team sport, and our project specifically focuses on the 2023 IIHF World Women's Championship. The analysis involves regression models to understand the factors influencing player performance.

## Problem Statement

The main objective is to systematically identify and analyze the key factors that reliably predict a player's performance. This includes analyzing physical, skill-based, psychological, and strategic elements. The project aims to provide insights for data-driven decisions in ice hockey.

## Proposed Solution

We compiled a tidy dataset from publicly available data of the 2023 Women's Ice Hockey World Championship. The regression analysis helps identify the dependence of various variables on the player's performance. The resulting model provides insights for team strategizing and enhances understanding for fans.

## Data Sources

We collected data from various sources, including Quant Hockey Website, IIHF Official Website, and individual team statistics from Team USA, Team Canada, Team Sweden, and others. The dataset is available in [data.csv](data.csv).

## Limitations

The dataset has limitations, including a small sample size compared to other tournaments and the tournament structure having two parts (group stage and knockout), affecting match time and scoring opportunities.

## Analysis

### Exploratory Data Analysis

We performed exploratory data analysis to understand the distribution and relationships within the dataset. The correlation matrix, box plots, and scatter plots were used to analyze the variables.

### Regression Analysis

Regression models were constructed, and a stepwise regression strategy was employed to choose the optimal model. The final model explains a significant portion of the variance in the dependent variable, and predictor variables were evaluated for significance.

### Applications of the Model

We explored the business application of the model by simulating an increase in attacking strategy for each country, resulting in an average increase of 12.4% in aggregate points.

## How to Use This Repository

### Prerequisites

Before running the analysis, ensure that you have the necessary software and libraries installed:

1. R (version 4.0.0 or higher)
2. RStudio (optional but recommended)

### Getting Started

1. Clone the repository to your local machine:

```bash
git clone https://github.com/bevsxyz/ice-hockey-analysis.git
```

2. Open the Quarto file (`Group-1-Icehockey.qmd`) in RStudio.
3. Install the required R packages if not already installed:

```{R}
install.packages(c("tidyverse", "coefplot", "broom", "ppcor"))
```

4. Run the code chunks sequentially in the Quarto file.

## Conclusion

In this analysis, we developed a regression model to predict the average points scored by players in the 2023 IIHF World Women's Championship. The model incorporates various player-specific characteristics, such as position, country, height, weight, penalty duration, goal differential, shots on goal, age, shooting handedness, and total player time on ice.

### Key findings from the analysis include:

1. Country Significance: The country of the player significantly impacts their performance, with players from certain countries scoring higher on average.
2. Gameplay Factors: Goal differential, shots on goal, and duration of play are crucial factors positively associated with a player's average points.
3. Position Impact: While the player's position (forward or defenseman) showed a marginal significance, it suggests potential differences in how these positions contribute to scoring.
4. Recommendations for Enhanced Strategy: By simulating an increase in attacking strategy, as reflected by a 20% increase in shots on goal, the model predicts a substantial increase in overall points for each country.

This analysis provides valuable insights for coaches, teams, and players to make data-driven decisions for improving individual and team performance. The model's ability to predict the impact of changes in gameplay strategy opens avenues for refining team strategies and player performance to enhance overall competitiveness.

## Future Work

1. Data Enrichment: Explore additional sources of data to enrich the dataset, such as player-specific metrics, team dynamics, and contextual factors.
2. Advanced Models: Experiment with more advanced modeling techniques, such as machine learning algorithms, to capture complex relationships and interactions among variables.
3. Real-time Analytics: Implement real-time analytics to provide dynamic insights during live matches, enabling coaches to make strategic decisions based on evolving game scenarios.
4. Collaboration with Experts: Collaborate with hockey experts and practitioners to incorporate domain knowledge, ensuring a more nuanced and accurate model.
5. Player Development: Extend the analysis to focus on player development by identifying key attributes for young players aspiring to excel in women's ice hockey.

By addressing these aspects, the sports analysis project can evolve into a comprehensive tool for understanding, predicting, and improving women's ice hockey performance. The combination of data-driven insights and domain expertise holds the potential to revolutionize coaching strategies and contribute to the growth and development of the sport.

## Contributors

- Bevan Stanely @bevsxyz
- Nikhil Verma @nikhilvermagit
- Shantanu Sengupta @ShantanuSG
- Abhishek Kumar @abhishek2489
- Gubbala Hari Priya @hgubbala
- Lakshay Sharma @lakshaysharmabits
- Sunku Vydehi @svydehi
