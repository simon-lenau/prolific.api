# .onLoad <-
#     function(lib, pkg) {

#         # ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
#         # Expose fields and methods as in S4 classes
#         # ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
#         # .expose_S4(
#         #     "api_access"
#         # )

#         # .expose_S4(
#         #     "prolific_study"
#         # )
#     }

export <- c(
    .expose_S4(
        "api_access"
    ),
    .expose_S4(
        "prolific_study"
    )
)


tryCatch(writeLines(.write_S4_documentation(export,
    exclude = c("prescreener", "prescreeners", "prescreening", "screening", "eligibility_requirements", "requirements")
), con = "R/zzzz.R"), error = function(e) {
    # return(invisible(NULL))
    stop(e)
})