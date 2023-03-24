# # Introducción a DataFrames
# **[Bogumił Kamiński](http://bogumilkaminski.pl/about/), Apr 21, 2018**
# (Traducido por Miguel Raz Guzmán Macedo, 18 de Abril de 2021)

using DataFrames 

# ## Reorganización de DataFrames

#-

# ### De ancho a largo

x = DataFrame(id=[1,2,3,4], id2=[1,1,2,2], M1=[11,12,13,14], M2=[111,112,113,114])

#-

melt(x, :id, [:M1, :M2]) # primero pasamos las variables de identificación y luego las medimos; `meltdf` (melt = derretir) crea un `view`

#-

## opcionalmente puedes renombrar las columnas; `melt` y `stack` son idénticos, pero el orden de los argumentos se invierte
stack(x, [:M1, :M2], :id, variable_name=:key, value_name=:observed) # first measures and then id-s; stackdf creates view

#-

## si el segundo argumento se omite en `melt` o `stack`, todas las otras colummnas se asumen como en el segundo argumento
## pero las variables de medida se seleccionan sólo si <: AbstractFloat (es un subtipo de AbstractFloat)
#
melt(x, [:id, :id2])

#-

melt(x, [1, 2]) # puedes usar un índice en vez de un símbolo

#-

bigx = DataFrame(rand(10^6, 10)) # un test comparando la creación de un nuevo DataFrame y un `view`
bigx[:id] = 1:10^6
@time melt(bigx, :id)
@time melt(bigx, :id)
@time meltdf(bigx, :id)
@time meltdf(bigx, :id);

#-

x = DataFrame(id = [1,1,1], id2=['a','b','c'], a1 = rand(3), a2 = rand(3))

#-

melt(x)

#-

melt(DataFrame(rand(3,2))) # por default, `stack` y `melt` tratan flotantes como columnas de valores

#-

df = DataFrame(rand(3,2))
df[:key] = [1,1,1]
mdf = melt(df) # las llaves duplicadas se aceptan silenciosamente

# ### De largo a ancho

x = DataFrame(id = [1,1,1], id2=['a','b','c'], a1 = rand(3), a2 = rand(3))

#-

y = melt(x, [1,2])
display(x)
display(y)

#-

unstack(y, :id2, :variable, :value) # `unstack` estándar con llave única

#-

unstack(y, :variable, :value) # todas las otras columnas se tratan como llaves

#-

## por default `:id`, `:variable` y `:value` se asumen como nombres; en este caso eso produce llaves duplicadas
unstack(y)

#-

df = stack(DataFrame(rand(3,2)))

#-

unstack(df, :variable, :value) # imposible hacer `unstack` cuando no hay columna-llave presente

