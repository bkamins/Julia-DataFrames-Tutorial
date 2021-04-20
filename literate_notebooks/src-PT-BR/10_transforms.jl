# # Introdução ao DataFrames
# **[Bogumił Kamiński](http://bogumilkaminski.pl/about/), 23 de Maio de 2018**
#
# Tradução de [Jose Storopoli](https://storopoli.io).

using DataFrames # carregar o pacote

# ## Transformações - *Split*-*apply*-*combine*

x = DataFrame(id=[1,2,3,4,1,2,3,4], id2=[1,2,1,2,1,2,1,2], v=rand(8))

# -

gx1 = groupby(x, :id)

# -

gx2 = groupby(x, [:id, :id2])

# -

vcat(gx2...) # de volta para o DataFrame original

# -

x = DataFrame(id=[missing, 5, 1, 3, missing], x=1:5)

# -

showall(groupby(x, :id)) # por padrão grupos incluem `missing`s e não são ordenados

# -

showall(groupby(x, :id, sort=true, skipmissing=true)) # mas podemos mudar isso :)

# -

x = DataFrame(id=rand('a':'d', 100), v=rand(100));
by(x, :id, y -> mean(y[:v])) # aplicar uma função para cada grupo de um data frame

# -

by(x, :id, y -> mean(y[:v]), sort=true) # também podemos ordenar o resultado

# -

by(x, :id, y -> DataFrame(res=mean(y[:v]))) # assim também é possível designar um nome para a coluna - o @by do DataFramesMeta é uma melhor opção

# -

x = DataFrame(id=rand('a':'d', 100), x1=rand(100), x2=rand(100))
aggregate(x, :id, sum) # aplique uma função sobre todas as colunas de um data frame nos grupos dados por uma id

# -

aggregate(x, :id, sum, sort=true) # also can be sorted

# *Omitimos a discussão de map/combine, pois não considero muito úteis (melhor usar by)*

x = DataFrame(rand(3, 5))

# -

map(mean, eachcol(x)) # aplique uma função em cada coluna e retorne um data frame

# -

foreach(c -> println(c[1], ": ", mean(c[2])), eachcol(x)) # uma iteração bruta retorna uma tupla com o nome da coluna e valores

# -

colwise(mean, x) # colwise é similar, mas produz um vector

# -

x[:id] = [1,1,2]
colwise(mean,groupby(x, :id)) # e funciona em GroupedDataFrame

# -

map(r -> r[:x1] / r[:x2], eachrow(x)) # agora o valor retornado é DataFrameRow, que funciona de forma semelhante a um DataFrame de uma linha só
