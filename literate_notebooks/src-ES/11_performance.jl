# # Introducción a DataFrames
# **[Bogumił Kamiński](http://bogumilkaminski.pl/about/), Apr 21, 2018**
# (Traducción por Miguel Raz Guzmán Macedo, 18 de abril de 2021)

using DataFrames
using BenchmarkTools

# ## Tips de Performance 🚀

#-

# ### Accesar columnas por número es más rápido que por nombre

x = DataFrame(rand(5, 1000))
@btime x[500];
@btime x[:x500];

# ### Cuando trabajes con datos de `DataFrame`, usa funciones barrera o anotaciones de tipo
# Sobre funciones barrera: https://docs.julialang.org/en/v1/manual/performance-tips/
# Las anotaciones de tipo se ven así: `x::Int64 = 2`

function f_bad() # esta función va a ser lenta 🐢
    srand(1); x = DataFrame(rand(1000000,2))
    y, z = x[1], x[2]
    p = 0.0
    for i in 1:nrow(x)
        p += y[i]*z[i]
    end
    p
end

@btime f_bad();

#-

@code_warntype f_bad() # la razón es que Julia no conoce los tipos de las columnas del `DataFrame`

#-

## la primera opción es funciones barrera (debería ser posible en casi cualquier código)
function f_inner(y,z)
   p = 0.0
   for i in 1:length(y)
       p += y[i]*z[i]
   end
   p
end

function f_barrier() # extraemos el trabajo a una función interior
    srand(1); x = DataFrame(rand(1000000,2))
    f_inner(x[1], x[2])
end

function f_inbuilt() # o usamos una función preestablecida si es posible
    srand(1); x = DataFrame(rand(1000000,2))
    dot(x[1], x[2])
end

@btime f_barrier();
@btime f_inbuilt();

#-

## la opción 2 es proveer el tipo de las columnas extraídas - lo cual
## es más sencillo pero hay casos donde no se va a poder saber sus tipos
function f_typed()
    srand(1); x = DataFrame(rand(1000000,2))
    y::Vector{Float64}, z::Vector{Float64} = x[1], x[2]
    p = 0.0
    for i in 1:nrow(x)
        p += y[i]*z[i]
    end
    p
end

@btime f_typed();

# ### Considera usar la técnica de creación de `DataFrame` demorada

function f1()
    x = DataFrame(Float64, 10^4, 100) # Trabajamos con un DataFrame directamente
    for c in 1:ncol(x)
        d = x[c]
        for r in 1:nrow(x)
            d[r] = rand()
        end
    end
    x
end

function f2()
    x = Vector{Any}(100)
    for c in 1:length(x)
        d = Vector{Float64}(10^4)
        for r in 1:length(d)
            d[r] = rand()
        end
        x[c] = d
    end
    DataFrame(x) # y demoramos al creación del DataFrame hasta que hayamos acabado nuestro trabaj
end

@btime f1();
@btime f2();

# ### Puedes agregar filas a un `DataFrame` in situ rápidamente 🐇 

x = DataFrame(rand(10^6, 5))
y = DataFrame(transpose(1.0:5.0))
z = [1.0:5.0;]

@btime vcat($x, $y); # crear un nuevo DataFrame - lento 🐢
@btime append!($x, $y); # in situ - rápido 🐇   

x = DataFrame(rand(10^6, 5)) # reseteamos al mismo punto inicial
@btime push!($x, $z); # agregar una sola fila - lo más rápido

# ### Permitir datos `missing` y `categorical` alenta el cómputo

using StatsBase

function test(data) # usa la función countmap para medir performance
    println(eltype(data))
    x = rand(data, 10^6)
    y = categorical(x)
    println(" raw:")
    @btime countmap($x)
    println(" categorical:")
    @btime countmap($y)
    nothing
end

test(1:10)
test([randstring() for i in 1:10])
test(allowmissing(1:10))
test(allowmissing([randstring() for i in 1:10]))


