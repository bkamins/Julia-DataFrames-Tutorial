# # Introdução ao DataFrames
# **[Bogumił Kamiński](http://bogumilkaminski.pl/about/), 23 de Maio de 2018**
#
# Tradução de [Jose Storopoli](https://storopoli.io).

using DataFrames # carregar o pacote

# ## Juntando (*join*) DataFrames

# -

# ### Preparando DataFrames para um *join*

x = DataFrame(ID=[1,2,3,4,missing], name=["Alice", "Bob", "Conor", "Dave","Zed"])
y = DataFrame(id=[1,2,5,6,missing], age=[21,22,23,24,99])
x, y

# -

rename!(x, :ID => :id) # os nomes das colunas nas quais queremos dar *join* devem ser os mesmos

# ### *Joins* padrões: *inner*, *left*, *right*, *outer*, *semi*, *anti*

join(x, y, on=:id) # :inner *join* por padrão, `missing`s são considerados

# -

join(x, y, on=:id, kind=:left)

# -

join(x, y, on=:id, kind=:right)

# -

join(x, y, on=:id, kind=:outer)

# -

join(x, y, on=:id, kind=:semi)

# -

join(x, y, on=:id, kind=:anti)

# ### *Cross-join*

## *cross-join* não requer argumentos
## pois produz um produto Cartesiano
function expand_grid(;xs...) # uma substituição simples do expand.grid em R
    reduce((x, y) -> join(x, DataFrame(Pair(y...)), kind=:cross),
           DataFrame(Pair(xs[1]...)), xs[2:end])
end

expand_grid(a=[1,2], b=["a","b","c"], c=[true,false])

# ### Casos complexos de *joins*

x = DataFrame(id1=[1,1,2,2,missing,missing],
              id2=[1,11,2,21,missing,99],
              name=["Alice", "Bob", "Conor", "Dave","Zed", "Zoe"])
y = DataFrame(id1=[1,1,3,3,missing,missing],
              id2=[11,1,31,3,missing,999],
              age=[21,22,23,24,99, 100])
x, y

# -

join(x, y, on=[:id1, :id2]) # *join* em duas colunas

# -

join(x, y, on=[:id1], makeunique=true) # com duplicados, todas as combinações são produzidas (aqui :inner *join*)

# -

join(x, y, on=[:id1], kind=:semi) # o que não ocorre em :semi *join* (pois duplicaria linhas)
