# An Introduction to DataFrames

[Bogumił Kamiński](http://bogumilkaminski.pl/about/), Dec 10, 2017

A brief introduction to basic usage of `DataFrames`. Tested under `DataFrames` master on 2017-12-05.

I will try to keep it up to date as the package evolves. This tutorial covers `DataFrames`, `CSV`, `Missings` and `CategoricalArrays` only. It does not show any additional packages that can be used with `DataFrames`.

# TOC

| File                                                                                                              | Topic                             |
|-------------------------------------------------------------------------------------------------------------------|-----------------------------------|
| [01_constructors.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/01_constructors.ipynb)   | Creating DataFrames               |
| [02_basicinfo.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/02_basicinfo.ipynb)         | Getting summary information       |
| [03_missingvalues.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/03_missingvalues.ipynb) | Handling missing values           |
| [04_loadsave.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/04_loadsave.ipynb)           | Loading and saving DataFrames     |
| [05_columns.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/05_columns.ipynb)             | Working with columns of DataFrame |
| [06_rows.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/06_rows.ipynb)                   | Working with row of DataFrame     |
| [07_factors.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/07_factors.ipynb)             | Working with categorical data     |
| [08_joins.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/08_joins.ipynb)                 | Joining DataFrames                |
| [09_reshaping.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/09_reshaping.ipynb)         | Reshaping DataFrames              |
| [10_transforms.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/10_transforms.ipynb)       | Transforming DataFrames           |
| [11_performance.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/11_performance.ipynb)     | Performance tips                  |
| [12_pitfalls.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/12_pitfalls.ipynb)     | Possible pitfalls                  |

Changelog:

| Date       | Changes                                                                                           |
|------------|---------------------------------------------------------------------------------------------------|
| 2017-12-05 | Initial release                                                                                   |
| 2017-12-06 | Added description of `insert!`, `merge!`, `empty!`, `categorical!`, `delete!`, `DataFrames.index` |
| 2017-12-09 | Added performance tips                                                                            |
| 2017-12-10 | Added pitfalls                                                                                    |

# Function summary

1. Constructors: `DataFrame`
2. Getting summary: `size`, `nrow`, `ncol`, `length`, `describe`, `showcols`, `names`, `eltypes`, `head`, `tail`
3. Handling missing: `missing` (singleton instance of `Missing`), `ismissing`, `Missings.T`, `skipmissing`, `Missings.replace`, `allowmissing`, `disallowmissing`, `allowmissing!`, `completecases`, `dropmissing`, `dropmissing!`
4. Loading and saving: `CSV` (package), `JLD` (package), `CSV.read`, `CSV.write`, `save` (from `JLD`), `load` (from `JLD`)
5. Working with columns: `rename`, `rename!`, `names!`, `hcat`, `insert!`, `DataFrames.hcat!`, `merge!`, `delete!`, `empty!`, `categorical!`, `DataFrames.index`
6. Working with rows: `sort!`, `sort`, `append!`, `vcat`, `push!`, `view`, `deleterows!`, `unique`, `nonunique`, `unique!`
7. Working with categorical: `categorical`, `cut`, `isordered`, `ordered!`, `levels`, `unique`, `levels!`, `droplevels!`, `get`, `recode`, `recode!`
8. Joining: `join`
9. Reshaping: `stack`, `melt`, `stackdf`, `meltdf`, `unstack`
10. Transforming: `groupby`, `vcat`, `by`, `aggregate`, `eachcol`, `eachrow`, `colwise`
