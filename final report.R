library(tidyverse)
library(knitr)
library(coefplot)
library(corrplot)
library(broom)
# Read and tidy data
df = read_csv("data.csv")

df |> map_chr(type_sum) |>
  as_tibble_row() |>
  pivot_longer(everything()) |>
  count(value) |> kable()

# Drop since they are related to the dependent variable
df = df |> select(!c(games_played_gp,goals_g, assists_a, points))
# Convert duration to seconds
df = df |>  mutate(total_minutes_as_duration =
                     as.numeric(total_minutes_as_duration, unit = "secs")) |>
  # Rename some columns for easier analysis
  rename(
    avg_points = points_per_game_ppg,
    penalty_dur = penalties_in_minutes_pim,
    duration = total_minutes_as_duration,
    g_diff = plus_minus_goal_differential,
    sog = shots_on_goal_sog
  )

#| label: tbl-stat-summary
#| echo: false
#| tbl-cap: "Statistical Summary of Numerical Columns"
#| tbl-colwidths: [60,40]
df |> summarise(across(
  where(is.numeric),
  .names = "{.col}-{.fn}",
  .fns = list(
    min = min,
    median = median,
    mean = mean,
    stdev = sd,
    q25 =  ~ quantile(., 0.25),
    q75 =  ~ quantile(., .75),
    max = max
  )
)) |>
  pivot_longer(everything(),
               names_sep = '-',
               names_to = c('variable', '.value')) |> 
  kable()

#| label: corr-functions
#| echo: false
# Calculate correlation matrix
df.corr <- function(df) {
  df = df |>  select(where(is.numeric)) |>  cor()
  mrows <<- rownames(df)
  # Convert the matrix output to tibble dataframe
  
  df = df |>
    as_tibble(rownames = "var_1") |>
    gather(key = "var_2", value =
             "cor",-1) |> drop_na()
  return(df)
}

# Correlation Plotting Function
plot.corr <- function(df){
  # Plot correlation heatmap
  ggplot(df.corr(df), aes(var_1, var_2, fill = cor, label = round(cor, 2))) +
    theme(axis.text.x = element_text(
      angle = 90,
      vjust = 0.5,
      hjust = 1
    ),
    axis.title = element_blank(),
    ) +
    geom_tile() + ylim(mrows) + xlim(rev(mrows)) +
    geom_text(color = "white") +
    labs(fill = "Correlation")
}
#| label: fig-corr-1
#| fig-width: 8
#| fig-height: 8
#| fig-cap: "Correlation Matrix of all the Variables"
plot.corr(df)

#| label: fig-scatter-1
#| fig-cap: "The figure shows the relationship between the each numeric independent variable with the dependent variable average points."
#| fig-width: 10
#| fig-height: 10
#| warning: false
df |> select(where(is.numeric)) |>
  gather(yvar, val,-avg_points) |>
  ggplot(aes(val, avg_points)) +
  geom_point() +
  stat_smooth(geom = "smooth") +
  facet_wrap(yvar ~ ., ncol = 3, scales = "free_x") +
  labs(x = "Numeric Independent Variables", y = "Average Points(DV)", title =
         "IV vs DV Scatter Plot")

#| label: tbl-outlier
df |> select(Name, country, duration) |>
  filter(duration == max(duration)) |>
  kable()

{r}
#| label: fig-replace-outlier
#| fig-cap: Duration vs Average Points scatter plot after replacing the outlier.
df = df |> mutate(duration = replace(duration,
                                     Name == "Emma Ingold",
                                     as.numeric(
                                       as.difftime("01:30:24",
                                                   format = "%H:%M:%S",
                                                   units = "secs")
                                     )))
df |> select(avg_points, duration) |>
  ggplot(aes(duration, avg_points)) +
  geom_point() +
  stat_smooth(geom = "smooth") +
  labs(x="Total Player time in Seconds", y="Average Points(DV)")

#| label: fig-corr-2
#| fig-width: 8
#| fig-height: 8
#| fig-cap: "Correlation Matrix after fixing the outlier"
# Plot correlation heatmap
plot.corr(df)

