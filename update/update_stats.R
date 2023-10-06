library(nblscrapeR)
library(dplyr)
library(purrr)
library(jsonlite)

# results_wide <- readRDS(url("https://github.com/JaseZiv/nblr_data/releases/download/match_results/results_wide.rds"))
# results_wide <- results_wide %>% select(match_id, season)

current_season <- "2023-2024"

games <- readRDS(url("https://github.com/JaseZiv/nblr_data/releases/download/match_lists/match_lists_2023_24.rds"))

#==========================================================================
# Play-by-Play ------------------------------------------------------------

# get current
pbp_df <- nblscrapeR::parse_pbp(games)
pbp_df <- pbp_df |> 
  mutate(s1 = as.integer(s1),
         s2 = as.integer(s2))

# get all existing
pbp_all <- nblR::nbl_pbp()

# filter out the new
pbp_previous <- pbp_all %>% filter(season != current_season)

# then add back in the new
pbp_df <- bind_rows(pbp_previous, pbp_df)

# save if there has not been any issues with the data parsing/scraping
if(nrow(pbp_df) >= nrow(pbp_all)) {
  #save_nblr(df=pbp_df, file_name = "pbp", release_tag = "pbp")
  # write.csv2(pbp_df, file = "pbp.csv", row.names = TRUE, fileEncoding = "UTF-8")
  json_data <- toJSON(pbp_df, pretty = TRUE)
  file_path <- "pbp_df.json"
  write(json_data, file_path)
} else {
  print("Something has gone wrong with the parsing of play by play data")
}

# also want a process that writes the current season's pbp data for the win probability app


rm(pbp_df, pbp_all, pbp_previous);gc()


#==========================================================================
# Player Box Scores -------------------------------------------------------

# get current
player <- nblscrapeR::parse_player_box(games)

# get all existing
player_all <- nblR::nbl_box_player()

# filter out the new
player_previous <- player_all %>% filter(season != current_season)

# then add back in the new
player <- bind_rows(player_previous, player)

# save if there has not been any issues with the data parsing/scraping
if(nrow(player) >= nrow(player_all)) {
  # save_nblr(df=player, file_name = "box_player", release_tag = "box_player")
  # write.csv2(player, file="box_player.csv")
  json_data <- toJSON(player, pretty = TRUE)
  file_path <- "box_player.json"
  write(json_data, file_path)
  
} else {
  print("Something has gone wrong with the parsing of player box data")
}

rm(player, player_all, player_previous);gc()

#==========================================================================
# Team Box Scores ---------------------------------------------------------

# get current
team_box <- nblscrapeR::parse_team_box(games)

# get all existing
team_all <- nblR::nbl_box_team()

# filter out the new
team_previous <- team_all %>% filter(season != current_season)

# then add back in the new
team_box <- bind_rows(team_previous, team_box)

if(nrow(team_box) >= nrow(team_all)) {
  # save_nblr(df=team_box, file_name = "box_team", release_tag = "box_team")
  # write.csv2(team_box, file="box_player.csv")
  json_data <- toJSON(team_box, pretty = TRUE)
  file_path <- "team_box.json"
  write(json_data, file_path)
} else {
  print("Something has gone wrong with the parsing of team box data")
}


rm(team_box, team_all, team_previous);gc()


#==========================================================================
# Match Shots -------------------------------------------------------------

# get current
shots <- nblscrapeR::parse_match_shot(games)

# get all existing
shots_all <- nblR::nbl_shots()

# filter out the new
shots_previous <- shots_all %>% filter(season != current_season)

# then add back in the new
shots <- bind_rows(shots_previous, shots)

if(nrow(shots) >= nrow(shots_all)) {
  #save_nblr(df=shots, file_name = "shots", release_tag = "shots")
  write.csv2(shots, file="shots.csv")
} else {
  print("Something has gone wrong with the parsing of shots data")
}

rm(shots, shots_previous, shots_all);gc()


