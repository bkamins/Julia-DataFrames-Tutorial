# # Introdução ao DataFrames
# **[Bogumił Kamiński](http://bogumilkaminski.pl/about/), 23 de Maio de 2018**
#
# Tradução de [Jose Storopoli](https://storopoli.io).

using DataFrames # carregar o pacote

# ## Manipulando colunas de DataFrame

# -

# ### Renomeando colunas
#
# Vamos começar com um `DataFrame` de `Bool`s que tem nomes padrões de coluna.

x = DataFrame(Bool, 3, 4)

# Com `rename`, criamos um novo `DataFrame`; aqui, renomeamos a coluna `:x1` para `:A`. (`rename` também aceita coleções de `Pairs`.)

rename(x, :x1 => :A)

# Com `rename!` fazemos uma transformação *in-place*.
#
# Desta vez, aplicamos uma função para cada nome de coluna.

rename!(c -> Symbol(string(c)^2), x)

# Também podemos alterar o nome de uma coluna específica sem saber o nome original.
#
# Aqui mudamos o nome da terceira coluna, criando um novo `DataFrame`.

rename(x, names(x)[3] => :third)

# Com `names!`, podemos mudar os nomes de todas as variáveis.

names!(x, [:a, :b, :c, :d])

# Recebemos um erro quando tentamos fornecer nomes duplicados

names!(x, fill(:a, 4))

# a menos que passemos `makeunique = true`, o que nos permite lidar com nomes duplicados.

names!(x, fill(:a, 4), makeunique=true)

# ### Reordenando colunas

# -

# Podemos reordenar o vetor `names(x)` conforme necessário, criando um novo DataFrame.

srand(1234)
x[shuffle(names(x))]

# também há a possibilidade de usar `permutecols!` que será introduzido na próxima versão do DataFrames

# -

# ### Mesclando/adicionando colunas

x = DataFrame([(i, j) for i in 1:3, j in 1:4])

# Com `hcat` podemos fundir dois `DataFrame`s. Além disso, a sintaxe [x y] é suportada, mas apenas quando DataFrames têm nomes de coluna exclusivos (únicos).

hcat(x, x, makeunique=true)

# Também podemos usar `hcat` para adicionar uma nova coluna; um nome padrão `:x1` será usado para esta coluna, então `makeunique = true` é necessário.

y = hcat(x, [1,2,3], makeunique=true)

# Você também pode adicionar um vetor com `hcat` antes do DataFrame.

hcat([1,2,3], x, makeunique=true)

# Alternativamente, você pode anexar um vetor com a seguinte sintaxe. Isso é um pouco mais verboso, mas mais elegante.

y = [x DataFrame(A=[1,2,3])]

# Aqui fazemos o mesmo, mas adicionamos a coluna `:A` na frente.

y = [DataFrame(A=[1,2,3]) x]

# Uma coluna também pode ser adicionada no meio. Aqui, um método de força bruta é usado e um novo DataFrame é criado.

using BenchmarkTools
@btime [$x[1:2] DataFrame(A=[1,2,3]) $x[3:4]]

# Também poderíamos fazer isso com um método especializado *in-place* `insert!`. Vamos adicionar `:newcol` ao`DataFrame` `y`.

insert!(y, 2, [1,2,3], :newcol)

# Se você deseja inserir o mesmo nome de coluna várias vezes, `makeunique = true` é necessário como vocês já viram.

insert!(y, 2, [1,2,3], :newcol, makeunique=true)

# Podemos ver como é muito mais rápido inserir uma coluna com `insert!` do que com `hcat` usando `@btime`.

@btime insert!(copy($x), 3, [1,2,3], :A)

# Vamos usar `insert!` para anexar uma coluna *in-place*,

insert!(x, ncol(x) + 1, [1,2,3], :A)

# e também anexar *in-place* antes da coluna.

insert!(x, 1, [1,2,3], :B)

# Com `merge!`, vamos mesclar o segundo DataFrame no primeiro, mas sobrescrevendo as colunas duplicadas.

df1 = DataFrame(x=1:3, y=4:6)
df2 = DataFrame(x='a':'c', z='d':'f', new=11:13)
df1, df2, merge!(df1, df2)

# Para comparação: mesclaremos dois `DataFrames`s, mas renomeando nomes duplicados com `hcat`.

df1 = DataFrame(x=1:3, y=4:6)
df2 = DataFrame(x='a':'c', z='d':'f', new=11:13)
hcat(df1, df2, makeunique=true)

# ### Subconjunto/removendo colunas
#
# Vamos criar um novo `DataFrame` `x` e mostrar algumas maneiras de criar DataFrames com um subconjunto de colunas `x`.

x = DataFrame([(i, j) for i in 1:3, j in 1:5])

# Primeiro poderíamos fazer isso por índice

x[[1,2,4,5]]

# ou por nome de coluna.

x[[:x1, :x4]]

# Também podemos escolher manter ou excluir colunas por `Bool`. (Precisamos de um vetor cujo comprimento é o número de colunas no `DataFrame` original.)

x[[true, false, true, false, true]]

# Aqui criamos um `DataFrame` com uma única coluna,

x[[:x1]]

# e aqui acessamos o vetor contido na coluna `:x1`.

x[:x1]

# Poderíamos acessar o mesmo vetor pelo número da coluna

x[1]

# e podemos remover tudo de um `DataFrame` com `empty!`.

empty!(y)

# Aqui criamos uma cópia de `x` e excluímos a 3ª coluna da cópia com `delete!`.

z = copy(x)
x, delete!(z, 3)

# ### Modificando colunas por nome

x = DataFrame([(i, j) for i in 1:3, j in 1:5])

# Com a seguinte sintaxe, a coluna existente é modificada sem realizar nenhuma cópia.

x[:x1] = x[:x2]
x

# Também podemos usar a seguinte sintaxe para adicionar uma nova coluna no final de um `DataFrame`.

x[:A] = [1,2,3]
x

# Um novo nome de coluna será adicionado ao nosso `DataFrame` com a seguinte sintaxe (7 é igual a `ncol(x)+1`).

x[7] = 11:13
x

# ### Achando nomes de colunas

x = DataFrame([(i, j) for i in 1:3, j in 1:5])

# Podemos verificar se existe uma coluna com um determinado nome via

:x1 in names(x)

# e determinar o seu índice com

findfirst(names(x), :x2)
