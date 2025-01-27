#' KVFinderWebPortal User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinyjs
#' @import bs4Dash
#' @import NGLVieweR
#' @import golem
#' @import shinycssloaders
#' @import shinyfullscreen
#' @noRd
#'

app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # ____________________________________________________________
    dashboardPage(
      # Header----------------------------------------------------
      header = dashboardHeader(
        title = "KVFinder-web",
        titleWidth = NULL,
        disable = FALSE,
        .list = NULL,
        skin = "light",
        status = "white",
        border = TRUE,
        compact = FALSE,
        sidebarIcon = shiny::icon("bars"),
        controlbarIcon = shiny::icon("th"),
        fixed = FALSE,
        leftUi = NULL,
        rightUi = NULL
      ),
      # Sidebar--------------------------------------------------
      sidebar = dashboardSidebar(
        disable = FALSE,
        width = NULL,
        skin = "dark",
        status = "primary",
        elevation = 4,
        collapsed = FALSE,
        minified = TRUE,
        expandOnHover = TRUE,
        fixed = TRUE,
        id = "sidebar",
        customArea = NULL,

        # sidebar menu
        sidebarMenu(
          id = "sidebarmenu",
          menuItem(
            "Run Cavity Analysis",
            tabName = "run_kv_sidebar",
            icon = icon("angle-double-right")
          ),
          menuItem(
            "Retrieve results",
            tabName = "check_kv_sidebar",
            icon = icon("angle-double-right")
          ),
          menuItem(
            "Tutorial",
            tabName = "tutorial_kv_sidebar",
            icon = icon("question-circle")
          ),
          menuItem(
            "Help",
            tabName = "help_kv_sidebar",
            icon = icon("question-circle")
          ),
          menuItem(
            "About",
            tabName = "about_kv_sidebar",
            icon = icon("info-circle")
          )
        )
      ),

      # Dashboard body-----------------------------------------------
      body = dashboardBody(
        useShinyjs(),
        tabItems(
          # 1st tab: Run KVFinder-web
          tabItem(
            tabName = "run_kv_sidebar",
            # Create jumbotron
            create_jumbotron(),
            #-------------------------------------------
            # Choose input card
            fluidRow(column(
              12,
              choose_input()
            )),
            #------------------------------------------
            # Choose run mode card
            fluidRow(column(
              12,
              choose_run_mode(),
            )),
            #-------------------------------------------
            # Submit section
            column(
              12,
              align = "center",
              actionButton(
                "submit_button",
                "Submit the job",
                icon = icon("arrow-circle-right"),
                gradient = FALSE,
                outline = FALSE,
                size = "lg",
                flat = TRUE
              ),
              htmlOutput("run_id"),
              uiOutput("check_results_submit")
            ),
            tags$br(),
            #--------------------------------------------
            # Result section
            fluidRow(
              column(
                5,
                uiOutput("output_status1"),
                tags$br(),
                fluidRow(
                  column(
                    4,
                    uiOutput("download")
                  ),
                  column(
                    4,
                    uiOutput("download2")
                  ),
                  column(
                    4,
                    uiOutput("view_output")
                  )
                ),
                tags$br(),
                uiOutput("results_table"),
                tags$br(),
                htmlOutput("table_footer")
              ),
              column(
                7,
                # function to fulscreen the entire div that contains the NGL viewer and all the othe buttons
                fullscreen_this(tags$div(
                  id = "view_panel",
                  fluidRow(
                    column(
                      12,
                      NGLVieweROutput("structure", width = "100%", height = "75vh")
                    )
                  ),
                  conditionalPanel(
                    condition = "input.input_cavity_hyd==1",
                    fluidRow(
                      column(12,
                        align = "center",
                        uiOutput(outputId = "scale_plot")
                      )
                    )
                  ),
                  conditionalPanel(
                    condition = "input.input_cavity_deep==1",
                    fluidRow(
                      column(12,
                        align = "center",
                        plotOutput("scale_plot_deep", height = 60, width = "60%"),
                        tags$head(
                          tags$style(
                            HTML(
                              "#scale_plot_deep { max-width: 600px; align: center; }"
                            )
                          )
                        )
                      )
                    )
                  ),
                  fluidRow(
                    column(2, uiOutput("selection_pdb")),
                    column(2, uiOutput("cavity_rep")),
                    column(2, uiOutput("cavity_color")),
                    column(2, div(style = "display: inline-block; vertical-align: -20px;", uiOutput("cavity_deep"))),
                    column(2, div(style = "display: inline-block; vertical-align: -20px;", uiOutput("cavity_hyd"))),
                    column(2, div(style = "display: inline-block; vertical-align: -20px;", uiOutput("show_interface"))),
                  ),
                  fluidRow(
                    column(2, uiOutput("protein_rep")),
                    column(2, uiOutput("protein_color")),
                    column(3, uiOutput("protein_color_scheme")),
                    column(2, uiOutput("bg_color")),
                    column(2, align = "center", uiOutput("snapshot_title"), uiOutput("snapshot")),
                    column(1, align = "center", uiOutput("fullscreen_title"), uiOutput("fullscreen"))
                  ),
                ), click_id = "fullscreen")
              )
            )
          ),

          # 2nd tab: Get latest results
          tabItem(
            tabName = "check_kv_sidebar",
            fluidRow(
              column(
                5,
                bs4Card(
                  title = "Get latest results",
                  id = "check_results_box",
                  collapsible = TRUE,
                  collapsed = FALSE,
                  closable = FALSE,
                  solidHeader = TRUE,
                  elevation = 2,
                  headerBorder = TRUE,
                  width = 12,
                  textInput(
                    inputId = "insert_ID",
                    label = "Insert the job ID to get results",
                    placeholder = "ID number"
                  ),
                  actionButton(
                    inputId = "check_loc_pg2",
                    label = "Get results",
                    icon = icon("share-square")
                  ),
                  tags$br(),
                  tags$br(),
                  uiOutput("output_status_pg2"),
                  fluidRow(
                    column(
                      4,
                      uiOutput("download_pg2")
                    ),
                    column(
                      4,
                      uiOutput("download2_pg2")
                    ),
                    column(
                      4,
                      uiOutput(
                        "view_output_pg2"
                      )
                    )
                  ),
                  tags$br(),
                  uiOutput("results_table_pg2"),
                  tags$br(),
                  sidebar = boxSidebar(
                    id = "help_get_results_pg2",
                    icon = icon("info"),
                    p("Here, you can insert a job ID to get or check your latest results.")
                  )
                )
              ),
              column(
                7,
                fullscreen_this(tags$div(
                  id = "view_panel_pg2",
                  fluidRow(
                    NGLVieweROutput("structure_pg2", width = "100%", height = "600px")
                  ),
                  conditionalPanel(
                    condition = "input.input_cavity_hyd_pg2==1",
                    fluidRow(
                      column(12,
                        align = "center",
                        uiOutput(outputId = "scale_plot_pg2")
                      )
                    )
                  ),
                  conditionalPanel(
                    condition = "input.input_cavity_deep_pg2==1",
                    fluidRow(
                      column(12,
                        align = "center",
                        plotOutput("scale_plot_deep_pg2", height = 60, width = "60%"),
                        tags$head(
                          tags$style(
                            HTML(
                              "#scale_plot_deep_pg2 { max-width: 600px; align: center; }"
                            )
                          )
                        )
                      )
                    )
                  ),
                  fluidRow(
                    column(2, uiOutput("selection_pdb_pg2")),
                    column(2, uiOutput("cavity_rep_pg2")),
                    column(2, uiOutput("cavity_color_pg2")),
                    column(2, div(style = "display: inline-block; vertical-align: -20px;", uiOutput("cavity_deep_pg2"))),
                    column(2, div(style = "display: inline-block; vertical-align: -20px;", uiOutput("cavity_hyd_pg2"))),
                    column(2, div(style = "display: inline-block; vertical-align: -20px;", uiOutput("show_interface_pg2"))),
                  ),
                  fluidRow(
                    column(2, uiOutput("protein_rep_pg2")),
                    column(2, uiOutput("protein_color_pg2")),
                    column(3, uiOutput("protein_color_scheme_pg2")),
                    column(2, uiOutput("bg_color_pg2")),
                    column(2, align = "center", uiOutput("snapshot_title_pg2"), uiOutput("snapshot_pg2")),
                    column(1, align = "center", uiOutput("fullscreen_title_pg2"), uiOutput("fullscreen_pg2"))
                  )
                ), click_id = "fullscreen_pg2")
              )
            )
          ),

          # 3rd tab: Tutorial page
          tabItem(
            tabName = "tutorial_kv_sidebar",
            kv_tutorial()
          ),

          # 4th tab: Help page
          tabItem(
            tabName = "help_kv_sidebar",
            kv_help()
          ),

          # 5th tab: About page
          tabItem(
            tabName = "about_kv_sidebar",
            kv_about()
          )
        )
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
#'
#'

golem_add_external_resources <- function() {
  add_resource_path("www", app_sys("app/www"))
  tags$head(
    tags$link(
      rel = "shortcut icon",
      href = "www/kvfinder-web.ico"
    ),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "KVFinder-web"
    )
  )
}
