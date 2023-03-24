# # Introducción a DataFrames
# **[Bogumił Kamiński](http://bogumilkaminski.pl/about/), May 23, 2018**
# (Traducción de Miguel Raz Guzmán Macedo)

using DataFrames # cargar paquete

# ## Cargar y guardar DataFrames
# No cubriremos toda la funcionalidad de los paquetes. Por favor leer la documentación para saber más.
# 
# Aquí cargaremos un `CSV` para leer y escribir archivos CSV. `JLD` nos permite trabajar con un formato binario nativo de Julia.

using CSV
using JLD

# Creemos un `DataFrame` para ver casos sencillos,

x = DataFrame(A=[true, false, true], B=[1, 2, missing],
              C=[missing, "b", "c"], D=['a', missing, 'c'])


# y usaremos `eltypes` para ver los tipos columnares.

eltypes(x)

# usemos `CSV` para guardar `x` a disco; Asegurarse que `x.csv` no genera conflictos con archivos en su directorio actual.

CSV.write("x.csv", x)

# Now we can see how it was saved by reading `x.csv`.
# Ahora vemos como se puede guardó al leer `x.csv`.

print(read("x.csv", String))

# También lo podemos cargar de vuelta. `use_mmap=false` desabilita el uso de `memory mapping` para los archivos se puedan borrar en la misma sesión en Windows.

y = CSV.read("x.csv", use_mmap=false)

# Cuando cargas un `DataFrame` de un `CSV`, todas las columnas permiten `Missing` por default. ¡Nota que el tipo de las columnas cambió!

eltypes(y)

# Ahora guardemos `x` a un archivo en formato binario. Asegúrese que `x.jld` no existe en su directorio actual.

save("x.jld", "x", x)

# Después de cargar `x.jld` como `y`, `y` es idéntico a `x`.

y = load("x.jld", "x")

# Observación: ¡los tipos de columnas de `y` son del mismo tipo que `x`!

eltypes(y)

# Ahora, crearemos los archivos `bigdf.csv` y `bigdf.jld`, entonces, ¡cuidado con que no existan esos archivos actualmente en su disco!
# 
# En particular, mediremos el tiempo que toma escribir un `DataFrame` con 10^3 filas y 10^5 columnas a archivos `.csv` y `.jld`. *Puedes esperar que JLD sea más rápido*. Usa `compress=true` para reducir el tamaño de los archivos.

bigdf = DataFrame(Bool, 10^3, 10^2)
@time CSV.write("bigdf.csv", bigdf)
@time save("bigdf.jld", "bigdf", bigdf)
getfield.(stat.(["bigdf.csv", "bigdf.jld"]), :size)

# Finalmente, hay que hacer algo de limpieza. No corras la siguiente línea a menos que estés segura que no va a borrar archivos importantes.

#foreach(rm, ["x.csv", "x.jld", "bigdf.csv", "bigdf.jld"])

