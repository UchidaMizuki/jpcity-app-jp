source("global.R")

# server ------------------------------------------------------------------

server <- function(input, output) {
  reactive_merger <- reactive({
    get_merger(from = input$merger_date_range[[1]],
               to = input$merger_date_range[[2]],
               merge_city_desig = input$merger_merge_city_desig,
               only_changed = input$merger_only_changed)
  })

  output$merger_table <- DT::renderDataTable(reactive_merger(),
                                             options = list(pageLength = 15)) |>
    bindEvent(input$merger_show)

  output$merger_download <- downloadHandler(
    filename = function() {
      from <- input$merger_date_range[[1]]
      to <- input$merger_date_range[[2]]

      stringr::str_glue("merger_{from}_{to}.csv")
    },
    content = function(file) {
      write.csv(reactive_merger(), file)
    }
  )
}