#| label: fig-boxplot-1
#| fig-cap: "The figure illustrates the connection between the categorical independent variables and the dependent variable's average points via box plots. Of the three IVs, country, position, and shoot, country seems to be the most informative."
#| fig-width: 15
#| fig-height: 10
#| warning: false
df |> select(-where(is.numeric), -Name, avg_points) |>
  gather(yvar, val,-avg_points) |>
  ggplot(aes(reorder(val, avg_points), avg_points, fill = val)) +
  geom_boxplot() +
  facet_wrap(yvar ~ ., ncol = 2, scales = "free_x") +
  theme(legend.position = "none") +
  labs(x = "Categorical Independent Variables", y = "Average Points(DV)", title =
         "IV vs DV Box Plot")

#| label: mlr
nullModel = lm(avg_points ~ 1, data=df)
# the largest model we will accept
fullModel1 = lm(avg_points ~ ., data = df |> select(-Name)) # All variables
fullModel2 = lm(avg_points ~ ., data = df |> select(-c(Name, position, country, shoot))) # All numeric variables
fullModel3 = lm(avg_points ~ . ^ 2, data = df |> select(-Name)) # All variables with all combinations of interaction
#2nd interations in model 3
#| output: false
#| warning: false
model = lapply(list(fullModel1, fullModel2, fullModel3), function(x)
  step(
    x,
    scope = list(lower = nullModel, upper = x),
    direction = "forward"
  ))

#| label: model-summary
model_residual = lapply(model,fortify)
lapply(model,function(x)x$call)

multiplot(model[1:2])

{r}
#| label: tbl-summary-parameters
model_summary = lapply(1:3, function(x)
  glance(model[[x]]) |>
    pivot_longer(everything(),names_to = "Parameter", values_to = as.character(x)))
model_summary[[1]] |>
  left_join(model_summary[[2]]) |>
  left_join(model_summary[[3]]) |> 
  kable()

#| label: tbl-summary-coefficients
tidy(model[[1]]) |> mutate(signific = case_when(
  between(p.value, 0.05, 0.1) ~ '.',
  between(p.value, 0.01, 0.05) ~
    '*',
  between(p.value, 0.001, 0.01) ~
    '**',
  between(p.value, 0, 0.001) ~
    '***',
  TRUE ~ ""
)) |> mutate_if(is.numeric,  ~
                  round(.x, digits = 4)) |> 
  kable()

#| label: fig-residual-plot
#| fig-cap: The scatter plots of the residual vs. fitted value for the three models. There is heteroscedasticity in all three figures
#| warning: false
#| fig-width: 10
#| fig-height: 10

m.res = lapply(model_residual, function(x) x |> select(.fitted, .stdresid))
model_residual_final = m.res[[1]] |> mutate(model=1) |> add_row(m.res[[2]] |> mutate(model=2)) |> add_row(m.res[[3]] |> mutate(model=3))
model_residual_final |>
  ggplot(aes(x = .fitted, y = .stdresid)) +
  geom_point() +
  geom_hline(yintercept = 0) +
  stat_smooth(geom = "smooth") +
  labs(x = "Fitted Values", y = "Residuals", color="Country") +
  facet_wrap(model~.,ncol = 1 )

{r}
#| label: fig-redsidual-facet
#| warning: false
#| fig-width: 10
#| fig-height: 10
model_residual[[1]] |>
  ggplot(aes(x = .fitted, y = .resid)) +
  geom_point() +
  geom_hline(yintercept = 0) +
  geom_smooth(se = FALSE) +
  labs(x = "Fitted Values", y = "Residuals") +
  facet_wrap(. ~country, scales = "free_x", ncol = 3)

{r}
#| label: fig-qq-facet
#| warning: false
#| fig-width: 10
#| fig-height: 10
model_residual_final |> 
  ggplot(aes(sample=.stdresid)) +
  stat_qq() +
  geom_abline() +
  facet_wrap(model~.,ncol = 2 )

{r}
#| label: tbl-spcor
ppcor::spcor(df |> select_if(is.numeric), method = "pearson")$estimate |>
  as_tibble(rownames="rowname")|> 
  filter(rowname == "avg_points") |>  select("g_diff","sog","duration") |> kable()

{r}
top_10 = df |> top_frac(.10, avg_points) |> arrange(desc(avg_points))
#top_10 = df |> mutate(marker = as.numeric(Name %in% tail(Name[order(avg_points)], 20))) |> arrange(desc(avg_points))
plot.corr(top_10)

{r}
lm(avg_points ~ position + sog+log(duration)+country, data= top_10) |> summary()
