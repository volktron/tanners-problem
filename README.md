# Tanner's problem
* Suppose you have numbers from 1 to 250 in a string, with no delimiters
* The numbers are randomly ordered (aka the string is unsorted)
* One of the numbers is missing
* Find the missing number

# results
## Partial
* `partial-resolution.rb` solves the problem ~49% of the time.
## Full
* `full-resolution.rb` solves the problem 100% of the time, but potentially uses *a lot* of memory.
* Runtime is less than O(n!), but at least O(n log n)
