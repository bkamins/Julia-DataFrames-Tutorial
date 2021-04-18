# Uma introdução de DataFrames

[Bogumił Kamiński](http://bogumilkaminski.pl/about/), Novembro 2020. Tradução de [Jose Storopoli](https://storopoli.io).

**Esse tutorial é para DataFrames 0.22.1**

Uma breve introdução sobre o uso básico de [DataFrames](https://github.com/JuliaData/DataFrames.jl).

Esse tutorial contém uma especificação do ambiente do projeto no qual
deve ser executado. Para preparar esse ambiente, antes de usar os *notebooks* do tutorial,
execute o seguinte comando no diretório raiz do projeto:

```
julia -e 'using Pkg; Pkg.activate("."); Pkg.instantiate()'
```

Testado em Julia 1.6.0. As dependências do projeto são:

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

Tentarei manter o material atualizado conforme os pacotes evoluem com novas versões.

Este tutorial cobre
[DataFrames](https://github.com/JuliaData/DataFrames.jl)
e [CategoricalArrays](https://github.com/JuliaData/CategoricalArrays.jl),
pois constituem o núcleo de [DataFrames](https://github.com/JuliaData/DataFrames.jl)
junto com pacotes selecionados de leitura e gravação de arquivos.

No conteúdo [extras](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/13_extras.ipynb)
se menciona *funcionalidades* selecionadas de pacotes *selecionados* que considero úteis para manipulação de dados, atualmente são:
[FreqTables](https://github.com/nalimilan/FreqTables.jl),
[DataFramesMeta](https://github.com/JuliaStats/DataFramesMeta.jl) (aguardando uma atualização para oferecer suporte à versão DataFrames.jl 0.22),
e [StatsPlots](https://github.com/JuliaPlots/StatsPlots.jl).

Muitos devem ter tido contato com dados tabulares em outras linguagens, notoriamente Python com `pandas`
ou R com `dplyr`. Para facilitar a adoção de Julia e DataFrames.jl, a documentação do pacote
DataFrames.jl possui [uma seção com comparações das principais funcionalidades e operações do
DataFrames.jl em relação à `pandas`, `dplyr` e
Stata](https://dataframes.juliadata.org/latest/man/comparisons/#Comparisons).

# Configurando Jupyter Notebook para trabalhar com DataFrames.jl

Por padrão, o Jupyter Notebook limitará o número de linhas e colunas quando
exibindo um *data frame* para caber aproximadamente no tamanho da tela (similar ao REPL).

Você pode substituir este comportamento definindo as variáveis `ENV["COLUMNS"]` ou
`ENV["LINES"]` para manter a largura e altura máximas de saída em caracteres
respectivamente ao executar um notebook. Alternativamente, você pode adicionar a seguinte
entrada `"COLUMNS": "1000", "LINES": "100"` para variável `"env"` em seu
arquivo de kernel Jupyter. Veja
[aqui](https://jupyter-client.readthedocs.io/en/stable/kernels.html) para
informações sobre como localizar e especificar kernels Jupyter.


# Índice

| Arquivo                                                                                                           | Tema                                         |
|-------------------------------------------------------------------------------------------------------------------|----------------------------------------------|
| [01_constructors.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/01_constructors.ipynb)   | Criando `DataFrame` e conversões             |
| [02_basicinfo.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/02_basicinfo.ipynb)         | Obtendo informações resumidas                |
| [03_missingvalues.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/03_missingvalues.ipynb) | Lidando com valores faltantes `missing`      |
| [04_loadsave.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/04_loadsave.ipynb)           | Carregando e salvando `DataFrames`           |
| [05_columns.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/05_columns.ipynb)             | Manipulando colunas de `DataFrame`           |
| [06_rows.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/06_rows.ipynb)                   | Manipulando linhas de `DataFrame`            |
| [07_factors.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/07_factors.ipynb)             | Manipulando dados categóricos (qualitativos) |
| [08_joins.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/08_joins.ipynb)                 | Juntando (*join*) `DataFrames`               |
| [09_reshaping.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/09_reshaping.ipynb)         | Redimensionamento `DataFrames`               |
| [10_transforms.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/10_transforms.ipynb)       | Transformando `DataFrames`                   |
| [11_performance.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/11_performance.ipynb)     | Dicas de desempenho                          |
| [12_pitfalls.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/12_pitfalls.ipynb)           | Possíveis armadilhas                         |
| [13_extras.ipynb](https://github.com/bkamins/Julia-DataFrames-Tutorial/blob/master/13_extras.ipynb)               | Pacotes adicionais interessantes             |

*Changelog*:

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
| 2021-04-18 | First Portuguese translation by @storopoli |

# Sumário das funções-chave

1. Construtores: `DataFrame`, `DataFrame!`, `Tables.rowtable`, `Tables.columntable`, `Matrix`, `eachcol`, `eachrow`, `Tables.namedtupleiterator`, `empty`, `empty!`
2. Obtendo resumos: `size`, `nrow`, `ncol`, `describe`, `names`, `eltypes`, `first`, `last`, `getindex`, `setindex!`, `@view`, `isapprox`
3. Lidando com dados faltantes: `missing` (singleton instance of `Missing`), `ismissing`, `nonmissingtype`, `skipmissing`, `replace`, `replace!`, `coalesce`, `allowmissing`, `disallowmissing`, `allowmissing!`, `completecases`, `dropmissing`, `dropmissing!`, `disallowmissing`, `disallowmissing!`, `passmissing`
4. Carregando e salvando: `CSV` (package), `CSVFiles` (package), `Serialization` (module), `CSV.read`, `CSV.write`, `save`, `load`, `serialize`, `deserialize`, `Arrow.write`, `Arrow.Table` (from Arrow.jl package), `JSONTables` (package), `arraytable`, `objecttable`, `jsontable`, `CodecZlib` (module), `GzipCompressorStream`, `GzipDecompressorStream`, `JDF.jl` (package), `JDF.savejdf`, `JDF.loadjdf`, `JLSO.jl` (package), `JLSO.save`, `JLSO.load`, `ZipFile.jl` (package), `ZipFile.reader`, `ZipFile.writer`, `ZipFile.addfile`
5. Manipulando colunas: `rename`, `rename!`, `hcat`, `insertcols!`, `categorical!`, `columnindex`, `hasproperty`, `select`, `select!`, `transform`, `transform!`, `combine`, `Not`, `All`, `Between`, `ByRow`, `AsTable`
6. Manipulando linhas: `sort!`, `sort`, `issorted`, `append!`, `vcat`, `push!`, `view`, `filter`, `filter!`, `delete!`, `unique`, `nonunique`, `unique!`, `repeat`, `parent`, `parentindices`, `flatten`, `@pipe` (from `Pipe` package), `only`
7. Manipulando dados categóricos: `categorical`, `cut`, `isordered`, `ordered!`, `levels`, `unique`, `levels!`, `droplevels!`, `get`, `recode`, `recode!`
8. Juntando: `innerjoin`, `leftjoin`, `rightjoin`, `outerjoin`, `semijoin`, `antijoin`, `crossjoin`
9. Redimensionamento: `stack`, `unstack`
10. Transformando: `groupby`, `mapcols`, `parent`, `groupcols`, `valuecols`, `groupindices`, `keys` (for `GroupedDataFrame`), `combine`, `select`, `select!`, `transform`, `transform!`, `@pipe` (from `Pipe` package)
11. Extras:
    * [FreqTables](https://github.com/nalimilan/FreqTables.jl): `freqtable`, `prop`, `Name`
    * [DataFramesMeta](https://github.com/JuliaStats/DataFramesMeta.jl): `@with`, `@where`, `@select`, `@transform`, `@orderby`, `@linq`, `@by`, `@combine`, `@eachrow`, `@newcol`, `^`, `cols`
    * [StatsPlots](https://github.com/JuliaPlots/StatsPlots.jl): `@df`, `plot`, `density`, `histogram`,`boxplot`, `violin`
