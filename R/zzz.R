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
    ),
    .expose_S4(
        "prolific_prescreener"
    )
)


tryCatch(writeLines(.write_S4_documentation(export,
    exclude = c("prescreener", "prescreeners", "prescreening", "screening", "eligibility_requirements", "requirements")
), con = "R/zzzz.R"), error = function(e) {
    # return(invisible(NULL))
    stop(e)
})

rm(export)


# output_fun <- function(x, obj_name = "x") {
#     colsep <- " | "
#     head <- paste0(
#         colsep,
#         "Field / Method",
#         colsep,
#         "`RefClass`",
#         colsep,
#         "`S4`",
#         colsep
#     )
#     headsep <- paste0(c(rep(paste0(colsep, ":---"), 3), colsep), collapse = "")
#     fields <- paste0(
#         colsep,
#         x$fields,
#         colsep,
#         obj_name, "$", x$fields,
#         colsep,
#         x$fields, "(", obj_name, ")",
#         colsep
#     )
#     methods <- paste0(
#         colsep,
#         x$methods,
#         colsep,
#         obj_name, "$", x$methods, "(...)",
#         colsep,
#         x$methods, "(", obj_name, ")",
#         colsep
#     )
#     cat(paste0(c(head, headsep, fields, methods), collapse = "\n"), "\n")
# }

# output_fun(export$api_access, obj_name = "api_access_object")
