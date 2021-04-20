# # Introdução ao DataFrames
# **[Bogumił Kamiński](http://bogumilkaminski.pl/about/), 23 de Maio de 2018**
#
# Tradução de [Jose Storopoli](https://storopoli.io).

using DataFrames

# ## Extras - Pacotes adicionais interessantes

# -

# ### FreqTables: criando tabulações cruzadas

using FreqTables
df = DataFrame(a=rand('a':'d', 1000), b=rand(["x", "y", "z"], 1000))
ft = freqtable(df, :a, :b) # observe que as dimensões são ordenadas, se possível

# -

ft[1,1], ft['b', "z"] # você pode indexar o resultado usando números ou nomes

# -

prop(ft, 1) # obter proporções - 1 significa que queremos calculá-las em linhas (primeira dimensão)

# -

prop(ft, 2) # e as colunas são normalizadas para 1.0 agora

# -

x = categorical(rand(1:3, 10))
levels!(x, [3, 1, 2, 4]) # reordenando níveis e adicionando um nível extra
freqtable(x) # a ordem é preservada e o nível não usado é mostrado

# -

freqtable([1,1,2,3,missing]) # por padrão `missing`s são listados

# -

freqtable([1,1,2,3,missing], skipmissing=true) # mas podemos ignorá-los

# ### DataFramesMeta - trabalhando em `DataFrame`

using DataFramesMeta
df = DataFrame(x=1:8, y='a':'h', z=repeat([true,false], outer=4))

# -

@with(df, :x + :z) # expressões com colunas de DataFrame

# -

@with df begin # você pode definir blocos de código com `begin` e `end`
    a = :x[:z]
    b = :x[.!:z]
    :y + [a; b]
end

# -

a # @with cria um escopo rígido para que as variáveis não vazem

# -

df2 = DataFrame(a=[:a, :b, :c])
@with(df2, :a .== ^(:a)) # às vezes queremos trabalhar no símbolo bruto, ^() permite isso

# -

df2 = DataFrame(x=1:3, y=4:6, z=7:9)
@with(df2, _I_(2:3)) # _I_(expressão) é traduzido para df2[expressão]

# -

@where(df, :x .< 4, :z .== true) # macro muito útil para filtragem

# -

@select(df, :x, y = 2 * :x, z = :y) # crie um novo DataFrame baseado no antigo

# -

@transform(df, a = 1, x = 2 * :x, y = :x) # crie um novo DataFrame adicionando colunas com base no antigo

# -

@transform(df, a = 1, b = :a) # antigo DataFrame é usado e :a não está presente nele

# -

@orderby(df, :z, -:x) # ordenando em um novo data frame, menos poderoso que sort, mas menos pesado

# -

@linq df |> # encadeamento de operações no DataFrame
    where(:x .< 5) |>
    orderby(:z) |>
    transform(x²=:x.^2) |>
    select(:z, :x, :x²)

# -

f(df, col) = df[col] # você pode definir suas próprias funções e colocá-las na cadeia
@linq df |> where(:x .<= 4) |> f(:x)

# ### DataFramesMeta - trabalhando em `DataFrame` agrupados

df = DataFrame(a=1:12, b=repeat('a':'d', outer=3))
g = groupby(df, :b)

# -

@by(df, :b, first = first(:a), last = last(:a), mean = mean(:a)) # mais conveniente do que o by do DataFrames

# -

@based_on(g, first = first(:a), last = last(:a), mean = mean(:a)) # o mesmo que by, mas no DataFrame agrupado

# -

@where(g, mean(:a) > 6.5) # filtrar grupos usando condições agregadas

# -

@orderby(g, -sum(:a)) # ordenar grupos usando condições agregadas

# -

@transform(g, center = mean(:a), centered = :a - mean(:a)) # realizar operações dentro de um grupo e retornar DataFrame não agrupado

# -

DataFrame(g) # uma função de conveniência interessante não definida em DataFrames

# -

@transform(g) # na verdade este é o mesmo

# -

@linq df |> groupby(:b) |> where(mean(:a) > 6.5) |> DataFrame # você pode fazer o encadeamento em DataFrames agrupados também

# ### DataFramesMeta - operações por linhas (*rowwise*) em `DataFrame`

df = DataFrame(a=1:12, b=repeat(1:4, outer=3))

# -

## tais condições são frequentemente necessárias, mas são complexas de expressar
@transform(df, x = ifelse.((:a .> 6) .& (:b .== 4), "yes", "no"))

# -

## uma opção é usar uma função que funcione em uma única observação e transmiti-la (*broadcast*)
myfun(a, b) = a > 6 && b == 4 ? "yes" : "no"
@transform(df, x = myfun.(:a, :b))

# -

## ou você pode usar o macro @byrow! que permite processar DataFrame por linhas (*rowwise*)
@byrow! df begin
    @newcol x::Vector{String}
    :x = :a > 6 && :b == 4 ? "yes" : "no"
end

# ### Visualização de dados com StatPlots

using StatPlots # você pode precisar configurar o pacote Plots e algum backend gráfico primeiro

# -

## apresentamos apenas uma funcionalidade mínima do pacote

# -

srand(1)
df = DataFrame(x=sort(randn(1000)), y=randn(1000), z=[fill("b", 500); fill("a", 500)])

# -

@df df plot(:x, :y, legend=:topleft, label="y(x)") # o gráfico mais básico possível

# -

@df df density(:x, label="") # gráfico de densidade

# -

@df df histogram(:y, label="y") # e um histograma

# -

@df df boxplot(:z, :x, label="x")

# -

@df df violin(:z, :y, label="y")
