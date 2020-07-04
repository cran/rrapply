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
str(na_drop_oceania_flat, list.len = 10, give.attr = FALSE)


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
  condition = function(x, .xpos) length(.xpos) < 2,
  f = unname,
  feverywhere = "break"
)

na_drop_melt2 <- rrapply(
  oceania_unnamed,
  f = function(x) x,
  classes = "numeric",
  how = "melt"
)
head(na_drop_melt2)


###################################################
### code chunk number 13: rrapply.Rnw:213-220
###################################################
na_drop_oceania_list2 <- rrapply(
  renewable_oceania, 
  condition = function(x) !is.na(x), 
  f = function(x) x, 
  how = "prune"
)
str(na_drop_oceania_list2, list.len = 3, give.attr = FALSE)


###################################################
### code chunk number 14: rrapply.Rnw:223-229
###################################################
na_drop_oceania_list3 <- rrapply(
  renewable_oceania, 
  condition = Negate(is.na), 
  how = "prune"
)
str(na_drop_oceania_list3, list.len = 3, give.attr = FALSE)


###################################################
### code chunk number 15: rrapply.Rnw:234-248
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
### code chunk number 16: rrapply.Rnw:255-262
###################################################
na_zero_oceania_list2 <- rrapply(
  renewable_oceania, 
  condition = Negate(is.na), 
  deflt = 0, 
  how = "list"
)
str(na_zero_oceania_list2, list.len = 3, give.attr = FALSE)


###################################################
### code chunk number 17: rrapply.Rnw:266-273
###################################################
na_zero_oceania_replace2 <- rrapply(
  renewable_oceania, 
  condition = is.na, 
  f = function(x) 0, 
  how = "replace"
)
str(na_zero_oceania_replace2, list.len = 3, give.attr = FALSE)


###################################################
### code chunk number 18: rrapply.Rnw:280-299
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
### code chunk number 19: rrapply.Rnw:305-311
###################################################
renewable_oceania_flat <- rrapply(
  renewable_oceania, 
  condition = Negate(is.na), 
  how = "flatten"
)
str(renewable_oceania_flat, list.len = 10, give.attr = FALSE)


###################################################
### code chunk number 20: rrapply.Rnw:314-321
###################################################
renewable_oceania_flat_text <- mapply(
  FUN = function(name, value) sprintf("Renewable energy in %s: %.2f%%", name, value),
  name = names(renewable_oceania_flat),
  value = renewable_oceania_flat,
  SIMPLIFY = FALSE
)
str(renewable_oceania_flat_text, list.len = 10)


###################################################
### code chunk number 21: rrapply.Rnw:334-341
###################################################
renewable_oceania_flat_text <- rrapply(
  renewable_oceania,
  f = function(x, .xname) sprintf("Renewable energy in %s: %.2f%%", .xname, x),
  condition = Negate(is.na),
  how = "flatten"
)
str(renewable_oceania_flat_text, list.len = 10)


###################################################
### code chunk number 22: rrapply.Rnw:347-353
###################################################
renewable_benelux <- rrapply(
  renewable_energy_by_country, 
  condition = function(x, .xname) .xname %in% c("Belgium", "Netherlands", "Luxembourg"), 
  how = "prune"
)
str(renewable_benelux, give.attr = FALSE)


###################################################
### code chunk number 23: rrapply.Rnw:357-363
###################################################
renewable_europe_above_50 <- rrapply(
  renewable_energy_by_country,
  condition = function(x, .xpos) identical(head(.xpos, 2), c(1L, 5L)) & x > 50,
  how = "prune"
)
str(renewable_europe_above_50, give.attr = FALSE)


###################################################
### code chunk number 24: rrapply.Rnw:367-376
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
### code chunk number 25: rrapply.Rnw:380-394
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
### code chunk number 26: rrapply.Rnw:402-412
###################################################
rrapply(
  renewable_energy_by_country,  
  condition = function(x, .xname) .xname == "Europe",
  f = function(x) list(
    mean = mean(unlist(x), na.rm = TRUE), 
    sd = sd(unlist(x), na.rm = TRUE)
  ),
  how = "flatten",
  feverywhere = "break"
)


###################################################
### code chunk number 27: rrapply.Rnw:418-428
###################################################
rrapply(
  renewable_energy_by_country,
  condition = function(x) attr(x, "M49-code") == "150",
  f = function(x) list(
    mean = mean(unlist(x), na.rm = TRUE), 
    sd = sd(unlist(x), na.rm = TRUE)
  ),
  how = "flatten",
  feverywhere = "break"
)


###################################################
### code chunk number 28: rrapply.Rnw:431-440
###################################################
renewable_continent_summary <- rrapply(
  renewable_energy_by_country,  
  condition = function(x, .xpos) length(.xpos) == 2,
  f = function(x) mean(unlist(x), na.rm = TRUE),
  feverywhere = "break"
)

## Antarctica has a missing value
str(renewable_continent_summary, give.attr = FALSE)


###################################################
### code chunk number 29: rrapply.Rnw:447-458
###################################################
renewable_M49 <- rrapply(
  list(renewable_energy_by_country), 
  condition = is.list,
  f = function(x) {
    names(x) <- vapply(x, attr, character(1L), which = "M49-code")
    return(x)
  },
  feverywhere = "recurse"
)

str(renewable_M49[[1]], max.level = 3, list.len = 3, give.attr = FALSE)


###################################################
### code chunk number 30: rrapply.Rnw:470-493
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
    how = "replace",
    dfaslist = TRUE
  )
}, error = function(error) error$message)
## this does work
rrapply(
  oceania_df,
  f = function(x) subset(x, !is.na(value)),
  how = "replace",
  dfaslist = FALSE
)


###################################################
### code chunk number 31: rrapply.Rnw:498-505 (eval = FALSE)
###################################################
## rrapply(
##   oceania_df,
##   condition = function(x) class(x) == "data.frame",
##   f = function(x) subset(x, !is.na(value)),
##   how = "replace",
##   feverywhere = "break"
## )


###################################################
### code chunk number 32: rrapply.Rnw:517-531
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
### code chunk number 33: rrapply.Rnw:539-541
###################################################
iris_standard <- rapply(iris, f = scale, classes = "numeric", how = "replace")
head(iris_standard)


###################################################
### code chunk number 34: rrapply.Rnw:544-550
###################################################
iris_standard_sepal <- rrapply(
  iris,                    
  condition = function(x, .xname) grepl("Sepal", .xname), 
  f = scale
)
head(iris_standard_sepal)


###################################################
### code chunk number 35: rrapply.Rnw:555-562
###################################################
iris_standard_transmute <- rrapply(
  iris, 
  f = scale, 
  classes = "numeric", 
  how = "prune"
)
head(iris_standard_transmute)


###################################################
### code chunk number 36: rrapply.Rnw:567-575
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
### code chunk number 37: rrapply.Rnw:580-581
###################################################
options(op)


