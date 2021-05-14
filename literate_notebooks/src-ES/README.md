# Una Introducción a DataFrames

[Bogumił Kamiński](http://bogumilkaminski.pl/about/), November 2020, 2020
(Traducción por Miguel Raz Guzmán Macedo Abril 2021)

**Este tutorial es para DataFrames 0.22.0**

Una breve introducción al uso de los [DataFrames](https://github.com/JuliaData/DataFrames.jl).

Nota: si ya sabes como usar datos tabulares en otros lenguajes, notoriamente `pandas` en Python o `dplyr` en R, y Stata,
este paquete te resultará muy familiar. Aún así hay detalles en donde difieron las funcionalidades principales,
y vale la pena leer los siguientes materiales para evitar confusión:

- un `cheatsheet` [de Julia <-> Python <-> Matlab](https://cheatsheets.quantecon.org/) de Quantecon
- la documentación comparativa de DataFrames.jl [con los otros lenguajes](https://dataframes.juliadata.org/latest/man/comparisons/#Comparisons)

Este tutorial contiene una especificación de la versión del proyecto bajo el cual
debería correr. Para preparar este ambiente, antes de usar los notebooks, hay
que correr la siguiente línea en el folder del proyecto:

```
julia -e 'using Pkg; Pkg.activate("."); Pkg.instantiate()'
```

Corrido en Julia 1.5.3. Las dependencias del proyecto son las siguientes:

```
  [69666777] Arrow v1.0.1
  [6e4b80f9] BenchmarkTools v0.5.0
  [336ed68f] CSV v0.8.2
  [324d7699] CategoricalArrays v0.9.0
  [944b1d66] CodecZlib v0.7.0
  [a93c6f00] DataFrames v0.22.1
  [1313f7d8] DataFramesMeta v0.6.0
  [5789e2e9] FileIO v1.4.4
  [da1fdf0e] FreqTables v0.4.2
  [7073ff75] IJulia v1.23.0
  [babc3d20] JDF v0.2.20
  [9da8a3cd] JLSO v2.4.0
  [b9914132] JSONTables v1.0.0
  [86f7a689] NamedArrays v0.9.4
  [b98c9c47] Pipe v1.3.0
  [2dfb63ee] PooledArrays v0.5.3
  [f3b207a7] StatsPlots v0.14.17
  [bd369af6] Tables v1.2.1
  [a5390f91] ZipFile v0.9.3
  [9a3f8284] Random
  [10745b16] Statistics
```

Trataré de mantener el material actualizado con la evolución de los paquetes.

Este tutorial cubre 
[DataFrames](https://github.com/JuliaData/DataFrames.jl)
y [CategoricalArrays](https://github.com/JuliaData/CategoricalArrays.jl),
pues constituyen la mayor parte de  [DataFrames](https://github.com/JuliaData/DataFrames.jl)
en conjunto con otras paqueterías específicas para leer y escribir archivos.

En los [extras](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/13_extras.ipynb)
se da mención *especial* de funcionalidades *selectas* sobre paqueterías que he encontrado ser
particularmente útiles para la manipulación de datos. Esos paquetes son:
[FreqTables](https://github.com/nalimilan/FreqTables.jl),
[DataFramesMeta](https://github.com/JuliaStats/DataFramesMeta.jl) (depende del DataFrames.jl 0.22 release),
[StatsPlots](https://github.com/JuliaPlots/StatsPlots.jl).

# Inicializando el Jupyter Notebook para que funcione con DataFrames.jl

Por default los notebooks de Jupyter limitarán las filas y columnas cuando 
muestren un data frame para que quepa en la pantalla (similar al REPL).


Puedes cambiar esto fijando las variables`ENV["COLUMNS"]` o `ENV["LINES"]`
para que contengan la dimensiones máximas del output de caractéres al correr en notebook.
Alternativamente, se puede agregar `"COLUMNS": "1000", "LINES": "100"` a la varaible `"env"` variable
en el archivo kernel de Jupyter. Ver [aquí](https://jupyter-client.readthedocs.io/en/stable/kernels.html) 
para más información sobre la ubicación y especificación de los kernels de Jupyter.

# Tabla de Contenidos

| Archivo                                                                                                              | Tema                             |
|-------------------------------------------------------------------------------------------------------------------|-----------------------------------|
| [01_constructors.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/01_constructors.ipynb)   | Creación y construcción de DataFrames |
| [02_basicinfo.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/02_basicinfo.ipynb)         | Consiguiendo información       |
| [03_missingvalues.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/03_missingvalues.ipynb) | Manejo de valores faltantes           |
| [04_loadsave.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/04_loadsave.ipynb)           | Cargar y guardar DataFrames     |
| [05_columns.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/05_columns.ipynb)             | Trabajando columnas de DataFrames |
| [06_rows.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/06_rows.ipynb)                   | Trabajando con filas de DataFrames     |
| [07_factors.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/07_factors.ipynb)             | Trabajando con datos categóricos     |
| [08_joins.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/08_joins.ipynb)                 |  Uniendo DataFrames (Joins)                |
| [09_reshaping.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/09_reshaping.ipynb)         | Reorganizando DataFrames |
| [10_transforms.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/10_transforms.ipynb)       | Transformando DataFrames           |
| [11_performance.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/11_performance.ipynb)     | Tips de performance                  |
| [12_pitfalls.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/12_pitfalls.ipynb)           | Posibles errores y descuidos                 |
| [13_extras.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/13_extras.ipynb)               | Paquetes adicionales interesantes   |

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

# Resumen de funciones clave:
1. Constructors: `DataFrame`, `DataFrame!`, `Tables.rowtable`, `Tables.columntable`, `Matrix`, `eachcol`, `eachrow`, `Tables.namedtupleiterator`, `empty`, `empty!`
2. Descripciones: `size`, `nrow`, `ncol`, `describe`, `names`, `eltypes`, `first`, `last`, `getindex`, `setindex!`, `@view`, `isapprox`
3. Manejo de missing: `missing` (tipo singulete de `Missing`), `ismissing`, `nonmissingtype`, `skipmissing`, `replace`, `replace!`, `coalesce`, `allowmissing`, `disallowmissing`, `allowmissing!`, `completecases`, `dropmissing`, `dropmissing!`, `disallowmissing`, `disallowmissing!`, `passmissing`
4.  Cargando y guardando archivos: `CSV` (paquete), `CSVFiles` (paquete), `Serialization` (módulo), `CSV.read`, `CSV.write`, `save`, `load`, `serialize`, `deserialize`, `Arrow.write`, `Arrow.Table` (del paquete Arrow.jl), `JSONTables` (paquete), `arraytable`, `objecttable`, `jsontable`, `CodecZlib` (módulo), `GzipCompressorStream`, `GzipDecompressorStream`, `JDF.jl` (paquete), `JDF.savejdf`, `JDF.loadjdf`, `JLSO.jl` (paquete), `JLSO.save`, `JLSO.load`, `ZipFile.jl` (paquete), `ZipFile.reader`, `ZipFile.writer`, `ZipFile.addfile`
5. Trabajando con columnas: `rename`, `rename!`, `hcat`, `insertcols!`, `categorical!`, `columnindex`, `hasproperty`, `select`, `select!`, `transform`, `transform!`, `combine`, `Not`, `All`, `Between`, `ByRow`, `AsTable`
6. Trabajando con filas: `sort!`, `sort`, `issorted`, `append!`, `vcat`, `push!`, `view`, `filter`, `filter!`, `delete!`, `unique`, `nonunique`, `unique!`, `repeat`, `parent`, `parentindices`, `flatten`, `@pipe` (del paquete `Pipe.jl`), `only`
7. Trabajando con datos categóricos: `categorical`, `cut`, `isordered`, `ordered!`, `levels`, `unique`, `levels!`, `droplevels!`, `get`, `recode`, `recode!`
8. Joins: `innerjoin`, `leftjoin`, `rightjoin`, `outerjoin`, `semijoin`, `antijoin`, `crossjoin`
9. Reorganizando: `stack`, `unstack`
10. Transformadas: `groupby`, `mapcols`, `parent`, `groupcols`, `valuecols`, `groupindices`, `keys` (for `GroupedDataFrame`), `combine`, `select`, `select!`, `transform`, `transform!`, `@pipe` (del paquete `Pipe.jl`)
11. Extras:
    * [FreqTables](https://github.com/nalimilan/FreqTables.jl): `freqtable`, `prop`, `Name`
    * [DataFramesMeta](https://github.com/JuliaStats/DataFramesMeta.jl): `@with`, `@where`, `@select`, `@transform`, `@orderby`, `@linq`, `@by`, `@combine`, `@eachrow`, `@newcol`, `^`, `cols`
    * [StatsPlots](https://github.com/JuliaPlots/StatsPlots.jl): `@df`, `plot`, `density`, `histogram`,`boxplot`, `violin`
