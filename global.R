library(shiny)
library(bslib)
library(dplyr)
library(tidyr)

# global ------------------------------------------------------------------

get_date_start_city <- function() {
  as.character(lubridate::int_start(jpcity:::graph_city$interval_city))
}

get_date_end_city <- function() {
  as.character(lubridate::int_end(jpcity:::graph_city$interval_city))
}

get_merger <- function(from, to, merge_city_desig, only_changed) {
  from <- as.character(from)
  to <- as.character(to)

  city_from <- jpcity::get_city(from)
  if (merge_city_desig) {
    city_from <- city_from |>
      jpcity::city_desig_merge() |>
      unique()
  }

  city_to <- jpcity::city_convert(city_from, from, to)

  tibble(from = city_from,
         to = city_to) |>
    unnest(to) |>
    mutate(across(c(from, to),
                  jpcity::city_data)) |>
    tidyr::unpack(c(from, to),
                  names_sep = "_") |>
    filter(!only_changed |
             n() > 1 | # 分離
             from_city_code != to_city_code, # 前後でコードが異なる
           .by = from_city_code) |>
    unite("from_city_name", from_city_desig_name, from_city_name,
          sep = " ",
          na.rm = TRUE) |>
    unite("from_city_name_kana", from_city_desig_name_kana, from_city_name_kana,
          sep = " ",
          na.rm = TRUE) |>
    unite("to_city_name", to_city_desig_name, to_city_name,
          sep = " ",
          na.rm = TRUE) |>
    unite("to_city_name_kana", to_city_desig_name_kana, to_city_name_kana,
          sep = " ",
          na.rm = TRUE)
}
