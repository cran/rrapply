### R code from vignette source 'rrapply.Rnw'

###################################################
### code chunk number 1: rrapply.Rnw:63-64
###################################################
op <- options(width = 60, continue = "  ")


###################################################
### code chunk number 2: rrapply.Rnw:90-94
###################################################
library(rrapply)
data("renewable_energy_by_country")
## display list structure (only first two elements of each node)
str(renewable_energy_by_country, list.len = 2, give.attr = FALSE)


###################################################
### code chunk number 3: rrapply.Rnw:97-99
###################################################
renewable_oceania <- renewable_energy_by_country[["World"]]["Oceania"]
str(renewable_oceania, list.len = 3, give.attr = FALSE)


###################################################
### code chunk number 4: rrapply.Rnw:102-107
###################################################
na_zero_oceania_unlist <- rapply(
  renewable_oceania, 
  f = function(x) ifelse(is.na(x), 0, x)
)
head(na_zero_oceania_unlist)


###################################################
### code chunk number 5: rrapply.Rnw:111-118
###################################################
na_zero_oceania_replace <- rapply(
  renewable_oceania, 
  f = function(x) 0, 
  classes = "logical", 
  how = "replace"
)
str(na_zero_oceania_replace, list.len = 3, give.attr = FALSE)


###################################################
### code chunk number 6: rrapply.Rnw:121-129
###################################################
na_zero_oceania_list <- rapply(
  renewable_oceania, 
  f = function(x) x, 
  classes = "numeric", 
  deflt = 0, 
  how = "list"
)
str(na_zero_oceania_list, list.len = 3, give.attr = FALSE)


###################################################
### code chunk number 7: rrapply.Rnw:132-138
###################################################
na_zero_oceania_replace_attr <- rapply(
  renewable_oceania, 
  f = function(x) replace(x, is.na(x), 0), 
  how = "replace"
)
str(na_zero_oceania_replace_attr, list.len = 2)


###################################################
### code chunk number 8: rrapply.Rnw:141-150
###################################################
na_zero_oceania_list_attr <- rapply(
  renewable_oceania, 
  f = function(x) replace(x, is.na(x), 0), 
  how = "list"
)
## this preserves all list attributes
str(na_zero_oceania_replace_attr, max.level = 2)
## this does not preserves all attributes!
str(na_zero_oceania_list_attr, max.level = 2)


###################################################
### code chunk number 9: rrapply.Rnw:160-167
###################################################
na_drop_oceania_list <- rrapply(
  renewable_oceania, 
  f = function(x) x, 
  classes = "numeric", 
  how = "prune"
)
str(na_drop_oceania_list, list.len = 3, give.attr = FALSE)


###################################################
### code chunk number 10: rrapply.Rnw:170-177
###################################################
na_drop_oceania_flat <- rrapply(
  renewable_oceania, 
  f = function(x) x, 
  classes = "numeric", 
  how = "flatten"
)
head(na_drop_oceania_flat, n = 10)


###################################################
### code chunk number 11: rrapply.Rnw:180-187
###################################################
na_drop_melt <- rrapply(
  renewable_oceania,
  f = function(x) x,
  classes = "numeric",
  how = "melt"
)
head(na_drop_melt)


###################################################
### code chunk number 12: rrapply.Rnw:190-205
###################################################
## Remove all names at L2 (these arguments are explained in the following sections)
oceania_unnamed <- rrapply(
  renewable_oceania,
  classes = "list",
  condition = function(x, .xname) .xname == "Oceania",
  f = unname
)

na_drop_melt2 <- rrapply(
  oceania_unnamed,
  f = function(x) x,
  classes = "numeric",
  how = "melt"
)
head(na_drop_melt2)


###################################################
### code chunk number 13: rrapply.Rnw:208-220
###################################################
## Nested list of Pokemon properties in Pokemon GO
data("pokedex")

str(pokedex, list.len = 3)

## Unnest list as a wide data.frame
pokedex_wide <- rrapply(
  pokedex,
  how = "bind"
)

head(pokedex_wide[, c(1:3, 5:7)])


###################################################
### code chunk number 14: rrapply.Rnw:231-238
###################################################
na_drop_oceania_list2 <- rrapply(
  renewable_oceania, 
  condition = function(x) !is.na(x), 
  f = function(x) x, 
  how = "prune"
)
str(na_drop_oceania_list2, list.len = 3, give.attr = FALSE)


