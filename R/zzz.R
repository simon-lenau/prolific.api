i <- 1:5
ifelse(i %in% 1:3, "a", ifelse(i %in% 4, "b", "c"))


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
    exclude = c(
        "prescreener", "prescreeners",
        "prescreening", "screening",
        "eligibility_requirements", "requirements"
    )
), con = "R/zzzz.R"), error = function(e) {
    # return(invisible(NULL))
    stop(e)
})

rm(export)
