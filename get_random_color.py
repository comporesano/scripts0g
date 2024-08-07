from random import choice


LIST_OF_COLOR_CLASSES = [
  'text-muted',
  'text-primary',
  'text-success',
  'text-info',
  'text-warning',
  'text-danger',
  'text-muted dark:invert',
  'text-primary dark:invert',
  'text-success dark:invert',
  'text-info dark:invert',
  'text-warning dark:invert',
  'text-danger dark:invert'
]

print(choice(LIST_OF_COLOR_CLASSES))