###################################################
### code chunk number 15: rrapply.Rnw:241-247
###################################################
na_drop_oceania_list3 <- rrapply(
  renewable_oceania, 
  condition = Negate(is.na), 
  how = "prune"
)
str(na_drop_oceania_list3, list.len = 3, give.attr = FALSE)


###################################################
### code chunk number 16: rrapply.Rnw:252-266
###################################################
renewable_energy_above_85 <- rrapply(
  renewable_energy_by_country, 
  condition = function(x) x > 85, 
  how = "prune"
)
str(renewable_energy_above_85, give.attr = FALSE)
## passing arguments to condition via ...
renewable_energy_equal_0 <- rrapply(
  renewable_energy_by_country, 
  condition = `==`, 
  e2 = 0, 
  how = "prune"
)
str(renewable_energy_equal_0, give.attr = FALSE)


###################################################
### code chunk number 17: rrapply.Rnw:273-280
###################################################
na_zero_oceania_list2 <- rrapply(
  renewable_oceania, 
  condition = Negate(is.na), 
  deflt = 0, 
  how = "list"
)
str(na_zero_oceania_list2, list.len = 3, give.attr = FALSE)


###################################################
### code chunk number 18: rrapply.Rnw:284-291
###################################################
na_zero_oceania_replace2 <- rrapply(
  renewable_oceania, 
  condition = is.na, 
  f = function(x) 0, 
  how = "replace"
)
str(na_zero_oceania_replace2, list.len = 3, give.attr = FALSE)


###################################################
### code chunk number 19: rrapply.Rnw:298-317
###################################################
## this is not ok!
tryCatch({
  rrapply(
    renewable_oceania, 
    condition = is.na, 
    f = function(x, newvalue) newvalue, 
    newvalue = 0, 
    how = "replace"
  )
}, error = function(error) error$message)
## this is ok
na_zero_oceania_replace3 <- rrapply(
  renewable_oceania, 
  condition = function(x, newvalue) is.na(x), 
  f = function(x, newvalue) newvalue, 
  newvalue = 0, 
  how = "replace"
)
str(na_zero_oceania_replace3, list.len = 3, give.attr = FALSE)


###################################################
### code chunk number 20: rrapply.Rnw:323-329
###################################################
renewable_oceania_flat <- rrapply(
  renewable_oceania, 
  condition = Negate(is.na), 
  how = "flatten"
)
head(renewable_oceania_flat)


###################################################
### code chunk number 21: rrapply.Rnw:332-339
###################################################
renewable_oceania_flat_text <- mapply(
  FUN = function(name, value) sprintf("Renewable energy in %s: %.2f%%", name, value),
  name = names(renewable_oceania_flat),
  value = renewable_oceania_flat,
  SIMPLIFY = FALSE
)
str(renewable_oceania_flat_text, list.len = 6)


###################################################
### code chunk number 22: rrapply.Rnw:353-360
###################################################
renewable_oceania_flat_text <- rrapply(
  renewable_oceania,
  f = function(x, .xname) sprintf("Renewable energy in %s: %.2f%%", .xname, x),
  condition = Negate(is.na),
  how = "flatten"
)
head(renewable_oceania_flat_text, n = 6)


###################################################
### code chunk number 23: rrapply.Rnw:366-372
###################################################
renewable_benelux <- rrapply(
  renewable_energy_by_country, 
  condition = function(x, .xname) .xname %in% c("Belgium", "Netherlands", "Luxembourg"), 
  how = "prune"
)
str(renewable_benelux, give.attr = FALSE)


###################################################
### code chunk number 24: rrapply.Rnw:376-382
###################################################
renewable_europe_above_50 <- rrapply(
  renewable_energy_by_country,
  condition = function(x, .xpos) identical(head(.xpos, 2), c(1L, 5L)) & x > 50,
  how = "prune"
)
str(renewable_europe_above_50, give.attr = FALSE)


###################################################
### code chunk number 25: rrapply.Rnw:385-390
###################################################
renewable_europe_above_50 <- rrapply(
  renewable_energy_by_country,
  condition = function(x, .xparents) "Europe" %in% .xparents & x > 50,
  how = "prune"
)


###################################################
### code chunk number 26: rrapply.Rnw:394-403
###################################################
(xpos_sweden <- rrapply(
  renewable_energy_by_country,
  condition = function(x, .xname) identical(.xname, "Sweden"),
  f = function(x, .xpos) .xpos,
  how = "flatten"
))

## sanity check
renewable_energy_by_country[[xpos_sweden$Sweden]]


