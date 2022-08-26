# errors correctly outside mutate context

    Code
      pick()
    Condition
      Error in `pick()`:
      ! Must only be used inside data-masking verbs like `mutate()`, `filter()`, and `group_by()`.

# requires at least one input

    Code
      mutate(data.frame(), pick())
    Condition
      Error in `mutate()`:
      ! Problem while computing `..1 = pick()`.
      Caused by error in `pick()`:
      ! `...` can't be empty.

# doesn't allow renaming

    Code
      mutate(data.frame(x = 1), pick(y = x))
    Condition
      Error in `mutate()`:
      ! Problem while computing `..1 = pick(y = x)`.
      Caused by error in `pick()`:
      ! Can't rename variables in this context.

