# # Introducción a DataFrames
# **[Bogumił Kamiński](http://bogumilkaminski.pl/about/), May 23, 2018**
# (Traducción por Miguel Raz Guzmán Macedo, Abril 17, 2021)

using DataFrames 

# ## Manipulando columnas de DataFrames

#-

# ### Renombrando columnas
# 
# Empecemos con un `DataFrame` de `Bool`s y nombres de columnas por default.

x = DataFrame(Bool, 3, 4)

# Con `rename`, creamos un nuevo `DataFrame`; aquí renombramos la columna `:x1` a `:A`. (`rename` sólo acepta colleciones de Pairs.)

rename(x, :x1 => :A)

# Con `rename!` hacemos una transformación in situ.
# 
# Esta vez hemos aplicado una función a cada nombre de columna.

rename!(c -> Symbol(string(c)^2), x)

# Podemos tambíen cambiar el nombre particular de una columna sin conocer el nombre original.
# 
# Aquí cambiamos el nombre de la tercera columna, creando un nuevo `DataFrame`.

rename(x, names(x)[3] => :third)

# Con `names!`., podemos cambiar el nombre de todas las variables.

names!(x, [:a, :b, :c, :d])

# Obtenemos un error si proveemos nombres duplicados

names!(x, fill(:a, 4))

#  A no ser que pasemos el argumento `makeunique=true`, lo cual nos permite pasar nombres duplicados.

names!(x, fill(:a, 4), makeunique=true)

# ### Reorganizar columnas

#-

# Podemos reorganizar el vector `names(x)` como sea necesario, creando un nuevo DataFrame en el proceso.

srand(1234)
x[shuffle(names(x))]

# `permutecols!` estará disponible en la siguiente versión de DataFrames.

#-

# ### Juntando/dividiendo columnas

x = DataFrame([(i,j) for i in 1:3, j in 1:4])

# Con `hcat` (*con*catenación *h*orizontal), podemos juntar 2 `DataFrame`s. `[x y]` también es sintaxis válida pero sólo cuando los DataFrames tienen nombres de columnas únicos.

hcat(x, x, makeunique=true)

# Podemos igual usar `hcat` para agregar una nueva columna - por default se usará el nombre `:x1` para esta columna, entonces se requiere el uso de `makeunique=true`.

y = hcat(x, [1,2,3], makeunique=true)

# También puedes anteponer un vector con `hcat`.

hcat([1,2,3], x, makeunique=true)

# Alternativamente se puede anexar un vector con la siguiente sintaxis. Es menos terso pero es más limpio.

y = [x DataFrame(A=[1,2,3])]

# Hacemos lo mismo pero agregamos la columna `:A` al frente.

y = [DataFrame(A=[1,2,3]) x]

# Una columna también se puede agregar en medio. Aquí se usa un método de fuerza bruta y se crea un nuevo DataFrame.

using BenchmarkTools
@btime [$x[1:2] DataFrame(A=[1,2,3]) $x[3:4]]

# También podemos sar un método especializado in situ de `insert!`. Agreguemos `:newcol` al `DataFrame` `y`.

insert!(y, 2, [1,2,3], :newcol)

# Si quieres insertar la misma columna varias veces, se requiere `makeunique=true` como de costumbre.

insert!(y, 2, [1,2,3], :newcol, makeunique=true)

# Podemos ver que tanto más rápido es insertar una columna con `insert!` que con `hcat` si usamos `@btime`.

@btime insert!(copy($x), 3, [1,2,3], :A)

# Usemos `insert!` para anteponer una columna in situ,

insert!(x, ncol(x)+1, [1,2,3], :A)

# y para anexar una columna in situ igual.

insert!(x, 1, [1,2,3], :B)

# Con `merge!`, juntemos el segundo DataFrame al primero, pero sobreescribiendo duplicados.

df1 = DataFrame(x=1:3, y=4:6)
df2 = DataFrame(x='a':'c', z = 'd':'f', new=11:13)
df1, df2, merge!(df1, df2)

#  Para comparar: une 2 `DataFrame`s pero renombrando los duplicados via `hcat`.

df1 = DataFrame(x=1:3, y=4:6)
df2 = DataFrame(x='a':'c', z = 'd':'f', new=11:13)
hcat(df1, df2, makeunique=true)

# ### Quitando / subponiendo columnas
# 
# Creemos un nuevo `DataFrame` `x` y mostremos algunas maneras de crear DataFrames con un subconjunto de columnas de `x`.

x = DataFrame([(i,j) for i in 1:3, j in 1:5])

# Primero, podemos hacer esto usando el índice

x[[1,2,4,5]]

# ó el nombre de la columna.

x[[:x1, :x4]]

# Podemos escoger quedar o deshechar columnas excluidas por `Bool`. (Necesitamos un vector cuya longitud es el número de columnas orignales de `DataFrame`.)

x[[true, false, true, false, true]]

# Aquí creamos una sola columna de un `DataFrame`,

x[[:x1]]

# Y aquí accesamos el vector contenido en la columna `:x1`.

x[:x1]

# Podemos agarrar el mismo vector por el número de la columna

x[1]

# y borrar todo dentro del `DataFrame` con `empty!`.

empty!(y)

# Ahora creamos una copia de `x` y borramos la 3ra columna de la copia con `delete!`.

z = copy(x)
x, delete!(z, 3)

# ### Modificar columnas por nombre

x = DataFrame([(i,j) for i in 1:3, j in 1:5])

# Con la siguiente sintaxis, la columna preexistente se modifica sin copias.

x[:x1] = x[:x2]
x

# Podemos usar la siguiente sintaxis para agregar una nueva columna al final del `DataFrame`.

x[:A] = [1,2,3]
x

# Una nueva columna se agregará a nuestro `DataFrame` con la siguiente sintaxis también (`7 == ncol(x) + 1`).

x[7] = 11:13
x

# ### Encontrar el nombre de columnas

x = DataFrame([(i,j) for i in 1:3, j in 1:5])

# Podemos revisar si una columna con un nombre dado existe via

:x1 in names(x) 

# y determinar su índice via

findfirst(names(x), :x2)

