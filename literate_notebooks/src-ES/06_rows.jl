# # Introducción a DataFrames
# **[Bogumił Kamiński](http://bogumilkaminski.pl/about/), Apr 21, 2018**
# (Traducción por Miguel Raz, Abril 18, 2021)

using DataFrames # cargar paquete
srand(1);

# ## Manipulando filas de DataFrames

#-

# ### Reordenando filas

x = DataFrame(id=1:10, x = rand(10), y = [zeros(5); ones(5)]) # y esperamos que x[:x] no esté ordenado

#-

issorted(x), issorted(x, :x) # checamos si el DataFrame o un subconjunto de sus columnas están ordenadas.

#-

sort!(x, :x) # ordenar in situ

#-

y = sort(x, :id) # nuevo DataFrame

#-

sort(x, (:y, :x), rev=(true, false)) # ordenaro por dos columnas, la primera en orden descendiente y la segunda en ascendiente

#-

sort(x, (order(:y, rev=true), :x)) # igual que arriba

#-

sort(x, (order(:y, rev=true), order(:x, by=v->-v))) # más cosas muy sofisticadas para ordenar

#-

x[shuffle(1:10), :] # reorganizar filas (aquí aleatoriamente)

#-

sort!(x, :id)
x[[1,10],:] = x[[10,1],:] # intercambiar filas
x

#-

x[1,:], x[10,:] = x[10,:], x[1,:] # y otra vez
x

# ### Unir/añadir filasMerging/adding rows

x = DataFrame(rand(3, 5))

#-

[x; x] # unir por filas - los DataFrames deben tener los mismos nombres de columnas. Esto equivale a usar `vcat`.

#-

y = x[reverse(names(x))] # asignar `y` con otro orden para los nombres

#-

vcat(x, y) # Equivalente, pues `vcat` matchea las columnas con nombres iguales

#-

vcat(x, y[1:3]) # pero los nombres de las columnas deben ser iguales

#-

append!(x, x) # lo mismo pero modificando x

#-

append!(x, y) # aquí los nombres de las columnas deben ser match exactos

#-

push!(x, 1:5) # agrega 1 fila a `x` al final; debe dar los valores y tipos correctos
x

#-

push!(x, Dict(:x1=> 11, :x2=> 12, :x3=> 13, :x4=> 14, :x5=> 15)) # sirve igual con diccionarios
x

# ### Quitar/Subponer filas

x = DataFrame(id=1:10, val='a':'j')

#-

x[1:2, :] # por su índice

#-

view(x, 1:2) # igual pero con un `view`

#-

x[repmat([true, false], 5), :] # por `Bool`, requiere longitud exacta

#-

view(x, repmat([true, false], 5), :) # `view` otra vez

#-

deleterows!(x, 7) # borrar 1 fila

#-

deleterows!(x, 6:7) # borrar una colleción de filas

#-

x = DataFrame([1:4, 2:5, 3:6])

#-

filter(r -> r[:x1] > 2.5, x) # crear un nuevo DataFrame donde la función de filtrado opera sobre un `DataFrameRow`

#-

## Modificar `x` in situ, con sintaxis de `do-block`
filter!(x) do r
    if r[:x1] > 2.5
        return r[:x2] < 4.5
    end
    r[:x3] < 3.5
end

# ### Desduplicación

x = DataFrame(A=[1,2], B=["x","y"])
append!(x, x)
x[:C] = 1:4
x

#-

unique(x, [1,2]) # Sacar la primera fila única dado un índice

#-

unique(x) # Ahora vemos las filas

#-

nonunique(x, :A) # Sacar indicadores de filas no únicas

#-

unique!(x, :B) # modificar x in situ

# ### Extraer una fila de `DataFrame` a un vector

x = DataFrame(x=[1,missing,2], y=["a", "b", missing], z=[true,false,true])

#-

cols = [:x, :y]
[x[1, col] for col in cols] # subconjunto de columnas

#-

[[x[i, col] for col in names(x)] for i in 1:nrow(x)] # vector de vectores, cada entrada contiene una sola fila de `x`

#-

Tuple(x[1, col] for col in cols) # construcción similar para tuplas (`Tuples`), y tuplas nombradas (`NamedTuples`) post Julia 0.7.