###################################################
### code chunk number 27: rrapply.Rnw:407-421
###################################################
## maximum depth
depth_all <- rrapply(
  renewable_energy_by_country, 
  f = function(x, .xpos) length(.xpos), 
  how = "unlist"
)
max(depth_all) 
## longest sublist length
sublist_count <- rrapply(
  renewable_energy_by_country, 
  f = function(x, .xpos) max(.xpos), 
  how = "unlist"
)
max(sublist_count)


###################################################
### code chunk number 28: rrapply.Rnw:424-431
###################################################
## look up sibling countries of Sweden in list
siblings_sweden <- rrapply(
  renewable_energy_by_country,
  condition = function(x, .xsiblings) "Sweden" %in% names(.xsiblings),
  how = "flatten"
)
head(siblings_sweden, n = 6)


###################################################
### code chunk number 29: rrapply.Rnw:434-444
###################################################
## parse only Pokemon number, name and type columns 
pokedex_small <- rrapply(
  pokedex,
  condition = function(x, .xpos, .xname) {
    length(.xpos) < 4 & .xname %in% c("num", "name", "type")
    },
  how = "bind"
)

head(pokedex_small)


###################################################
### code chunk number 30: rrapply.Rnw:451-461
###################################################
rrapply(
  renewable_energy_by_country,  
  classes = "list",
  condition = function(x, .xname) .xname == "Europe",
  f = function(x) list(
    mean = mean(unlist(x), na.rm = TRUE), 
    sd = sd(unlist(x), na.rm = TRUE)
  ),
  how = "flatten"
)


###################################################
### code chunk number 31: rrapply.Rnw:467-477
###################################################
rrapply(
  renewable_energy_by_country,
  classes = "list",
  condition = function(x) attr(x, "M49-code") == "150",
  f = function(x) list(
    mean = mean(unlist(x), na.rm = TRUE), 
    sd = sd(unlist(x), na.rm = TRUE)
  ),
  how = "flatten"
)


###################################################
### code chunk number 32: rrapply.Rnw:480-489
###################################################
renewable_continent_summary <- rrapply(
  renewable_energy_by_country,  
  classes = "list",
  condition = function(x, .xpos) length(.xpos) == 2,
  f = function(x) mean(unlist(x), na.rm = TRUE)
)

## Antarctica has a missing value
str(renewable_continent_summary, give.attr = FALSE)


###################################################
### code chunk number 33: rrapply.Rnw:493-500
###################################################
## Filter country or region by M49-code
rrapply(
  renewable_energy_by_country,
  classes = c("list", "ANY"), 
  condition = function(x) attr(x, "M49-code") == "155",
  f = function(x, .xname) .xname,
  how = "unlist")


###################################################
### code chunk number 34: rrapply.Rnw:503-513
###################################################
## Simplify Pokemon evolution sublists to character vectors 
pokedex_wide2 <- rrapply(
  pokedex,
  classes = c("character", "list"),
  condition = function(x, .xname) .xname %in% c("name", "next_evolution", "prev_evolution"), 
  f = function(x) if(is.list(x)) sapply(x, `[[`, "name") else x,
  how = "bind"
)
    
head(pokedex_wide2, n = 9)


###################################################
### code chunk number 35: rrapply.Rnw:520-531
###################################################
renewable_M49 <- rrapply(
  list(renewable_energy_by_country), 
  classes = "list",
  f = function(x) {
    names(x) <- vapply(x, attr, character(1L), which = "M49-code")
    return(x)
  },
  how = "recurse"
)

str(renewable_M49[[1]], max.level = 3, list.len = 3, give.attr = FALSE)


###################################################
### code chunk number 36: rrapply.Rnw:543-549
###################################################
## melted data.frame
head(na_drop_melt)

na_drop_unmelt <- rrapply(na_drop_melt, how = "unmelt")

str(na_drop_unmelt, list.len = 3, give.attr = FALSE)


###################################################
### code chunk number 37: rrapply.Rnw:559-561
###################################################
na_drop_remelt <- rrapply(na_drop_unmelt, how = "melt")
identical(na_drop_melt, na_drop_remelt)


###################################################
### code chunk number 38: rrapply.Rnw:568-590
###################################################
## create a list of data.frames
oceania_df <- list(
  Oceania = lapply(
    renewable_oceania[["Oceania"]], 
    FUN = function(x) data.frame(value = unlist(x))
  )
)
## this does not work!
tryCatch({
  rrapply(
    oceania_df,
    f = function(x) subset(x, !is.na(value)), ## filter NA-rows of data.frame
    how = "replace"
  )
}, error = function(error) error$message)
## this does work
rrapply(
  oceania_df,
  classes = "data.frame",
  f = function(x) subset(x, !is.na(value)),
  how = "replace"
)


