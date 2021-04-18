# # Introduction to DataFrames
# # Introducción a DataFrames
# **[Bogumił Kamiński](http://bogumilkaminski.pl/about/), Apr 21, 2018**
# (Traducción por Miguel Raz Guzmán, 18 de Abril de 2021)

using DataFrames 

# ## Trabajando con CategoricalArrays

#-

# ### Constructores

x = categorical(["A", "B", "B", "C"]) # sin orded

#-

y = categorical(["A", "B", "B", "C"], ordered=true) # con orden por default

#-

z = categorical(["A","B","B","C", missing]) # sin orden con `missing`s (valores faltantes)

#-

c = cut(1:10, 5) # ordenados, en contenedores iguales. Es posible renombrar etiquetas y dar `break` customizadas.

#-

by(DataFrame(x=cut(randn(100000), 10)), :x, d -> DataFrame(n=nrow(d)), sort=true) # checar que todo funciona

#-

v = categorical([1,2,2,3,3]) # contiene enteros y no cadenas

#-

Vector{Union{String, Missing}}(z) # a veces hay que convertir de regreso a un vector estándar

# ### Manejando niveles

arr = [x,y,z,c,v]

#-

isordered.(arr) # checar si el arreglo categórico está ordenado

#-

ordered!(x, true), isordered(x) # ordenar x

#-

ordered!(x, false), isordered(x) # y desordanrlo otra vez.
#-

levels.(arr) # niveles de lista

#-

unique.(arr) # incluye `missing`

#-

y[1] < y[2] # puede comparar `y` como si fuese ordenado

#-

v[1] < v[2] # no comparable, `v` no tiene orden aunque contenga enteros

#-

levels!(y, ["C", "B", "A"]) # puedes reordenar niveles, muy útil para CategoricalArrays ordenados

#-

y[1] < y[2] # notar que el orden cambió

#-

levels!(z, ["A", "B"]) # debes declarar todos los niveles presentes

#-

levels!(z, ["A", "B"], allow_missing=true) # a menos que el arreglo subyacente permita `missing`s y obligue a quitar niveles

#-

z[1] = "B"
z # ahora `z` sólo tiene entradas "B"

#-

levels(z) # Pero recuerda los niveles que tuvo antes (esto para mejorar performance)

#-

droplevels!(z) # Así los podemos quitar completamente
levels(z)

# ### Manipulación de datos

x, levels(x)

#-

x[2] = "0"
x, levels(x) # agrega nuevo nivel al final (funcona solo para casos no ordenados)

#-

v, levels(v)

#-

v[1] + v[2] # aunque los datos subyacentes son `Int`s, no podemos operar sobre ellos

#-

Vector{Int}(v) # tienes que recuperar los datos via conversión (potencialmente costoso)

#-

get(v[1]) + get(v[2]) # o sacar un solo valor

#-

get.(v) # esto funciona para arreglos sin `missings`

#-

get.(z) # pero falla si hay valores faltantes

#-

Vector{Union{String, Missing}}(z) # tienes que hacer la conversión

#-

z[1]*z[2], z.^2 # la única excepción son los `CategoricalArrays` basados en `String` - ahí puedes operar con normalidad

#-

recode([1,2,3,4,5,missing], 1=>10) # recodificar algunos valores en el arreglo; existe el equivalente `recode!` in situ

#-

recode([1,2,3,4,5,missing], "a", 1=>10, 2=>20) # aquí proveemos un valor default para los mapos que no se puedieron recodificar

#-

recode([1,2,3,4,5,missing], 1=>10, missing=>"missing") # para recodificar a `Missing` lo tienes que hacer explícitamente

#-

t = categorical([1:5; missing])
t, levels(t)

#-

recode!(t, [1,3]=>2)
t, levels(t) # notar que los níveles se borran después de `recode!`

#-

t = categorical([1,2,3], ordered=true)
levels(recode(t, 2=>0, 1=>-1)) # y si agregas nuevos niveles, se ponen al final en el orden que se declararon

#-

t = categorical([1,2,3,4,5], ordered=true) # el default es que se use el último nivel
levels(recode(t, 300, [1,2]=>100, 3=>200))

# ### Comparaciones

x = categorical([1,2,3])
xs = [x, categorical(x), categorical(x, ordered=true), categorical(x, ordered=true)]
levels!(xs[2], [3,2,1])
levels!(xs[4], [2,3,1])
[a == b for a in xs, b in xs] # todos son iguales - compara sólo por contenidos

#-


signature(x::CategoricalArray) = (x, levels(x), isordered(x)) # Esto es de hecho la asignación completa de un CategoricalArray - TODO?
## todos son distintos, notemos que `x[1]` y `x[2]` no están ordenados pero tiene distintos órdenes de niveles
[signature(a) == signature(b) for a in xs, b in xs]

#-

x[1] < x[2] # no puedes comparar elementos de un CategoricalArray no ordenado

#-

t[1] < t[2] # pero sí para uno ordenado

#-

isless(x[1], x[2]) # isless funciona dentro del mismo CategoricalArray aún si no está ordenado

#-

y = deepcopy(x) # pero no a través de arreglos categóricos
isless(x[1], y[2])

#-

isless(get(x[1]), get(y[2])) # puedes usar `get` para hacer una comparación de contenidos de un `CategoricalArray`

#-

x[1] == y[2] # las pruebas de igualdad funcionan a través de CategoricalArrays

# ### Columnas categóricas en un DataFrame

df = DataFrame(x = 1:3, y = 'a':'c', z = ["a","b","c"])

#-

categorical!(df) # conviertir todos las columnas `eltype(AbstractString)` a columnas categóricas

#-

showcols(df)

#-

categorical!(df, :x) # convertir manualmente `:x` a una columna categórica

#-

showcols(df)

