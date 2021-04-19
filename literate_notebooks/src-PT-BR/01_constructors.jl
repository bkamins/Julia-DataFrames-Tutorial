# # Introdução ao DataFrames
# **[Bogumił Kamiński](http://bogumilkaminski.pl/about/), 23 de Maio de 2018**
#
# Tradução de [Jose Storopoli](https://storopoli.io).
#
# Vamos começar carregando o pacote `DataFrames`

using DataFrames

# ## Construtores e conversões

# -

# ### Construtores
#
# Nesta seção, você verá as diferentes maneiras de criar um `DataFrame` usando o construtor `DataFrame()`
#
# Primeiramente, é possível criar um `DataFrame` vazio

DataFrame() # DataFrame vazio

# Podemos também passar argumentos de palavras-chave (*keyword arguments*) no construtor para adicionar colunas ao `DataFrame`.

DataFrame(A=1:3, B=rand(3), C=randstring.([3,3,3]))

# Podemos criar um `DataFrame` a partir de um dicionário, caso em que as chaves do dicionário serão usadas para criar as colunas do `DataFrame`.

x = Dict("A" => [1,2], "B" => [true, false], "C" => ['a', 'b'])
DataFrame(x)

# Em vez de criar explicitamente um dicionário primeiro, como acima, poderíamos passar argumentos `DataFrame` com a sintaxe dos pares chave-valor do dicionário.
#
# Observe que, neste caso, usamos símbolos para denotar os nomes das colunas e os argumentos não são ordenados. Por exemplo, o símbolo `:A`produz`A` que será o nome da primeira coluna aqui:

DataFrame(:A => [1,2], :B => [true, false], :C => ['a', 'b'])

# Aqui criamos um `DataFrame` a partir de um vetor de vetores, e cada vetor se torna uma coluna.

DataFrame([rand(3) for i in 1:3])

# Por enquanto, podemos construir um único `DataFrame` a partir de um `Vector` atômico, criando um `DataFrame` com uma única linha. Em versões futuras de DataFrames.jl, isso gerará um erro.

DataFrame(rand(3))

# Em vez disso, use um vetor transposto se você tiver um vetor atômico (dessa forma, você passa efetivamente uma array bidimensional para o construtor o que é compatível).

DataFrame(transpose([1, 2, 3]))

# Passe um segundo argumento para dar nomes às colunas.

DataFrame([1:3, 4:6, 7:9], [:A, :B, :C])

# Aqui nós criamos um `DataFrame` de uma matriz,

DataFrame(rand(3, 4))

# e aqui nós fazemos o mesmo mas também passando nomes de colunas.

DataFrame(rand(3, 4), Symbol.('a':'d'))

# Podemos também construir um `DataFrame` não-inicializado.
#
# Aqui passamos os tipos de coluna, nomes e número de linhas; obtemos `missing` na coluna `:C` porque `Any >: Missing`.

DataFrame([Int, Float64, Any], [:A, :B, :C], 1)

# Aqui criamos um `DataFrame`, mas a coluna`:C` é #undef e o Jupyter tem problemas para exibi-la. (Isso funciona OK no REPL.)
#
# Isto será consertado na próxima versão do DataFrames!

DataFrame([Int, Float64, String], [:A, :B, :C], 1)

# Para inicializar um `DataFrame` com nomes de colunas, mas sem linhas use

DataFrame([Int, Float64, String], [:A, :B, :C], 0)

# Essa sintaxe permite uma maneira rápida de criar um `DataFrame` homogêneo:

DataFrame(Int, 3, 5)

# Esse exemplo é similar, mas possui colunas não-homogêneas.

DataFrame([Int, Float64], 4)

# Finalmente, podemos criar um `DataFrame` copiando um `DataFrame` existente.
#
# Note que `copy` cria uma cópia raza.

y = DataFrame(x)
z = copy(x)
(x === y), (x === z), isequal(x, z)

# ### Conversões para Matrizes
#
# Vamos começar criando um `DataFrame` com duas linhas e duas colunas.

x = DataFrame(x=1:2, y=["A", "B"])

# Podemos criar uma matriz passando esse `DataFrame` para `Matrix`.

Matrix(x)

# Isso funciona mesmo se `DataFrame` possuir alguns `missing`s:

x = DataFrame(x=1:2, y=[missing,"B"])

# -

Matrix(x)

# Nos dois exemplos de matriz anteriores, Julia criou matrizes com elementos do tipo `Any`. Podemos ver mais claramente que o tipo de matriz é inferido quando passamos, por exemplo, um `DataFrame` de inteiros para`Matrix`, criando um `Array` 2D de `Int64`s:

x = DataFrame(x=1:2, y=3:4)

# -

Matrix(x)

# No próximo exemplo, Julia identifica corretamente que `Union` é necessário para expressar o tipo resultante de `Matrix` (que contém `missing`s).

x = DataFrame(x=1:2, y=[missing,4])

# -

Matrix(x)

# Note que não conseguimos forçar uma conversão de valores `missing` para `Int`s!

Matrix{Int}(x)

# ### Lidando com nomes de colunas duplicados
#
# Nós podemos passar o argumento de palavra-chave `makeunique` para permitir o uso de nomes duplicados de colunas (eles serão "deduplicados")

df = DataFrame(:a => 1, :a => 2, :a_1 => 3; makeunique=true)

# Caso contrário, nomes duplicados não serão permitidos no futuro.

df = DataFrame(:a => 1, :a => 2, :a_1 => 3)

# Um construtor que recebe nomes de coluna como argumentos de palavra-chave é um caso excepcional.
# Não é permitido usar `makeunique` aqui para permitir nomes duplicados.

df = DataFrame(a=1, a=2, makeunique=true)
