# # Introduction to DataFrames
# # Introducción a DataFrames
# **[Bogumił Kamiński](http://bogumilkaminski.pl/about/), May 23, 2018**
# (Traducción de Miguel Raz Guzmán Macedo)

using DataFrames # cargar paquete

# ## Manejo de valores faltantes
# 
# Un tipo singulete `Missings.Missing` permite lidiar con valores faltantes

missing, typeof(missing)

# Los arreglos automaticamente crean una unión de tipos apropiada.

x = [1, 2, missing, 3]

# `ismissing` checa si se le pasa un valor faltante.

ismissing(1), ismissing(missing), ismissing(x), ismissing.(x)

# Podemos extrar el tipo combinado con Missing de una `Union` via
# 
# (¡Esto es muy útil para los arreglos!)

eltype(x), Missings.T(eltype(x))

# comparaciones de `missing` producen `missing`.

missing == missing, missing != missing, missing < missing

# Eso también es cierto cuando `missing`s se comparan con valores de otros tipos.

1 == missing, 1 != missing, 1 < missing

# `isequal`, `isless`, y `===` producen resultados de tipo `Bool`.
#

isequal(missing, missing), missing === missing, isequal(1, missing), isless(1, missing)

# En los próximos ejemplos, vemos que muchas (no todas) funciones manejan `missing`.

map(x -> x(missing), [sin, cos, zero, sqrt]) # part 1

#-

map(x -> x(missing, 1), [+, - , *, /, div]) # part 2 

#-

map(x -> x([1,2,missing]), [minimum, maximum, extrema, mean, any, float]) # part 3

# `skipmissing` regresa un iterador que salta valores faltantes. Podemos usar `collect` y `skipmissing` para crear un arreglo que excluye estos valores faltantes.

collect(skipmissing([1, missing, 2, missing]))

# Similarmente, aquí combinamos `collect` y `Missings.replace` para crear un arreglo que reemplaza todos los valores faltantes con algún valor (`NaN`, en este caso).

collect(Missings.replace([1.0, missing, 2.0, missing], NaN))

# Otra manera de hacer esto es:

coalesce.([1.0, missing, 2.0, missing], NaN)

# Cuidado: `nothing` también sería reemplazado aquí (Para Julia 0.7 un comportamiento más sofisticado de `coalesce` permite que esquivemos este problema.)

coalesce.([1.0, missing, nothing, missing], NaN)

# Puedes usar `recode` si tienes tipos homogéneos en el output.

recode([1.0, missing, 2.0, missing], missing=>NaN)

# Puedes usar `unique` o `levels` para obtener valores únicos con o sin missings, respectivamente.

unique([1, missing, 2, missing]), levels([1, missing, 2, missing])

# En este ejemplo, convertimos `x` a `y` con `allowmissing`, donde `y` tiene un tipo que acepta missings.

x = [1,2,3]
y = allowmissing(x)

# Después, lo convertimos de regreso con `disallowmissing`. ¡Esto falla si `y` contiene valores faltantes!

z = disallowmissing(y)
x,y,z

# En el próximo ejemplo, mostramos que el tipo de cada columna de `x` es inicialmente `Int64`. Después de usar `allowmissing!`, aceptamos valores faltantes en las columnas 1 y 3. Los tipos de esas columnas se convierten en `Union`es de `Int64` y `Missings.Missing`.

x = DataFrame(Int, 2, 3)
println("Before: ", eltypes(x))
allowmissing!(x, 1) # Hacer que la primera columna permita valores faltantes
allowmissing!(x, :x3) # Hacer que la columna :x3 acepte valores faltantes
println("After: ", eltypes(x))

# En este ejemplo, usaremos `completecases` para encontrar todas las hileras de un `DataFrame` que tengan datos completos.

x = DataFrame(A=[1, missing, 3, 4], B=["A", "B", missing, "C"])
println(x)
println("Complete cases:\n", completecases(x))

# Podemos usar `dropmissing` o `dropmissing!` para quitar las filas con datos incompletos de un `DataFrame` y crear un nuevo `DataFrame` o mutar el original en su lugar.

y = dropmissing(x)
dropmissing!(x)
[x, y]

# Cuando llamamos `showcols` en un `DataFrame` con valores faltantes que les hicimos `drop`, las columnes siguen permitiendo valores faltantes.

showcols(x)

# Como ya excluimos los valores faltantes, podemos usar `disallowmissing!` con seguridad para que las columnas ya no puedan aceptar valores faltantes.

disallowmissing!(x)
showcols(x)

