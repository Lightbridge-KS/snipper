
<!-- README.md is generated from README.Rmd. Please edit that file -->

# snipper

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

> R package to Read, Write, and Manipulate Code Snippets (currently, [VS
> code
> snippet](https://code.visualstudio.com/docs/editor/userdefinedsnippets#_snippet-scope))

# Installation

You can install the development version of snipper from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("Lightbridge-KS/snipper")
```

# Usage

``` r
library(snipper)
library(dplyr)
```

## Example Data

`{snipper}` comes with example snippet files. See example snippet files
with `snipper_example()`:

``` r
# List example VS Code Snippet files
snipper_example("vscode")
#> [1] "meet.code-snippets" "r.code-snippets"

# Path to a folder containing example VS Code Snippet files
path_vs <- snipper_example("vscode", return_path = TRUE)
```

## Read Snippet from File

Read snippet into `R` as snippet [tibble](https://tibble.tidyverse.org)
with `read_snip_*()` function.

For example, read [VS Code
Snippets](https://code.visualstudio.com/docs/editor/userdefinedsnippets)
from a folder with:

``` r
my_snp <- read_snip_vscode(path_vs)
my_snp
#> # A tibble: 5 × 6
#>   file_name          snippet_name scope              prefix    body  description
#>   <chr>              <chr>        <chr>              <named l> <nam> <named lis>
#> 1 meet.code-snippets welcome      markdown,plaintext <chr [2]> <chr> <chr [1]>  
#> 2 meet.code-snippets goodbye      markdown,plaintext <chr [2]> <chr> <chr [1]>  
#> 3 r.code-snippets    fun          r                  <chr [1]> <chr> <chr [1]>  
#> 4 r.code-snippets    for          r                  <chr [1]> <chr> <chr [1]>  
#> 5 r.code-snippets    plot         r                  <chr [1]> <chr> <chr [1]>
```

``` r
class(my_snp)
#> [1] "snippets_tbl" "tbl_df"       "tbl"          "data.frame"
```

## Create Snippet from R

You can create snippet tibble directly from `R` with:

### List

``` r
ls <- list(
  hello = list(
    scope = "plaintext",
    prefix = "hello",
    body = c("hello, there", "$0"),
    description = "Say Hello"
  ),
  world = list(
    prefix = "world",
    body = c("Hi","Hi", "Welcome to a new world!")
  )
) 

# To Snippet Tibble
my_snp1 <- as_snippets_tbl(ls)
my_snp1
#> # A tibble: 2 × 5
#>   snippet_name scope     prefix       body         description 
#>   <chr>        <chr>     <named list> <named list> <named list>
#> 1 hello        plaintext <chr [1]>    <chr [2]>    <chr [1]>   
#> 2 world        <NA>      <chr [1]>    <chr [3]>    <chr [1]>
```

### Data Frame

``` r
tbl_df <- tibble::tibble(
  snippet_name = LETTERS[1:2],
  scope = rep("markdown", 2),
  prefix = tolower(snippet_name),
  body = paste0("You've get grade **", snippet_name, "**", " ${0}"),
  description = paste0("Insert grade ", snippet_name)
)

tbl_df
#> # A tibble: 2 × 5
#>   snippet_name scope    prefix body                        description   
#>   <chr>        <chr>    <chr>  <chr>                       <chr>         
#> 1 A            markdown a      You've get grade **A** ${0} Insert grade A
#> 2 B            markdown b      You've get grade **B** ${0} Insert grade B
```

Convert to snippet tibble

``` r
my_snp2 <- as_snippets_tbl(tbl_df)
my_snp2
#> # A tibble: 2 × 5
#>   snippet_name scope    prefix       body         description 
#>   <chr>        <chr>    <named list> <named list> <named list>
#> 1 A            markdown <chr [1]>    <chr [1]>    <chr [1]>   
#> 2 B            markdown <chr [1]>    <chr [1]>    <chr [1]>
```

## Manipulate

Since snippet tibble is **a tibble**, you can use **tidy tools** from
package like `{dplyr}` to filter, sort, and manipulate in various ways,
for example:

Combine Snippets with:

``` r
my_snp_all <- dplyr::bind_rows(my_snp, my_snp1, my_snp2) 
my_snp_all
#> # A tibble: 9 × 6
#>   file_name          snippet_name scope              prefix    body  description
#>   <chr>              <chr>        <chr>              <named l> <nam> <named lis>
#> 1 meet.code-snippets welcome      markdown,plaintext <chr [2]> <chr> <chr [1]>  
#> 2 meet.code-snippets goodbye      markdown,plaintext <chr [2]> <chr> <chr [1]>  
#> 3 r.code-snippets    fun          r                  <chr [1]> <chr> <chr [1]>  
#> 4 r.code-snippets    for          r                  <chr [1]> <chr> <chr [1]>  
#> 5 r.code-snippets    plot         r                  <chr [1]> <chr> <chr [1]>  
#> 6 <NA>               hello        plaintext          <chr [1]> <chr> <chr [1]>  
#> 7 <NA>               world        <NA>               <chr [1]> <chr> <chr [1]>  
#> 8 <NA>               A            markdown           <chr [1]> <chr> <chr [1]>  
#> 9 <NA>               B            markdown           <chr [1]> <chr> <chr [1]>
```

Insert rows directly with `dplyr::rows_insert()`.

``` r
my_snp_all <- my_snp_all %>% 
  rows_insert(
    tibble::tibble(
      snippet_name = "goodnight",
      scope = "markdown,plaintext",
      prefix = list(c("goodnight", "gn")),
      body = list(c("Have a sweet dream ${1:darling}", "Goodnight!")),
      description = list("Say Goodnight")
    )
  ) 
#> Matching, by = "snippet_name"

my_snp_all
#> # A tibble: 10 × 6
#>    file_name          snippet_name scope              prefix   body  description
#>    <chr>              <chr>        <chr>              <named > <nam> <named lis>
#>  1 meet.code-snippets welcome      markdown,plaintext <chr>    <chr> <chr [1]>  
#>  2 meet.code-snippets goodbye      markdown,plaintext <chr>    <chr> <chr [1]>  
#>  3 r.code-snippets    fun          r                  <chr>    <chr> <chr [1]>  
#>  4 r.code-snippets    for          r                  <chr>    <chr> <chr [1]>  
#>  5 r.code-snippets    plot         r                  <chr>    <chr> <chr [1]>  
#>  6 <NA>               hello        plaintext          <chr>    <chr> <chr [1]>  
#>  7 <NA>               world        <NA>               <chr>    <chr> <chr [1]>  
#>  8 <NA>               A            markdown           <chr>    <chr> <chr [1]>  
#>  9 <NA>               B            markdown           <chr>    <chr> <chr [1]>  
#> 10 <NA>               goodnight    markdown,plaintext <chr>    <chr> <chr [1]>
```

Filter language for “markdown” and “plaintext”

``` r
my_snp_md <- my_snp_all %>% 
  filter(scope == "markdown,plaintext")

my_snp_md
#> # A tibble: 3 × 6
#>   file_name          snippet_name scope              prefix    body  description
#>   <chr>              <chr>        <chr>              <named l> <nam> <named lis>
#> 1 meet.code-snippets welcome      markdown,plaintext <chr [2]> <chr> <chr [1]>  
#> 2 meet.code-snippets goodbye      markdown,plaintext <chr [2]> <chr> <chr [1]>  
#> 3 <NA>               goodnight    markdown,plaintext <chr [2]> <chr> <chr [1]>
```

## Show Snippet

Preview snippet with `show_snip_*()` function. For example, to preview
VS code snippet as JSON use:

``` r
show_snip_vscode(my_snp_md)
#> {
#>   "welcome": {
#>     "scope": "markdown,plaintext",
#>     "prefix": ["wel", "welcome"],
#>     "body": ["Hi ${1:everyone}, welcome to the ${2|meeting,conference|}.", "$0"],
#>     "description": "Welcome guess to the meeting"
#>   },
#>   "goodbye": {
#>     "scope": "markdown,plaintext",
#>     "prefix": ["good", "goodbye"],
#>     "body": ["Nice to see ${1:you}", "Goodbye!,", "Best", "$0"],
#>     "description": "Say goodbye to guess"
#>   },
#>   "goodnight": {
#>     "scope": "markdown,plaintext",
#>     "prefix": ["goodnight", "gn"],
#>     "body": ["Have a sweet dream ${1:darling}", "Goodnight!"],
#>     "description": "Say Goodnight"
#>   }
#> }
```

## Write Snippets

You can write snippet tibble into file with `write_snip_*()` functions.

To write VS code snippet into [multi-language, user-defined
snippet](https://code.visualstudio.com/docs/editor/userdefinedsnippets#_snippet-scope)
(`.code-snippets`) file we use:

``` r
.old_wd <- setwd(tempdir())

write_snip_vscode(my_snp_md, "my-snippet")
#> ✔ Write VS code snippet file at 'my-snippet.code-snippets'

setwd(.old_wd)
```

------------------------------------------------------------------------

Last updated: 2022-06-01
