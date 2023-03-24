# # Introduction to DataFrames
# **[Bogumił Kamiński](http://bogumilkaminski.pl/about/), May 23, 2018**

using DataFrames # load package

# ## Getting basic information about a data frame
# 
# Let's start by creating a `DataFrame` object, `x`, so that we can learn how to get information on that data frame.

x = DataFrame(A = [1, 2], B = [1.0, missing], C = ["a", "b"])

# The standard `size` function works to get dimensions of the `DataFrame`,

size(x), size(x, 1), size(x, 2)

# as well as `nrow` and `ncol` from R; `length` gives number of columns.

nrow(x), ncol(x), length(x)

# `describe` gives basic summary statistics of data in your `DataFrame`.

describe(x)

# Use `showcols` to get informaton about columns stored in a DataFrame.

showcols(x)

# `names` will return the names of all columns,

names(x)

# and `eltypes` returns their types.

eltypes(x)

# Here we create some large DataFrame

y = DataFrame(rand(1:10, 1000, 10));

# and then we can use `head` to peek into its top rows

head(y)

# and `tail` to see its bottom rows.

tail(y, 3)

# ### Most elementary get and set operations
# 
# Given the `DataFrame`, `x`, here are three ways to grab one of its columns as a `Vector`:

x[1], x[:A], x[:, 1]

# To grab one row as a DataFrame, we can index as follows.

x[1, :]

# We can grab a single cell or element with the same syntax to grab an element of an array.

x[1, 1]

# Assignment can be done in ranges to a scalar,

x[1:2, 1:2] = 1
x

# to a vector of length equal to the number of assigned rows,

x[1:2, 1:2] = [1,2]
x

# or to another data frame of matching size.

x[1:2, 1:2] = DataFrame([5 6; 7 8])
x

