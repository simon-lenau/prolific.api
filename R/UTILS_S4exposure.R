# Function for getting refclass by name or class declaration
.get_RefClass <-
    function(ref_class) {
        switch(match.arg(
            tolower(
                typeof(ref_class)
            ),
            c(
                "closure",
                "character"
            )
        ),
        closure = ref_class,
        character = get(ref_class)
        )
    }

# Function for defining S4 methods (together with the respective generic method if necessary)
.defineMethod <-
    function(method,
             class,
             definition) {
        # Define generic method if undefined
        if (!methods::isGeneric(method, where = globalenv())) {
            if (grepl("<-", method)) {
                methods::setGeneric(method, function(x, ..., value) call("standardGeneric", method))
            } else {
                methods::setGeneric(method, function(x, ...) call("standardGeneric", method))
            } # , where = globalenv())
        }
        # Define class methods (setter / getter function)
        methods::setMethod(method, class, definition)
    }



# Function for exporting all RefClass methods as S4 methods
.exposeMethods_S4 <-
    function(class,
             exclude = NULL) {
        if (!is.null(class)) {
            class <- .get_RefClass(class)
        }

        methods <- class$methods()

        methods <- methods[!methods %in% c(
            ".objectPackage",
            ".objectParent",
            "callSuper",
            "export",
            "field",
            "getClass",
            "getRefClass",
            "import",
            "initFields",
            "initialize",
            "show",
            "show#envRefClass",
            "trace",
            "untrace",
            "usingMethods",
            "copy",
            "$",
            exclude
        )]

        for (method in methods) {
            # Define S4 method
            .defineMethod(
                method,
                class@className,
                eval(parse(text = paste0("function(x, ...) x$", method, "(...)")))
            )
        }

        return(methods)
    }


.exposeFields_S4 <-
    function(class,
             exclude = NULL) {
        class <- .get_RefClass(class)
        fields <- names(class$fields())
        fields <- fields[!fields %in% c(".internals", exclude)]
        for (field in fields) {
            # Define S4 method: getter function
            .defineMethod(
                field,
                class@className,
                eval(parse(text = paste0("function(x, ...) x$", field)))
            )

            # Define S4 method: setter function
            .defineMethod(
                paste0(field, "<-"),
                class@className,
                eval(parse(text = paste0("function(x, ..., value) {x$", field, " <- value; return(x$.self)}")))
            )
        }

        return(fields)
    }

# Wrapper function for exporting all RefClass fields and methods as S4 methods
.expose_S4 <-
    function(class) {
        output <- list(list(
            fields = .exposeFields_S4(class),
            methods = .exposeMethods_S4(class)
        ))
        names(output) <- class
        return(output)
    }

# Worker function for writing documentation and export statements for the S4 methods
.document_export_S4_method <-
    function(method, class, assignment = FALSE, append = NULL) {
        paste0(
            "#' @rdname ", class,
            "\n",
            "#' @name ", method, append,
            "\n",
            "#' @export ", method,
            "\n",
            "NULL",
            "\n",
            if (assignment) {
                .document_export_S4_method(paste0(method, "<-"), class, assignment = FALSE, append = NULL)
            }
        )
    }

# methods <- export
# Wrapper function for writing documentation and export statements for the S4 methods
.write_S4_documentation <-
    function(methods,
             exclude = NULL) {
        output <- NULL

        sepfun <- function(i) {
            paste0("#", paste0(rep("-", i), collapse = ""))
        }
        i <- 1
        for (i in 1:length(methods)) {
            output <- c(
                output,
                sepfun(50),
                paste0("# ", names(methods)[i]),
                "",
                sepfun(30),
                paste0("## ", names(methods)[i], " -- Fields"),
                "",
                .document_export_S4_method(methods[[i]]$fields, names(methods)[i],
                    assignment = TRUE,
                    append = ifelse(methods[[i]]$fields %in% exclude, "-field", "")
                ),
                sepfun(30),
                paste0("## ", names(methods)[i], " -- Methods"),
                "",
                .document_export_S4_method(
                    methods[[i]]$methods,
                    names(methods)[i],
                    append = ifelse(methods[[i]]$methods %in% exclude, "-method", "")
                )
            )
        }

        return(paste0(
            output,
            collapse = "\n"
        ))
    }