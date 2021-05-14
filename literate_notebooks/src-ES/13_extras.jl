# # Introduction to DataFrames
# # Introducción a DataFrames
# **[Bogumił Kamiński](http://bogumilkaminski.pl/about/), May 13, 2018**
# (Traducción de Miguel Raz Guzmán Macedo, 18 de Abril de 2021)

using DataFrames

# ## Extras - funcionalidades especiales de paqueterías selectas

#-

# ### FreqTables: crear tabulaciones cruzadas

using FreqTables
df = DataFrame(a=rand('a':'d', 1000), b=rand(["x", "y", "z"], 1000))
ft = freqtable(df, :a, :b) # nota: las dimensiones se ordenan si es posible

#-

ft[1,1], ft['b', "z"] # puedes indexar el resultado con números o nombres

#-

prop(ft, 1) # obtener tamaños - 1 significa que lo queremos calcular en filas (primera dimensión)


#-

prop(ft, 2) # y las columnas se normalizan a 1.0

#-

x = categorical(rand(1:3, 10))
levels!(x, [3, 1, 2, 4]) # reorganizar niveles y añadir un nivel extra
freqtable(x) # el orden se mantiene y los niveles no usados se muestran

#-

freqtable([1,1,2,3,missing]) # por default los valores faltantes (`missing`s) se muestran como lista

#-

freqtable([1,1,2,3,missing], skipmissing=true) # pero nos los podemos saltar

# ### DataFramesMeta - trabajando en un `DataFrame`

using DataFramesMeta
df = DataFrame(x=1:8, y='a':'h', z=repeat([true,false], outer=4))

#-

@with(df, :x+:z) # expresiones con columnas de DataFrame

#-

@with df begin # puedes definir bloques de código
    a = :x[:z]
    b = :x[.!:z]
    :y + [a; b]
end

#-

a # `@with` crea un  `hard scope` (alcance léxico fuerte) y así las variables no se derraman al ambiente

#-

df2 = DataFrame(a = [:a, :b, :c])
@with(df2, :a .== ^(:a)) # A veces queremos un `Symbol` a secas, usamos ^() para escapar esa secuencia

#-

df2 = DataFrame(x=1:3, y=4:6, z=7:9)
@with(df2, _I_(2:3)) #   `_I_(expresión)` se traduce a `df2[expression]`

#-

@where(df, :x .< 4, :z .== true) # macro muy útil para filtrar

#-

@select(df, :x, y = 2*:x, z=:y) # crea un nuevo DataFrame basado en el anterior

#-

@transform(df, a=1, x = 2*:x, y=:x) # crea un DataFrame agregando columnas basado en el anterior

#-

@transform(df, a=1, b=:a) # se usa el DataFrame anterior y `:a` no está presente ahí

#-

@orderby(df, :z, -:x) # ordenando los datos en un nuevo DataFrame, menos poderoso que `sort` pero mucho más ligero

#-

@linq df |> # podemos encadenar operaciones sobre un DataFrame
    where(:x .< 5) |>
    orderby(:z) |>
    transform(x²=:x.^2) |>
    select(:z, :x, :x²)

#-

f(df, col) = df[col] # puedes definir tus propias funcioens y ponerlas en una cadena (`chain` = cadena, como las de metal)
@linq df |> where(:x .<= 4) |> f(:x)

# ### DataFramesMeta - trabajando con `DataFrame` agrupado

df = DataFrame(a = 1:12, b = repeat('a':'d', outer=3))
g = groupby(df, :b)

#-

@by(df, :b, first=first(:a), last=last(:a), mean=mean(:a)) # más conveniente que `by` de `DataFrames.jl`

#-

@based_on(g, first=first(:a), last=last(:a), mean=mean(:a)) #lo mismo que `by` pero en un DataFrame agrupado

#-

@where(g, mean(:a) > 6.5) # filtramos grupos con condiciones agregadas

#-

@orderby(g, -sum(:a)) # ordenar grupos con condiciones agregadas

#-

@transform(g, center = mean(:a), centered = :a - mean(:a)) # aplicar operaciones dentro de un grupo y regresar un DataFrame no agrupado

#-

DataFrame(g) # una función auxiliar bonita no definida en DataFrames.jl

#-

@transform(g) # de hecho esto es lo mismo

#-

@linq df |> groupby(:b) |> where(mean(:a) > 6.5) |> DataFrame # puedes encadenar operaciones sobre DataFrames agrupado también

# ### DataFramesMeta - operaciones por filas en un `DataFrame`

df = DataFrame(a = 1:12, b = repeat(1:4, outer=3))

#-

## dichas condiciones suelen ser necesarias pero son demasiado complejas para escribirlas
@transform(df, x = ifelse.((:a .> 6) .& (:b .== 4), "yes", "no"))

#-

## una opciön es usar una función que se aplica sobre una sola observación y la broadcasteamos
# Broadcasting en el manual: https://docs.julialang.org/en/v1/manual/arrays/#Broadcasting 
myfun(a, b) = a > 6 && b == 4 ? "yes" : "no"
@transform(df, x = myfun.(:a, :b))

#-

## o puedes usar el macro `@byrow`  que permite procesar el DataFrame por filas
@byrow! df begin
    @newcol x::Vector{String}
    :x = :a > 6 && :b == 4 ? "yes" : "no"
end

# ### Visualizando datos con StatPlots

using StatPlots # Puede ser necesario instalar algunos paquetes de Plots.jl y el backend antes de proseguir

#-

## presentamos la funcionalidad mínima de este paquete, no nos da para cubrir todo lo que ofrece

#-

srand(1)
df = DataFrame(x = sort(randn(1000)), y=randn(1000), z = [fill("b", 500); fill("a", 500)])

#-

@df df plot(:x, :y, legend=:topleft, label="y(x)") # la gráfica más básica

#-

@df df density(:x, label="") # gráfica de densidad

#-

@df df histogram(:y, label="y") # un histograma

#-

@df df boxplot(:z, :x, label="x")

#-

@df df violin(:z, :y, label="y")