###################################################
### code chunk number 39: rrapply.Rnw:595-602 (eval = FALSE)
###################################################
## rrapply(
##   oceania_df,
##   classes = "list",
##   condition = is.data.frame,
##   f = function(x) subset(x, !is.na(value)),
##   how = "replace"
## )


###################################################
### code chunk number 40: rrapply.Rnw:610-624
###################################################
## how = "list" now preserves all list attributes
na_drop_oceania_list_attr2 <- rrapply(
  renewable_oceania, 
  f = function(x) replace(x, is.na(x), 0), 
  how = "list"
)
str(na_drop_oceania_list_attr2, max.level = 2)
## how = "prune" also preserves list attributes
na_drop_oceania_attr <- rrapply(
  renewable_oceania, 
  condition = Negate(is.na), 
  how = "prune"
)
str(na_drop_oceania_attr, max.level = 2)


###################################################
### code chunk number 41: rrapply.Rnw:631-633
###################################################
iris_standard <- rapply(iris, f = scale, classes = "numeric", how = "replace")
head(iris_standard)


###################################################
### code chunk number 42: rrapply.Rnw:636-642
###################################################
iris_standard_sepal <- rrapply(
  iris,                    
  condition = function(x, .xname) grepl("Sepal", .xname), 
  f = scale
)
head(iris_standard_sepal)


###################################################
### code chunk number 43: rrapply.Rnw:647-654
###################################################
iris_standard_transmute <- rrapply(
  iris, 
  f = scale, 
  classes = "numeric", 
  how = "prune"
)
head(iris_standard_transmute)


###################################################
### code chunk number 44: rrapply.Rnw:659-667
###################################################
## summarize columns with how = "flatten"
iris_standard_summarize <- rrapply(
  iris, 
  f = summary, 
  classes = "numeric", 
  how = "flatten"
)
iris_standard_summarize


###################################################
### code chunk number 45: rrapply.Rnw:674-687
###################################################
## recurse through call as nested list
ast <- function(expr) {
  lapply(expr, function(x) {
    if(is.call(x) || is.expression(x)) {
      ast(x) 
    } else {
      x
    }
  })
}

## decompose call object
str(ast(quote(y <- x <- 1 + TRUE)))


###################################################
### code chunk number 46: rrapply.Rnw:690-699
###################################################
## rapply on an expression vector (ok for R >= 3.6)
tryCatch({
  rapply(expression(y <- x <- 1, f(g(2 * pi))), f = identity)
}, error = function(error) error$message)

## rapply on a call object (not ok!) 
tryCatch({
  rapply(quote(y <- x <- 1), f = identity)
}, error = function(error) error$message)


###################################################
### code chunk number 47: rrapply.Rnw:707-718
###################################################
call_old <- quote(y <- x <- 1 + TRUE)
str(call_old)

## update call object
call_new <- rrapply(
  call_old, 
  classes = "logical", 
  f = as.numeric, 
  how = "replace"
)
str(call_new)


###################################################
### code chunk number 48: rrapply.Rnw:721-728
###################################################
## update and decompose call object
call_ast <- rrapply(
  call_old, 
  f = function(x) ifelse(is.logical(x), as.numeric(x), x), 
  how = "list"
)
str(call_ast)


###################################################
### code chunk number 49: rrapply.Rnw:734-738
###################################################
## example expression
expr <- expression(y <- x <- 1, f(g(2 * pi)))
## helper function
is_new_name <- function(x) !exists(as.character(x), envir = baseenv())


###################################################
### code chunk number 50: rrapply.Rnw:740-767
###################################################
## prune and decompose expression
expr_prune <- rrapply(
  expr, 
  classes = "name", 
  condition = is_new_name, 
  how = "prune"
)
str(expr_prune)

## prune and flatten expression
expr_flatten <- rrapply(
  expr, 
  classes = "name", 
  condition = is_new_name, 
  how = "flatten"
)
str(expr_flatten)

## prune and melt expression
expr_melt <- rrapply(
  expr, 
  classes = "name", 
  condition = is_new_name, 
  f = as.character,
  how = "melt"
)
expr_melt


###################################################
### code chunk number 51: rrapply.Rnw:774-781
###################################################
## extract all terminal call nodes of AST
rrapply(
  expr, 
  classes = "language", 
  condition = function(x) !any(sapply(x, is.call)),
  how = "flatten"
)


###################################################
### code chunk number 52: rrapply.Rnw:787-788
###################################################
options(op)


