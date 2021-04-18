# # Introduction to DataFrames
# # Introducción a DataFrames
# **[Bogumił Kamiński](http://bogumilkaminski.pl/about/), May 23, 2018**
# Traducción por Miguel Raz, Abril 17, 2021

using DataFrames # cargar el paquete

# ## Obteniendo información básica de un DataFrame
#
# 
# Empecemos creando un objeto `DataFrame`, llamado `x`, para que podamos aprender como sacarle información.

x = DataFrame(A = [1, 2], B = [1.0, missing], C = ["a", "b"])

# La función estándar `size` nos dice las dimensiones del `DataFrame`,

size(x), size(x, 1), size(x, 2)

# y al igual que `nrow	 y `ncol` de R; `length`; nos da el número de columnas.

nrow(x), ncol(x), length(x)

# `describe` nos da estadísticas descriptivas básicas de nuestro `DataFrame`. 

describe(x)

# Usa `showcols` para obetner información sobre columnas guardadas en un DataFrame.

showcols(x)

# `names` regresa el nombre de todas las columnas,

names(x)

# y `eltypes` el de sus tipos.

eltypes(x)

# Aquí creamos un DataFrame más grande

y = DataFrame(rand(1:10, 1000, 10));

# y usamos `head` para asomarnos a sus primeras filas

head(y)

# y `tail` para sus últimas filas.

tail(y, 3)

# ### Operaciones elementales para asignar y sacar
# 
# Dado un objeto DataFrame llamado `x`, aquí hay 3 maneras de tomar una de sus columnas como un `Vector`:

x[1], x[:A], x[:, 1]

# Para tomar una hilera de un DataFrame, lo indexamos como sigue

x[1, :]

# Podemos agarrar una sola celda o elemento con la misma sintaxis que usamos para elementos de arreglos.

x[1, 1]

# Asignar también se puede hacer con rangos a un escalar,

x[1:2, 1:2] = 1
x

# a un vector de longitud igual al número de filas asignadas,

x[1:2, 1:2] = [1,2]
x

# o a otro DataFrame de tamaño igual.

x[1:2, 1:2] = DataFrame([5 6; 7 8])
x

