source("global.R")

# ui ----------------------------------------------------------------------

# https://stackoverflow.com/questions/78344439/shinylive-wont-allow-downloading-data-tables-as-csv-files
# Workaround for Chromium Issue 468227
downloadButton <- function(...) {
  tag <- shiny::downloadButton(...)
  tag$attribs$download <- NULL
  tag
}

ui <- page_sidebar(
  title = "jpcity App",
  sidebar = sidebar(
    width = 400,
    accordion(
      accordion_panel(
        "市区町村コードの変遷（廃置分合等情報）",
        dateRangeInput(
          "merger_date_range",
          label = "期間",
          start = get_date_start_city(),
          end = get_date_end_city(),
          min = get_date_start_city(),
          max = get_date_end_city(),
          language = "ja",
          separator = "～"
        ),
        checkboxInput(
          "merger_merge_city_desig",
          label = "政令指定都市の区を除く",
          value = TRUE
        ),
        checkboxInput(
          "merger_only_changed",
          label = "コードが変更した市区町村のみ（分離含む）",
          value = TRUE
        ),
        actionButton("merger_show", "データ表示"),
        downloadButton("merger_download", "ダウンロード")
      )
    ),
  ),
  DT::dataTableOutput("merger_table")
)
