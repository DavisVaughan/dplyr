pick <- function(...) {
  mask <- peek_mask()
  data <- mask$current_non_group_data()

  if (dots_n(...) == 0L) {
    abort("`...` can't be empty.")
  }

  sel <- tidyselect::eval_select(
    expr = expr(c(...)),
    data = data,
    allow_rename = FALSE
  )
  sel <- names(sel)

  mask$pick(sel)
}
