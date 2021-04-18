# # Introduction to DataFrames
# # Introducción a DataFrames
# **[Bogumił Kamiński](http://bogumilkaminski.pl/about/), Apr 21, 2018**
# (Traducción por Miguel Raz Guzmán Macedo, 18 de Abril de 2021)

using DataFrames

# ## Posibles errors comunes

#-

# ### Hay que saber qué se copia cuando se crea un `DataFrame`

x = DataFrame(rand(3, 5))

#-

y = DataFrame(x)
x === y # no se hace ninguna copia

#-

y = copy(x)
x === y # no es el mismo objeto

#-

all(x[i] === y[i] for i in ncol(x)) # pero las columnas son las mismas

#-

x = 1:3; y = [1, 2, 3]; df = DataFrame(x=x,y=y) # lo mismo sucedo cuando creamos arreglos o asignamos columnas, excepto por rangos

#-

y === df[:y] # es el mismo objeto

#-

typeof(x), typeof(df[:x]) # un rango se convierte en un vector

# ### No hay que modificar el arreglo original de `GroupedDataFrame`

x = DataFrame(id=repeat([1,2], outer=3), x=1:6)
g = groupby(x, :id)

#-

x[1:3, 1]=[2,2,2]
g # pues, está mal por ahora - `g` es sólo un `view`

# ### Recuerda: peudes filtrar columnas de un `DataFrame` usando booleans

srand(1)
x = DataFrame(rand(5, 5))

#-

x[x[:x1] .< 0.25] # oops, filtramos columnas y no filas, por accidente, pues puedes seleccionar columnas usando booleanos

#-

x[x[:x1] .< 0.25, :] # esto es probablemente es lo que queríamos

# ### Seleccionar columnas de un DataFrame crea un alias si no se copia explícitamente

x = DataFrame(a=1:3)
x[:b] = x[1] # alias
x[:c] = x[:, 1] # igual esalias
x[:d] = x[1][:] # copia 
x[:e] = copy(x[1]) # copia explícita
display(x)
x[1,1] = 100
display(x)


