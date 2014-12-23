library(dplyr)
library(ggvis)
library(shiny)

load("serial_data.rda")

shinyServer(function(input, output) {
    # Change the colour of the points when selected
    lb <- linked_brush(keys = 1:nrow(calls), "red")
    
    ttip <- function(x) {
        if (!is.null(x$min)) {
            with(calls[x$id, ], paste(min, "min", sec, "sec, tower", Name))
        }
    }
    
    # call timeline
    timeline <- ggvis(calls, x = ~ time, y = ~ Called, fill = ~ Called,
          size = ~ minutes, key := ~ id) %>%
        add_axis("x", title = "Time") %>%
        layer_points(size.brush := 400) %>%
        hide_legend("fill") %>%
        lb$input() %>%
        add_tooltip(ttip)
    
    # construct map
    basemap <- combined_map %>%
        filter(lat < 39.355 & lat > 39.24 & long < -76.595 & long > -76.84) %>%
        group_by(group, type) %>%
        ggvis(~ long, ~lat) %>% layer_paths(strokeOpacity := .15) %>%
        add_axis("x", title = "Longitude", grid = FALSE) %>%
        add_axis("y", title = "Latitude", grid = FALSE)
    
    # add places of interest
    desc <- function(x) {
        if (!is.null(x$location_id) && POI$Description[x$location_id] != "") {
            POI$Description[x$location_id]
        }
    }
    
    all_values <- function(x) {
        if(is.null(x)) return(NULL)
        paste0(names(x), ": ", format(x), collapse = "<br />")
    }
    
    map_POI <- basemap %>%
        add_data(data = POI) %>%  # places of interest
        layer_points(size := 8, key := ~ location_id) %>%
        layer_text(text := ~ Name, fontSize := 10) %>%
        add_tooltip(desc, "hover")
    
    # add cell towers
    cell_map <- map_POI %>%
        add_data(calls) %>%  # cell towers
        layer_points(shape := "cross", fill := "gray", size = 8) %>%
        layer_points(fill = ~ Called, data = reactive(calls[lb$selected(), ]))
    
    bind_shiny(timeline, "timeline")
    bind_shiny(cell_map, "map")
})
