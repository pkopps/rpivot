#' pivottable.js in R
#'
#' Use pivottable.js in R with the power and convenience of a
#' htmlwidget.
#'
#' @param data data.frame or data.table (R>=1.9.6 for safety) with data to use in the pivot table
#' @param rows String name of the column in the data.frame to prepopulate
#'              the \strong{rows} of the pivot table.
#' @param cols String name of the column in the data.frame to prepopulate
#'              the \strong{columns} of the pivot table.
#' @param aggregator String name of the pivottable.js aggregator from pivotUtilities to prepopulate the pivot table.
#' @param vals String name of the column in the data.frame to use with \code{aggregatorName}. Must be additive (i.e a number).
#' @param rendererName List name of the renderer selected, e.g. Table, Heatmap, Treemap etc.
#' @param sorter String name this allows to implement a javascript function to specify the ad hoc sorting of certain values. See vignette for an example.
#'              It is especially useful with time divisions like days of the week or months of the year (where the alphabetical order does not work).
#' @param width width parameter
#' @param height height parameter
#' 
#' @param ... list other \href{https://github.com/nicolaskruchten/pivottable/wiki/Parameters}{parameters} that
#'            can be passed to \code{pivotUI}. See Nicolas's Wiki for more details.
#'            A further example of parameter is onRefresh. This parameters (shiny-only) introduces a JS function that allows to get back server side the list of parameters selected by the user.
#'            An example is: onRefresh=htmlwidgets::JS("function(config) { Shiny.onInputChange('myPivotData', config); }")
#'            This setting makes available server-side a function input$myPivotData that gives back a list (of lists) with all the slice & dice parameters offered by pivottable.
#'            See the example onRefresh-shiny.R for an example of how to use this feature.  
#'            Example of usage could be:
#'            These parameters could be saved and re-sent to the user.
#'            Alternative they could be used to subset the data item for saving as csv.
#'              
#' @examples 
#' 
#'  # use Titanic dataset provided in base R - simple creation with just data
#'
#'  rpivot( Titanic ) 
#'
#'  # prepopulate multiple columns and multiple rows
#'  
#'  rpivot( Titanic, rows = c("Class","Sex"), cols = c("Age","Survived" ) )
#'  
#'  
#'  # A more complete example:
#'  
#'  rpivot(
#'  Titanic,
#'  rows = "Survived",
#'  cols = c("Class","Sex"),
#'  aggregatorName = "Sum as Fraction of Columns",
#'  vals = "Freq",
#'  rendererName = "Table Barchart"
#'  )
#'
#'
#' @import htmlwidgets
#'
#' @export

rpivot <- function(
    data,
    rows = NULL,
    cols = NULL,
    funct = NULL, #agg
    vals = NULL, #agg
    renderer = NULL,
    numberFormat = NULL,
    # aggregatorName = NULL,
    # rendererName = NULL,
    sorter = NULL,
    width = NULL,
    height = NULL,
    ...
) {
  # check for data.frame, data.table, or array
  if( length(intersect(class(data),c("data.frame", "data.table", "table","structable", "ftable" ))) == 0 ) {
    stop( "data should be a data.frame, data.table, or table", call.=F)
  }
  
  #convert table to data.frame
  if( length(intersect(c("table","structable", "ftable"), class(data))) > 0 ) data <- as.data.frame( data )

    params <- list(
      rows = rows,
      cols = cols,
      renderer = renderer,
      numberFormat = numberFormat,
      funct = funct, #agg
      vals = vals, #agg
      # aggregatorName = aggregatorName,
      # rendererName = rendererName,
      sorter = sorter,
      ...
    )
    
# auto_box vectors of length 1

    params <- Map( function(p){
        if(length(p) == 1 ){
          p = list(p)
        }
        return(p)
      }
      , params
    )
    
# exlusions & inclusions need to be "excluded" from auto_boxing
#    par <- list(
#           exclusions = exclusions,
#           inclusions = inclusions 
#         )

# params <- c(params, par)

    # remove NULL parameters
    params <- Filter(Negate(is.null), params)
    
    x <- list(
      data = data,
      params = params
    )

    htmlwidgets::createWidget(
      name = 'rpivot',
      x,
      width = width,
      height = height,
      sizingPolicy = htmlwidgets::sizingPolicy(
        knitr.figure = FALSE,
        knitr.defaultHeight = '100%'
        ),
      package = 'rpivot',

    )
}

#' Widget output function for use in Shiny
#'
#' @param outputId Shiny output ID
#' @param width width default '100\%'
#' @param height height default '500px'
#' 
#' @examples 
#' 
#'   # A simple example - this goes in the ui part of a shiny application
#'   
#'   # rpivotTableOutput("pivot")
#' 
#' 
#' @export
rpivotOutput <- function(outputId, width = '100%', height = '500px'){
    shinyWidgetOutput(outputId, 'rpivot', width, height, package = 'rpivot')
}

#' Widget render function for use in Shiny
#'
#' @param expr rpivotTable expression
#' @param env environment
#' @param quoted logical, default = FALSE
#' 
#' @examples 
#' 
#'   # A simple example - this goes in the server part of a shiny application
#'   
#'   # output$pivot <- renderRpivotTable({
#'   #          rpivotTable(data =   canadianElections   ,  rows = c( "Province"),cols="Party",
#'   #          vals = "votes", aggregatorName = "Sum", rendererName = "Table",
#'   #          width="100%", height="500px")
#'   # })
#' 
#' 
#' 
#' @export
renderRpivot <- function(expr, env = parent.frame(), quoted = FALSE) {
    if (!quoted) { expr <- substitute(expr) } # force quoted
    shinyRenderWidget(expr, rpivotOutput, env, quoted = TRUE)
}


NULL
