# # Introducción a DataFrames
# **[Bogumił Kamiński](http://bogumilkaminski.pl/about/), May 23, 2018**
# (Traducción por Miguel Raz, Abril 16 2021)
# 
# Empecemos cargando el paquete de `DataFrames`.

using DataFrames

# ## Constructores y conversiones

#-

# ### Constructores
# 
# En esta secciónn, verás distintas maneras de crear un `DataFrame` usando el constructor `DataFrame()`.
# 
# Primero, creemos un DataFrame vacío.

DataFrame() #  DataFrame vacío

# O podemos llamar al constructor usando keyword arguments para agregar columnas al `DataFrame`.

DataFrame(A=1:3, B=rand(3), C=randstring.([3,3,3]))

# Podemos creat el `DataFrame` de un diccionario, en cuyo caso las llaves del diccionario estarán ordenadas para crear las columnas del `DataFrame`.

x = Dict("A" => [1,2], "B" => [true, false], "C" => ['a', 'b'])
DataFrame(x)

# En vez de explícitamente crear el diccionario primero, como hicimos arriba, podríamos pasar argumentos de `DataFrame` con la sintaxis de pares llave-valor de un diccionario.
# 
# Notar que en este caso, usamos símbolos para denotar los nombres de las columnas y los argumentos no están ordenados. Por ejemplo, `:A`, el símbolo, produce `A`, el nombre de la primera columna:

DataFrame(:A => [1,2], :B => [true, false], :C => ['a', 'b'])

# Aquí creamos un `DataFrame` de un vector de vectores, donde cada vector se convierte en una columna.

DataFrame([rand(3) for i in 1:3])

#  Por ahora podemos construir un `DataFrame` de un `Vector` de átomos, creando un `DataFrame` con una sola hilera. En versiones futuras de DataFrames.jl, esto arrojará un error.

DataFrame(rand(3))

# Si tienes un vector de átomos, es mejor usar un vector transpuesto (pues efectivamente uno pasa un arreglo bidimensional, lo cual sí tiene soporte.)

DataFrame(transpose([1, 2, 3]))

# Pasa un segundo argumento para darle nombre a las columnas.

DataFrame([1:3, 4:6, 7:9], [:A, :B, :C])

# Aquí creamos un `DataFrame` de una matriz,

DataFrame(rand(3,4))

# y aquí hacemos lo mismo pero también pasamos los nombres de las columnas.

DataFrame(rand(3,4), Symbol.('a':'d'))

# También podemos pasar un DataFrame no inicializado.
# 
# Aquí pasamos los tipos de las columnas, nombres y número de hileras; obtemenos un `missing` en la columna :C porque `Any >: Missing`:

DataFrame([Int, Float64, Any], [:A, :B, :C], 1)

# Aquí nosotros creamos un `DataFrame`, pero la columna `:C` es `#undef` y Jupyter tiene problemas para mostrarlo (Esto funciona en el REPL sin problemas.)
# 

DataFrame([Int, Float64, String], [:A, :B, :C], 1)

# Para inicializar un `DataFrame` con nombres de columnas, pero sin filas, usamos

DataFrame([Int, Float64, String], [:A, :B, :C], 0) 

# Esta sintaxis nos da una manera rápida de crear un `DataFrame` homogéneo.

DataFrame(Int, 3, 5)

# El ejemplo es similar, pero tiene columnas no-homogéneas.

DataFrame([Int, Float64], 4)

# Finalmente, podemos creat un `DataFrame` copiando uno anterior.
# 
# Notar que `copy` crea un copia superficial.

y = DataFrame(x)
z = copy(x)
(x === y), (x === z), isequal(x, z)

# ### Conversión a matrices
# 
# Let's start by creating a `DataFrame` with two rows and two columns.
# Empecemos creando un `DataFrame` con dos filas y dos columnas. 

x = DataFrame(x=1:2, y=["A", "B"])

# Podemos crear una matriz pasando este `DataFrame` a `Matrix`.

Matrix(x)

# Este funciona aún si el `DataFrame` tiene `missing`s:

x = DataFrame(x=1:2, y=[missing,"B"])

#-

Matrix(x)

# En los dos ejemplos de matrices pasados, Julia creó matrices con elementos de tipo `Any`. Podemos ver más claramente qué tipo de matriz es inferido cuando pasamos, por ejemplo, un `DataFrame` de enteros a `Matrix`, creando un arreglo 2D de `Int64`s: 

x = DataFrame(x=1:2, y=3:4)

#-

Matrix(x)

# En el próximo ejemplo, Julia correctamente identifica que el tipo `Union` se necesita para expresar el tipo resultante de `Matrix` (el cual contiene `missing`s).


x = DataFrame(x=1:2, y=[missing,4])

#-

Matrix(x)

# ¡Notemos que no podemos covertir forzosamente valores `missings` a `Int`s!

Matrix{Int}(x)

# ### Lidiando con nombres de columnas repetidos
# 
# Podemos pasar el keyword argument `makeunique` para permitir usar nombres duplicados (se desduplican)

df = DataFrame(:a=>1, :a=>2, :a_1=>3; makeunique=true)

# Si no es así, los duplicados no se permitirán después.

df = DataFrame(:a=>1, :a=>2, :a_1=>3)

# Una excepción es un constructor al que se le pasan los nombres de columnas como keyword arguments.
# No puedes pasar `makeunique` para permitir duplicados en este caso.

df = DataFrame(a=1, a=2, makeunique=true)

