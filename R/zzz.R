# R/zzz.R
.onAttach <- function(libname, pkgname) {
  activities <- readr::read_csv(
    system.file("extdata", "activities.csv", package = "cyclestats"),
    show_col_types = FALSE,
    col_select = c(1:7, 17),
    name_repair = "minimal"
  ) |>
    dplyr::rename(
      activity_id = "Activity ID",
      activity_datetime = "Activity Date",
      activity_name = "Activity Name",
      activity_type = "Activity Type",
      activity_distance = "Distance",
      activity_moving_time = "Moving Time"
    ) |>
    dplyr::filter(activity_type == "Ride") |>
    dplyr::select(activity_id, activity_datetime, activity_name,
                  activity_distance, activity_moving_time) |>
    dplyr::mutate(
      activity_moving_time = ifelse(activity_id == "2949643229", 3271, activity_moving_time),
      activity_id = as.character(activity_id),
      activity_date = as.Date(substr(activity_datetime, 1, 12), format = "%b %e, %Y"),
      activity_year = format(activity_date, "%Y"),
      activity_month = format(activity_date, "%m"),
      activity_year_month = format(activity_date, "%Y-%m"),
      activity_distance = round(activity_distance * 0.6214, 2),
      activity_avg_speed = round(activity_distance / (activity_moving_time / 3600), 2)
    ) |>
    dplyr::select(activity_id, activity_name, activity_datetime, activity_date,
                  activity_year, activity_month, activity_year_month,
                  activity_distance, activity_avg_speed)

  available_years <- sort(unique(activities$activity_year))

  activity_year_month_zero <- tidyr::expand_grid(
    activity_year = available_years,
    activity_month = sprintf("%02d", 1:12)
  ) |>
    dplyr::mutate(activity_year_month = paste(activity_year, activity_month, sep = "-")) |>
    dplyr::arrange(activity_year_month) |>
    dplyr::select(activity_year, activity_year_month)

  # These go straight into the global environment
  assign("activities", activities, envir = .GlobalEnv)
  assign("available_years", available_years, envir = .GlobalEnv)
  assign("activity_year_month_zero", activity_year_month_zero, envir = .GlobalEnv)

  packageStartupMessage("cyclestats data loaded - ", nrow(activities), " rides (",
                        paste(available_years, collapse = ", "), ")")
}
