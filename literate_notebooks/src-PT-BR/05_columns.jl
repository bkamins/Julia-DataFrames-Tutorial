# # Introduction to DataFrames
# **[Bogumił Kamiński](http://bogumilkaminski.pl/about/), May 23, 2018**

using DataFrames # load package

# ## Manipulating columns of DataFrame

#-

# ### Renaming columns
# 
# Let's start with a `DataFrame` of `Bool`s that has default column names.

x = DataFrame(Bool, 3, 4)

# With `rename`, we create new `DataFrame`; here we rename the column `:x1` to `:A`. (`rename` also accepts collections of Pairs.)

rename(x, :x1 => :A)

# With `rename!` we do an in place transformation. 
# 
# This time we've applied a function to every column name.

rename!(c -> Symbol(string(c)^2), x)

# We can also change the name of a particular column without knowing the original.
# 
# Here we change the name of the third column, creating a new `DataFrame`.

rename(x, names(x)[3] => :third)

# With `names!`, we can change the names of all variables.

names!(x, [:a, :b, :c, :d])

# We get an error when we try to provide duplicate names

names!(x, fill(:a, 4))

#  unless we pass `makeunique=true`, which allows us to handle duplicates in passed names.

names!(x, fill(:a, 4), makeunique=true)

# ### Reordering columns

#-

# We can reorder the names(x) vector as needed, creating a new DataFrame.

srand(1234)
x[shuffle(names(x))]

# also `permutecols!` will be introduced in next release of DataFrames

#-

# ### Merging/adding columns

x = DataFrame([(i,j) for i in 1:3, j in 1:4])

# With `hcat` we can merge two `DataFrame`s. Also [x y] syntax is supported but only when DataFrames have unique column names.

hcat(x, x, makeunique=true)

# We can also use `hcat` to add a new column; a default name `:x1` will be used for this column, so `makeunique=true` is needed.

y = hcat(x, [1,2,3], makeunique=true)

# You can also prepend a vector with `hcat`.

hcat([1,2,3], x, makeunique=true)

# Alternatively you could append a vector with the following syntax. This is a bit more verbose but cleaner.

y = [x DataFrame(A=[1,2,3])]

# Here we do the same but add column `:A` to the front.

y = [DataFrame(A=[1,2,3]) x]

# A column can also be added in the middle. Here a brute-force method is used and a new DataFrame is created.

using BenchmarkTools
@btime [$x[1:2] DataFrame(A=[1,2,3]) $x[3:4]]

# We could also do this with a specialized in place method `insert!`. Let's add `:newcol` to the `DataFrame` `y`.

insert!(y, 2, [1,2,3], :newcol)

# If you want to insert the same column name several times `makeunique=true` is needed as usual.

insert!(y, 2, [1,2,3], :newcol, makeunique=true)

# We can see how much faster it is to insert a column with `insert!` than with `hcat` using `@btime`.

@btime insert!(copy($x), 3, [1,2,3], :A)

# Let's use `insert!` to append a column in place,

insert!(x, ncol(x)+1, [1,2,3], :A)

# and to in place prepend a column.

insert!(x, 1, [1,2,3], :B)

# With `merge!`, let's merge the second DataFrame into first, but overwriting duplicates.

df1 = DataFrame(x=1:3, y=4:6)
df2 = DataFrame(x='a':'c', z = 'd':'f', new=11:13)
df1, df2, merge!(df1, df2)

#  For comparison: merge two `DataFrames`s but renaming duplicate names via `hcat`.

df1 = DataFrame(x=1:3, y=4:6)
df2 = DataFrame(x='a':'c', z = 'd':'f', new=11:13)
hcat(df1, df2, makeunique=true)

# ### Subsetting/removing columns
# 
# Let's create a new `DataFrame` `x` and show a few ways to create DataFrames with a subset of `x`'s columns.

x = DataFrame([(i,j) for i in 1:3, j in 1:5])

# First we could do this by index

x[[1,2,4,5]]

# or by column name.

x[[:x1, :x4]]

# We can also choose to keep or exclude columns by `Bool`. (We need a vector whose length is the number of columns in the original `DataFrame`.)

x[[true, false, true, false, true]]

# Here we create a single column `DataFrame`,

x[[:x1]]

# and here we access the vector contained in column `:x1`.

x[:x1]

# We could grab the same vector by column number

x[1]

# and remove everything from a `DataFrame` with `empty!`.

empty!(y)

# Here we create a copy of `x` and delete the 3rd column from the copy with `delete!`.

z = copy(x)
x, delete!(z, 3)

# ### Modify column by name

x = DataFrame([(i,j) for i in 1:3, j in 1:5])

# With the following syntax, the existing column is modified without performing any copying.

x[:x1] = x[:x2]
x

# We can also use the following syntax to add a new column at the end of a `DataFrame`.

x[:A] = [1,2,3]
x

# A new column name will be added to our `DataFrame` with the following syntax as well (7 is equal to `ncol(x)+1`).

x[7] = 11:13
x

# ### Find column name

x = DataFrame([(i,j) for i in 1:3, j in 1:5])

# We can check if a column with a given name exists via

:x1 in names(x) 

# and determine its index via

findfirst(names(x), :x2)

