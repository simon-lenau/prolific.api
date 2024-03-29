#' Prolific prescreening requirement
#'
#' @name prolific_prescreener
#' @aliases prolific_prescreener-class prescreeners prescreener prescreening screening eligibility_requirements requirements
# @aliases prolific_prescreener-class prescreeners prescreener prescreening screening eligibility_requirements requirements
#'
#' @description
#' Class that represents prescreening requirements to characterize the participants to be selected for a certain \code{\link[=prolific_study]{study on Prolific}},
#' i.e. the persons to be recruited via Prolific.
#' \code{\link[=prolific_prescreener]{prolific_prescreener objects}} are therefore mainly used in the
#' \code{\link[=prolific_study]{eligibility_requirements}} field of \code{\link[=prolific_study]{prolific_studys}}.\cr
#' \emph{The fields and methods are available as in RefClass or S4 objects (see examples).}
#'
#' The section \emph{'Setting up prescreeners for Prolific'} below provides an overview and examples of how to specify prescreening requirements.
#'
#' @field title (\code{\link[=character]{character}}):\cr
#' A \emph{valid} title for a single prescreener that is available on the Prolific platform.
#' To be valid, this title \emph{must} appear in the list of prescreeners obtainable from the \href{https://docs.prolific.co/docs/api-docs/public/}{Prolific API}.\cr
#' See the section \emph{'Setting up prescreeners for Prolific'} as well as the \href{../doc/prolificapi-package.html}{prolific.api package vignette}.
#'
#' @field constraints (\code{\link[=list]{list}}):\cr
#' The \emph{valid} constraints for this particular prescreener.\cr
#' When creating a \code{\link[=prolific_prescreener]{prolific_prescreener object}},
#' an arbitrary number of constraints can be specified using \code{\link[=dots]{named or unnamed custom arguments}}.
#' In the \strong{named} case,
#' \preformatted{       name_1 = value_1,...,name_i = value_i,}
#' \code{name = value} pairs are used to set the constraints and values.
#' Using the \strong{unnamed} case
#' \preformatted{       name_1,...,name_i}
#' allows to ommit the values for prescreeners where \code{value_1 = \dots = value_i = TRUE}. In that way, users can simply provide the names of the groups to be recruited.
#' See the section \emph{'Setting up prescreeners for Prolific'} as well as the \emph{examples} and \href{../doc/prolificapi-package.html}{prolific.api package vignette}.
#'
#'
#'
#' @description
#' # Setting up prescreeners for Prolific
#'
#' Prescreeners are used to select participants for a \code{\link[=prolific_study]{prolific_study}} that meet certain characteristics.
#' In most cases, this selection is done with regard to the answers the participants gave in a survey conducted by Prolific across all its members.
#'
#'
#' ## Choosing a prescreening variable
#' At the moment, there are \code{265} variables which can be used to recruit specific subgroups from Prolific.
#' To obtain a list of all available prescreening variables, use
#' \preformatted{
#'           table_of_prescreeners <-
#'                     prescreeners(prolific_api_access)
#' }
#' where \code{prolific_api_access} is an \code{\link[=api_access]{api_access object}} with a valid \code{\link[=api_access]{api_token}}.
#'
#' A prescreening variable is determined by the \code{title} field of the \code{\link[=prolific_prescreener]{prolific_prescreener object}}.
#' To be valid, this \code{title} \strong{must} appear in the \code{title} column
#' of the resulting \code{table_of_prescreeners}.
#'
#' ## Setting constraints for a particular prescreening variable
#' The constraints are specified in the form
#' \preformatted{
#'          name_1 = value_1,
#'          ...,
#'          name_n = value_n
#' }
#'
#' or
#'
#' \preformatted{
#'          name_1,
#'          ...,
#'          name_n
#' }
#'
#' For most prescreeners, the values
#' \code{value_1} \dots \code{value_n}
#' are \code{\link[=logical]{logical}} values to select participants that gave a certain answer in some pre-screening question.
#' In this case, specifying
#' \preformatted{
#'          name_i = TRUE
#' }
#' for the prescreener means that participants who gave answer \code{name_i} are eligible for the study.
#' However, keep in mind there are some prescreeners that work in the opposite way, e.g. to specify a list of participants to be exluded
#' (see the sections \emph{'Ex- or include a list of specific participants'} and \emph{'Ex- or include all participants from previous studies'} below).
#'
#' For all cases where the values
#' \code{value_1} \dots \code{value_n}
#' are \code{\link[=logical]{logical}},
#'
#' \preformatted{
#'          name_1,
#'          ...,
#'          name_n
#' }
#'
#' is an equivalent shortcut for
#'
#' \preformatted{
#'          name_1 = TRUE,
#'          ...,
#'          name_n = TRUE
#' }.
#'
#' Yet, the constraint values are not always of type \code{\link[=logical]{logical}}.
#' In particular, there are prescreeners that allow to select participants lying within a certain range of a \code{\link[=numeric]{numerical variable}}.
#' For example, this is the case when selecting participants who are in a certain age bracket, where lower and upper boundary for a person's age are specified in the constraints.
#' In this case,
#' \code{value_1}, \dots, \code{value_n}
#' in the above specification need to be numeric as well, and \bold{must be named} e.g. as in
#' \preformatted{
#'          min_age = 50,
#'          max_age = 60
#' }
#' for selecting participants between age 50 and 60 for the study.
#'
#' The names
#' \code{name_1}, \dots, \code{name_n}
#' are always taken literally. This means that they are not automatically evaluated.
#' Enclosing a name in an \code{\link[=eval]{eval()}} command forces it to be evaluated rather than taken literally.
#' This is important for example in cases where the categories are stored in a list
#' (see the section \emph{'Examples for prolific_prescreeners'} for an example).
#'
#'
#'
#' To obtain the list of possible constraints for a particular prescreener with a \emph{valid} title \code{"the_title"} as described above, use
#' \preformatted{
#'      table_of_constraints <-
#'                prescreeners(prolific_api_access,
#'                             filter=expression(title==c("the_title")),
#'                             show_full=TRUE)
#' }
#' The names
#' \code{name_1}, \dots, \code{name_n}
#' of the \code{constraints} list should come from a single (typically the \emph{name}) column of the resulting \code{table_of_constraints},
#' the respective list elements represent the values that participants have to meet.
#'
#' To make this a bit clearer, the following section provides examples for setting up prescreening requirements.
#'
#' ## Examples for \code{\link[=prolific_prescreener]{prolific_prescreeners}}
#' \describe{
#' \item{Nationality requirements}{
#' For example, a study can be set to exclusively target participants who currently live in the UK or the USA by using
#'
#' \preformatted{
#'           residential_prescreener <- prolific_prescreener(
#'               title = "Current Country of Residence",
#'               "United Kingdom", "United States"
#'            )
#' }
#'
#' or equivalently
#'
#' \preformatted{
#'          list_of_countries <- list(
#'              country_1="United Kingdom",
#'              country_2="United States")
#'
#'          residential_prescreener <- prolific_prescreener(
#'              title = "Current Country of Residence",
#'              eval(list_of_countries$country_1),
#'              eval(list_of_countries$country_2)
#'          )
#' }
#'
#' Note that \code{"Current Country of Residence"} appears in the \emph{title} column of \code{table_of_prescreeners}, and
#' \code{"United Kingdom"} as well as \code{"United States"} appear in the \emph{name} column
#' of the resulting \code{table_of_constraints} described in the previous sections.
#' Furthermore, note the use of \code{\link[=eval]{eval()}} to force evaluation of \code{list_of_countries$country_1} and \code{list_of_countries$country_2}.
#' }
#' \item{Age requirements}{
#' Similarly, selecting participants who fall in the age range between 50 and 60 can be achieved through
#' \preformatted{
#'           age_prescreener <- prolific_prescreener(
#'               title = "Age",
#'               "min_age" = 50,
#'               "max_age" = 60
#'           )
#' }
#' }
#' \item{Ex- or include a list of specific participants}{
#' Specific participants can be in- or excluded from a study, for example if they participated in previous studies.
#' This can be done in form of black- or whitelists.
#'
#' Consider two fictional participants
#' with Prolific id's
#' \code{111} and \code{222}.
#' These can be specifically excluded by using the exclusion list defined by
#' \preformatted{
#'           exclude_list_participants <- prolific_prescreener(
#'               title = "Custom Blacklist",
#'               "111","222"
#'           )
#' }
#'
#' To exclusively recruit exactly these two participanty, use the include list defined by
#' \preformatted{
#'           include_list_participants <- prolific_prescreener(
#'               title = "Custom Whitelist",
#'               "111","222"
#'           )
#' }
#' }
#'
#' \strong{Note:} The IDs for these constraints need to be valid Prolific IDs when creating a study. The above example for fictional IDs \code{111} and \code{222} will therefore always fail.
#'
#' \item{Ex- or include all participants from previous studies}{
#' You can not only blacklist single participants, but also the group(s) of participants who
#' participated in of one or multiple of your previous studies.
#'
#' To exclude all participants from two fictional studies with IDs \code{ABC} and \code{DEF}, specify the prescreener
#' \preformatted{
#'           exclude_list_studies <- prolific_prescreener(
#'               title = "Exclude participants from previous studies",
#'               "ABC","DEF"
#'           )
#' }
#'
#' To exclusively recruit participants from these studies, use
#' \preformatted{
#'           include_list_studies <- prolific_prescreener(
#'               title = "Include participants from previous studies",
#'               "ABC","DEF"
#'           )
#' }
#' }
#' }
#'
#' \strong{Note:} The IDs for these constraints need to be valid Study IDs when creating a study. The above example for fictional IDs \code{ABC} and \code{DEF} will therefore always fail.
#'
#' @examples
#' library("prolific.api")
#'
#' prolific_api_access <- api_access(api_token = "<api_token>")
#'
#' # Create a new study with two of the prescreening constraints
#' #    from the help section 'Examples for prolific_prescreeners'
#' #    in this package's documentation.
#' fancy_new_study_with_prescreeners <- prolific_study(
#'     name = "A fancy study on Prolific",
#'     description = "Fancy description",
#'     external_study_url = "https://www.my_fancy_study_url.com",
#'     completion_code = "123ab456cd78",
#'     estimated_completion_time = 1,
#'     reward = 1,
#'     total_available_places = 1,
#'     eligibility_requirements = list(
#'         # Include only persons who live in the UK or the US
#'         prolific_prescreener(
#'             title = "Current Country of Residence",
#'             "United Kingdom", "United States"
#'         ),
#'         # Include participants only if they are between
#'         #    50 and 60 years old
#'         prolific_prescreener(
#'             title = "Age",
#'             "min_age" = 50,
#'             "max_age" = 60
#'         )
#'     )
#' )
#'
#' # Note: For the following code to work,
#' # you have to replace <api_token> in the code above by the actual API token
#' \dontrun{
#' # Post the 'fancy_new_study_with_prescreeners' to Prolific,
#' #    i.e. create it as a draft study on the platform
#' prolific_api_access$access(
#'     endpoint = "studies",
#'     method = "post",
#'     data = fancy_new_study_with_prescreeners
#' )
#'
#' # Success: fancy_new_study_with_prescreeners got an ID - it is now a draft study on Prolific!
#' # You can also inspect the study and requirements in the Prolific Web UI now.
#' fancy_new_study_with_prescreeners$id
#' }
#'
#' @export prolific_prescreener
#' @exportClass prolific_prescreener
prolific_prescreener <- setRefClass(
    Class = "prolific_prescreener",

    # ================================ > fields < ================================ #

    # ┌┌────────────────────────────────────────────────────────────────────────┐┐ #
    # || setter / getter functions                                              || #
    # └└────────────────────────────────────────────────────────────────────────┘┘ #
    fields =
        list(
            title = function(value) .accessField("title", value, .self$.internals$fields, TRUE),
            constraints = function(value) .accessField("constraints", value, .self$.internals$fields, TRUE)
        ),
    # ────────────────────────────────── <end> ─────────────────────────────────── #

    # ========================== > initialize method < =========================== #

    methods = list(
        # Initializer
        initialize =
            function(title = NULL,
                     ...) {
                # Create Internals
                assign(
                    ".internals",
                    methods::new(
                        "..internals"
                    ),
                    .self
                )

                # Define Attribute restrictions
                assign(
                    ".field_restrictions",
                    list(
                        constraints = list(typeof = "list"),
                        title = list(typeof = "character", length = 1)
                    ),
                    .self$.internals$fields
                )

                # Assign fields
                title <<- title
                constraints <<- .make_prescreener_constraints(...)

                assign("output", function(x) .output_prolific_prescreener(.self, x), .self$.internals$methods)
            }
    )
    # ────────────────────────────────── <end> ─────────────────────────────────── #
)
