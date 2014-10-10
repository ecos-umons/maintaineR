ConflictsWith <- function(packages, cran) {
  names <- unique(Conflicts(packages, cran)$name)
  conflicts <- setkey(setkey(copy(cran$conflicts), name)[names],
                   package, version, name)
  conflicts[-conflicts[packages, which=TRUE]]
}

Conflicts <- function(packages, cran) {
  cran$conflicts[packages]
}
