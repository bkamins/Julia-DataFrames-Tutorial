# # Introduction to DataFrames
# # Introducción a DataFrames
# **[Bogumił Kamiński](http://bogumilkaminski.pl/about/), Apr 21, 2018**
# (Traducción por Miguel Raz Guzmán Macedo, 18 de abril de 2021)

using DataFrames # cargar paquetería

# ## "Split-apply-combine" - Dividir, aplicar, combinar

x = DataFrame(id=[1,2,3,4,1,2,3,4], id2=[1,2,1,2,1,2,1,2], v=rand(8))

#-

gx1 = groupby(x, :id)

#-

gx2 = groupby(x, [:id, :id2])

#-

vcat(gx2...) # de regreso al DataFrame original

#-

x = DataFrame(id = [missing, 5, 1, 3, missing], x = 1:5)

#-

showall(groupby(x, :id)) # por default los grupos incluyen valores faltantes (`missing`) y no están ordenados

#-

showall(groupby(x, :id, sort=true, skipmissing=true)) # pero se puede cambiar :)

#-

x = DataFrame(id=rand('a':'d', 100), v=rand(100));
by(x, :id, y->mean(y[:v])) # aplica una función a cada grupo de un DataFrame

#-

by(x, :id, y->mean(y[:v]), sort=true) # podemos ordenar el output

#-

by(x, :id, y->DataFrame(res=mean(y[:v]))) # de esta manera podemos fijar el nombre de una columna - `DataFramesMeta @by` es mejor

#-

x = DataFrame(id=rand('a':'d', 100), x1=rand(100), x2=rand(100))
aggregate(x, :id, sum) # aplica la función sobre todas las columnas de un DataFarme en grupos dados por `:id`

#-

aggregate(x, :id, sum, sort=true) # también se puede ordenar

# *We omit the discussion of of map/combine as I do not find them very useful (better to use by)*
# *Omitimos la discusión de `map/combine/` pues no las encuentre tan útiles - mejor usar `by`*

x = DataFrame(rand(3, 5))

#-

map(mean, eachcol(x)) # mapea una función a cada columna y regresa un DataFrame

#-

foreach(c -> println(c[1], ": ", mean(c[2])), eachcol(x)) # una iteración a secas regresa una tupla con nombres columnares y valores

#-

colwise(mean, x) # `colwise` es similar, pero produce un vector

#-

x[:id] = [1,1,2]
colwise(mean,groupby(x, :id)) # y funciona en un `GroupedDataFrame`

#-

map(r -> r[:x1]/r[:x2], eachrow(x)) # ahora el valor regresado es un `DataFrameRow` el cual funciona similar a un `DataFrame` de una sola fila

