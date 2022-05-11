# An Introduction to DataFrames.jl

[Bogumił Kamiński](http://bogumilkaminski.pl/about/), December 12, 2021

**The tutorial is for DataFrames.jl 1.3.0**

A brief introduction to basic usage of [DataFrames](https://github.com/JuliaData/DataFrames.jl).

The tutorial contains a specification of the project environment version under
which it should be run. In order to prepare this environment, before using the
tutorial notebooks, while in the project folder run the following command in the
command line:

```
julia -e 'using Pkg; Pkg.activate("."); Pkg.instantiate()'
```

Tested under Julia 1.7.0. The project dependencies are the following:

```
  [69666777] Arrow v2.2.0
  [6e4b80f9] BenchmarkTools v1.2.2
  [336ed68f] CSV v0.9.11
  [324d7699] CategoricalArrays v0.10.2
  [8be319e6] Chain v0.4.10
  [944b1d66] CodecZlib v0.7.0
  [a93c6f00] DataFrames v1.3.0
  [1313f7d8] DataFramesMeta v0.10.0
  [5789e2e9] FileIO v1.11.2
  [da1fdf0e] FreqTables v0.4.5
  [7073ff75] IJulia v1.23.2
  [babc3d20] JDF v0.4.5
  [9da8a3cd] JLSO v2.6.0
  [b9914132] JSONTables v1.0.2
  [86f7a689] NamedArrays v0.9.6
  [2dfb63ee] PooledArrays v1.4.0
  [f3b207a7] StatsPlots v0.14.29
  [bd369af6] Tables v1.6.0
  [a5390f91] ZipFile v0.9.4
  [9a3f8284] Random
  [10745b16] Statistics
```

I will try to keep the material up to date as the packages evolve.

This tutorial covers
[DataFrames.jl](https://github.com/JuliaData/DataFrames.jl)
and [CategoricalArrays.jl](https://github.com/JuliaData/CategoricalArrays.jl),
as they constitute the core of [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl)
along with selected file reading and writing packages.

In the last [extras](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/13_extras.ipynb)
part mentions *selected* functionalities of *selected* useful packages that I find useful for data manipulation, currently those are:
[FreqTables.jl](https://github.com/nalimilan/FreqTables.jl),
[DataFramesMeta.jl](https://github.com/JuliaStats/DataFramesMeta.jl)
[StatsPlots.jl](https://github.com/JuliaPlots/StatsPlots.jl).

# Setting up Jupyter Notebook for work with DataFrames.jl

By default Jupyter Notebook will limit the number of rows and columns when
displaying a data frame to roughly fit the screen size (like in the REPL).

You can override this behavior by setting `ENV["COLUMNS"]` or `ENV["LINES"]`
variables to hold the maximum width and height of output in characters
respectively when running a notebook. Alternatively you can add the following
entry `"COLUMNS": "1000", "LINES": "100"` to `"env"` variable in your Jupyter
kernel file. See
[here](https://jupyter-client.readthedocs.io/en/stable/kernels.html) for
information about location and specification of Jupyter kernels.

# TOC

| File                                                                                                              | Topic                             |
|-------------------------------------------------------------------------------------------------------------------|-----------------------------------|
| [01_constructors.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/01_constructors.ipynb)   | Creating DataFrame and conversion |
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
| [12_pitfalls.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/12_pitfalls.ipynb)           | Possible pitfalls                 |
| [13_extras.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/13_extras.ipynb)               | Additional interesting packages   |

Changelog:

| Date       | Changes                                                      |
| ---------- | ------------------------------------------------------------ |
| 2017-12-05 | Initial release                                              |
| 2017-12-06 | Added description of `insert!`, `merge!`, `empty!`, `categorical!`, `delete!`, `DataFrames.index` |
| 2017-12-09 | Added performance tips                                       |
| 2017-12-10 | Added pitfalls                                               |
| 2017-12-18 | Added additional worthwhile packages: *FreqTables* and *DataFramesMeta* |
| 2017-12-29 | Added description of `filter` and `filter!`                  |
| 2017-12-31 | Added description of conversion to `Matrix`                  |
| 2018-04-06 | Added example of extracting a row from a `DataFrame`         |
| 2018-04-21 | Major update of whole tutorial                               |
| 2018-05-01 | Added `byrow!` example                                       |
| 2018-05-13 | Added `StatPlots` package to extras                          |
| 2018-05-23 | Improved comments in sections 1 do 5 by [Jane Herriman](https://github.com/xorJane) |
| 2018-07-25 | Update to 0.11.7 release                                     |
| 2018-08-25 | Update to Julia 1.0 release: sections 1 to 10                |
| 2018-08-29 | Update to Julia 1.0 release: sections 11, 12 and 13          |
| 2018-09-05 | Update to Julia 1.0 release: FreqTables section              |
| 2018-09-10 | Added CSVFiles section to chapter on load/save               |
| 2018-09-26 | Updated to DataFrames 0.14.0                                 |
| 2018-10-04 | Updated to DataFrames 0.14.1, added `haskey` and `repeat`    |
| 2018-12-08 | Updated to DataFrames 0.15.2                                 |
| 2019-01-03 | Updated to DataFrames 0.16.0, added serialization instructions |
| 2019-01-18 | Updated to DataFrames 0.17.0, added `passmissing` |
| 2019-01-27 | Added Feather.jl file read/write |
| 2019-01-30 | Renamed StatPlots.jl to StatsPlots.jl and added Tables.jl|
| 2019-02-08 | Added `groupvars` and `groupindices` functions|
| 2019-04-27 | Updated to DataFrames 0.18.0, dropped JLD2.jl |
| 2019-04-30 | Updated handling of missing values description |
| 2019-07-16 | Updated to DataFrames 0.19.0 |
| 2019-08-14 | Added JSONTables.jl and `Tables.columnindex` |
| 2019-08-16 | Added Project.toml and Manifest.toml |
| 2019-08-26 | Update to Julia 1.2 and DataFrames 0.19.3 |
| 2019-08-29 | Add example how to compress/decompress CSV file using CodecZlib |
| 2019-08-30 | Add examples of JLSO.jl and ZipFile.jl by [xiaodaigh](https://github.com/xiaodaigh) |
| 2019-11-03 | Add examples of JDF.jl by [xiaodaigh](https://github.com/xiaodaigh) |
| 2019-12-08 | Updated to DataFrames 0.20.0 |
| 2020-05-06 | Updated to DataFrames 0.21.0 (except load/save and extras) |
| 2020-11-20 | Updated to DataFrames 0.22.0 (except DataFramesMeta.jl which does not work yet) |
| 2020-11-26 | Updated to DataFramesMeta.jl 0.6; update by @pdeffebach |
| 2021-05-15 | Updated to DataFrames.jl 1.1.1 |
| 2021-05-15 | Updated to DataFrames.jl 1.2 and DataFramesMeta.jl 0.8, added Chain.jl instead of Pipe.jl |
| 2021-12-12 | Updated to DataFrames.jl 1.3 |

# Core functions summary

1. Constructors: `DataFrame`, `DataFrame!`, `Tables.rowtable`, `Tables.columntable`, `Matrix`, `eachcol`, `eachrow`, `Tables.namedtupleiterator`, `empty`, `empty!`
2. Getting summary: `size`, `nrow`, `ncol`, `describe`, `names`, `eltypes`, `first`, `last`, `getindex`, `setindex!`, `@view`, `isapprox`
3. Handling missing: `missing` (singleton instance of `Missing`), `ismissing`, `nonmissingtype`, `skipmissing`, `replace`, `replace!`, `coalesce`, `allowmissing`, `disallowmissing`, `allowmissing!`, `completecases`, `dropmissing`, `dropmissing!`, `disallowmissing`, `disallowmissing!`, `passmissing`
4. Loading and saving: `CSV` (package), `CSVFiles` (package), `Serialization` (module), `CSV.read`, `CSV.write`, `save`, `load`, `serialize`, `deserialize`, `Arrow.write`, `Arrow.Table` (from Arrow.jl package), `JSONTables` (package), `arraytable`, `objecttable`, `jsontable`, `CodecZlib` (module), `GzipCompressorStream`, `GzipDecompressorStream`, `JDF.jl` (package), `JDF.save`, `JDF.load`, `JLSO.jl` (package), `JLSO.save`, `JLSO.load`, `ZipFile.jl` (package), `ZipFile.reader`, `ZipFile.writer`, `ZipFile.addfile`
5. Working with columns: `rename`, `rename!`, `hcat`, `insertcols!`, `categorical!`, `columnindex`, `hasproperty`, `select`, `select!`, `transform`, `transform!`, `combine`, `Not`, `All`, `Between`, `ByRow`, `AsTable`
6. Working with rows: `sort!`, `sort`, `issorted`, `append!`, `vcat`, `push!`, `view`, `filter`, `filter!`, `deleteat!`, `unique`, `nonunique`, `unique!`, `repeat`, `parent`, `parentindices`, `flatten`, `@chain` (from `Chain.jl` package), `only`, `subset`, `subset!`
7. Working with categorical: `categorical`, `cut`, `isordered`, `ordered!`, `levels`, `unique`, `levels!`, `droplevels!`, `unwrap`, `recode`, `recode!`
8. Joining: `innerjoin`, `leftjoin`, `leftjoin!`, `rightjoin`, `outerjoin`, `semijoin`, `antijoin`, `crossjoin`
9. Reshaping: `stack`, `unstack`
10. Transforming: `groupby`, `mapcols`, `parent`, `groupcols`, `valuecols`, `groupindices`, `keys` (for `GroupedDataFrame`), `combine`, `select`, `select!`, `transform`, `transform!`, `@chain` (from `Chain.jl` package)
11. Extras:
    * [FreqTables](https://github.com/nalimilan/FreqTables.jl): `freqtable`, `prop`, `Name`
    * [DataFramesMeta](https://github.com/JuliaStats/DataFramesMeta.jl): `@with`, `@subset`, `@select`, `@transform`, `@orderby`, `@by`, `@combine`, `@eachrow`, `@newcol`, `^`, `$`
    * [StatsPlots](https://github.com/JuliaPlots/StatsPlots.jl): `@df`, `plot`, `density`, `histogram`,`boxplot`, `violin`
