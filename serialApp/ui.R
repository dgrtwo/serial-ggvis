library(ggvis)
library(shiny)

shinyUI(bootstrapPage(
    wellPanel(ggvisOutput("timeline"),
              HTML("Timeline of calls on Adnan Syed's phone on 1/13/1999. Click and drag over multiple calls to highlight, on the map below, the cell towers that handled those calls.")),
    ggvisOutput("map"),
    HTML("Map of Baltimore and Baltimore County. Notable locations are labeled (mouse over for details), along with locations of cell towers (gray crosses)."),
    wellPanel(HTML("This visualization was constructed using Shiny and ggvis in R: see <a href='http://varianceexplained.org/r/serial-ggvis/'>here</a> for details and code.")),
    title = "Visualizing the phone calls of Serial"
))
