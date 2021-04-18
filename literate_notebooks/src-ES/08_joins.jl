# # Introduction to DataFrames
# # Introducción a DataFrames
# **[Bogumił Kamiński](http://bogumilkaminski.pl/about/), Apr 21, 2017**
# (Traducción por Miguel Raz Guzmán Macedo, 18 de Abril 2021)

using DataFrames # cargar paquete

# ## Uniendo DataFrames (Joins)

#-

# ### Preparando DataFrames para un join

x = DataFrame(ID=[1,2,3,4,missing], name = ["Alice", "Bob", "Conor", "Dave","Zed"])
y = DataFrame(id=[1,2,5,6,missing], age = [21,22,23,24,99])
x,y

#-

rename!(x, :ID=>:id) # los nombres de columnas que queremos unir deben ser iguales

# ### Joins estándar: inner, left, right, outer, semi, anti

join(x, y, on=:id) # :inner join por default, los missings se unen

#-

join(x, y, on=:id, kind=:left)

#-

join(x, y, on=:id, kind=:right)

#-

join(x, y, on=:id, kind=:outer)

#-

join(x, y, on=:id, kind=:semi)

#-

join(x, y, on=:id, kind=:anti)

# ### Cross join

## un cross join no requiere un argumento
## produce un producto cartesiano de sus argumentos
function expand_grid(;xs...) # un reemplazo sencillo para expand.grid en R
    reduce((x,y) -> join(x, DataFrame(Pair(y...)), kind=:cross),
           DataFrame(Pair(xs[1]...)), xs[2:end])
end

expand_grid(a=[1,2], b=["a","b","c"], c=[true,false])

# ### Casos complejos de joins

x = DataFrame(id1=[1,1,2,2,missing,missing],
              id2=[1,11,2,21,missing,99],
              name = ["Alice", "Bob", "Conor", "Dave","Zed", "Zoe"])
y = DataFrame(id1=[1,1,3,3,missing,missing],
              id2=[11,1,31,3,missing,999],
              age = [21,22,23,24,99, 100])
x,y

#-

join(x, y, on=[:id1, :id2]) # join de 2 columnas

#-

join(x, y, on=[:id1], makeunique=true) # cuando hay duplicados, se producen todas las combinaciones (:inner join en este caso)

#-

join(x, y, on=[:id1], kind=:semi) # pero no por un :semi join (pues duplicaría filas)

