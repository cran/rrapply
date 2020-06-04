### R code from vignette source 'rrapply.Rnw'
### Encoding: UTF-8

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
### code chunk number 11: rrapply.Rnw:185-192
###################################################
na_drop_oceania_list2 <- rrapply(
  renewable_oceania, 
  condition = function(x) !is.na(x), 
  f = function(x) x, 
  how = "prune"
)
str(na_drop_oceania_list2, list.len = 3, give.attr = FALSE)


###################################################
### code chunk number 12: rrapply.Rnw:195-201
###################################################
na_drop_oceania_list3 <- rrapply(
  renewable_oceania, 
  condition = Negate(is.na), 
  how = "prune"
)
str(na_drop_oceania_list3, list.len = 3, give.attr = FALSE)


###################################################
### code chunk number 13: rrapply.Rnw:206-220
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
### code chunk number 14: rrapply.Rnw:227-234
###################################################
na_zero_oceania_list2 <- rrapply(
  renewable_oceania, 
  condition = Negate(is.na), 
  deflt = 0, 
  how = "list"
)
str(na_zero_oceania_list2, list.len = 3, give.attr = FALSE)


###################################################
### code chunk number 15: rrapply.Rnw:238-245
###################################################
na_zero_oceania_replace2 <- rrapply(
  renewable_oceania, 
  condition = is.na, 
  f = function(x) 0, 
  how = "replace"
)
str(na_zero_oceania_replace2, list.len = 3, give.attr = FALSE)


###################################################
### code chunk number 16: rrapply.Rnw:252-271
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
### code chunk number 17: rrapply.Rnw:277-283
###################################################
renewable_oceania_flat <- rrapply(
  renewable_oceania, 
  condition = Negate(is.na), 
  how = "flatten"
)
str(renewable_oceania_flat, list.len = 10, give.attr = FALSE)


###################################################
### code chunk number 18: rrapply.Rnw:286-293
###################################################
renewable_oceania_flat_text <- mapply(
  FUN = function(name, value) sprintf("Renewable energy in %s: %.2f%%", name, value),
  name = names(renewable_oceania_flat),
  value = renewable_oceania_flat,
  SIMPLIFY = FALSE
)
str(renewable_oceania_flat_text, list.len = 10)


###################################################
### code chunk number 19: rrapply.Rnw:306-313
###################################################
renewable_oceania_flat_text <- rrapply(
  renewable_oceania,
  f = function(x, .xname) sprintf("Renewable energy in %s: %.2f%%", .xname, x),
  condition = Negate(is.na),
  how = "flatten"
)
str(renewable_oceania_flat_text, list.len = 10)


###################################################
### code chunk number 20: rrapply.Rnw:319-325
###################################################
renewable_benelux <- rrapply(
  renewable_energy_by_country, 
  condition = function(x, .xname) .xname %in% c("Belgium", "Netherlands", "Luxembourg"), 
  how = "prune"
)
str(renewable_benelux, give.attr = FALSE)


###################################################
### code chunk number 21: rrapply.Rnw:329-335
###################################################
renewable_europe_above_50 <- rrapply(
  renewable_energy_by_country,
  condition = function(x, .xpos) identical(head(.xpos, 2), c(1L, 5L)) & x > 50,
  how = "prune"
)
str(renewable_europe_above_50, give.attr = FALSE)


###################################################
### code chunk number 22: rrapply.Rnw:339-348
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
### code chunk number 23: rrapply.Rnw:352-366
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
### code chunk number 24: rrapply.Rnw:374-384
###################################################
rrapply(
  renewable_energy_by_country,  
  condition = function(x, .xname) .xname == "Europe",
  f = function(x) list(
    mean = mean(unlist(x), na.rm = TRUE), 
    sd = sd(unlist(x), na.rm = TRUE)
  ),
  how = "flatten",
  feverywhere = TRUE
)


###################################################
### code chunk number 25: rrapply.Rnw:390-400
###################################################
rrapply(
  renewable_energy_by_country,
  condition = function(x) attr(x, "M49-code") == "150",
  f = function(x) list(
    mean = mean(unlist(x), na.rm = TRUE), 
    sd = sd(unlist(x), na.rm = TRUE)
  ),
  how = "flatten",
  feverywhere = TRUE
)


###################################################
### code chunk number 26: rrapply.Rnw:403-412
###################################################
renewable_continent_summary <- rrapply(
  renewable_energy_by_country,  
  condition = function(x, .xpos) length(.xpos) == 2,
  f = function(x) mean(unlist(x), na.rm = TRUE),
  feverywhere = TRUE
)

## Antarctica has a missing value
str(renewable_continent_summary, give.attr = FALSE)


###################################################
### code chunk number 27: rrapply.Rnw:424-451
###################################################
## create a list of data.frames
oceania_df <- list(
  Oceania = lapply(
    renewable_oceania[["Oceania"]], 
    FUN = function(x) data.frame(
      Name = names(x), 
      value = unlist(x), 
      stringsAsFactors = FALSE
    )
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
### code chunk number 28: rrapply.Rnw:456-463 (eval = FALSE)
###################################################
## rrapply(
##   oceania_df,
##   condition = function(x) class(x) == "data.frame",
##   f = function(x) subset(x, !is.na(value)),
##   how = "replace",
##   feverywhere = TRUE
## )


###################################################
### code chunk number 29: rrapply.Rnw:475-489
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
### code chunk number 30: rrapply.Rnw:497-499
###################################################
iris_standard <- rapply(iris, f = scale, classes = "numeric", how = "replace")
head(iris_standard)


###################################################
### code chunk number 31: rrapply.Rnw:502-508
###################################################
iris_standard_sepal <- rrapply(
  iris,                    
  condition = function(x, .xname) grepl("Sepal", .xname), 
  f = scale
)
head(iris_standard_sepal)


###################################################
### code chunk number 32: rrapply.Rnw:513-520
###################################################
iris_standard_transmute <- rrapply(
  iris, 
  f = scale, 
  classes = "numeric", 
  how = "prune"
)
head(iris_standard_transmute)


###################################################
### code chunk number 33: rrapply.Rnw:525-533
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
### code chunk number 34: rrapply.Rnw:542-548 (eval = FALSE)
###################################################
## ## rapply(how = "replace")
## rapply(x, f = `*`, e2 = 1, how = "replace")  
## ## rrapply(how = "replace")
## rrapply(x, f = `*`, e2 = 1, how = "replace")
## ## rrapply(how = "prune")
## rrapply(x, f = `*`, e2 = 1, how = "prune")


###################################################
### code chunk number 35: rrapply.Rnw:551-559 (eval = FALSE)
###################################################
## ## rapply(classes = "numeric", how = "replace")
## rapply(x, f = `*`, e2 = 1, classes = "numeric", how = "replace")    
## ## rrapply(classes = "numeric", how = "replace")
## rrapply(x, f = `*`, e2 = 1, classes = "numeric", how = "replace")
## ## rrapply(classes = "numeric", how = "prune")
## rrapply(x, f = `*`, e2 = 1, classes = "numeric", how = "prune")
## ## rrapply(condition = "numeric", how = "replace")
## rrapply(dat, condition = is.numeric, f = function(x) `*`(x, 1), how = "replace")


###################################################
### code chunk number 36: rrapply.Rnw:577-578
###################################################
options(op)


