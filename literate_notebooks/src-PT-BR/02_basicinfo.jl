# # Introdução ao DataFrames
# **[Bogumił Kamiński](http://bogumilkaminski.pl/about/), 23 de Maio de 2018**
#
# Tradução de [Jose Storopoli](https://storopoli.io).

using DataFrames # load package

# ## Obtendo informações básicas sobre um data frame
#
# Vamos começar criando um objeto `DataFrame`, `x`, para que possamos aprender como obter informações sobre um data frame.

x = DataFrame(A=[1, 2], B=[1.0, missing], C=["a", "b"])

# A função padrão `size` é uma maneira de obter as dimensões do `DataFrame`,

size(x), size(x, 1), size(x, 2)

# assim como `nrow` e `ncol` oriundas do R; `length` retorna o número de colunas.

nrow(x), ncol(x), length(x)

# `describe` retorna estatísticas descritivas básicas dos dados do seu `DataFrame`.

describe(x)

# Use `showcols` para conseguir informações sobre as colunas armazenadas em um DataFrame.

showcols(x)

# `names` retornará os nomes de todas as colunas,

names(x)

# e `eltypes` retorna os seus tipos.

eltypes(x)

# Vamos criar um DataFrame grande

y = DataFrame(rand(1:10, 1000, 10));

# com isso podemos usar `head` para ter uma visão rápida das linhas superiores

head(y)

# e `tail` para ver suas linhas inferiores.

tail(y, 3)

# ### As funções *get* e *set* mais elementares
#
# Dado o `DataFrame` `x`, aqui estão três maneiras de capturar uma de suas colunas como um `Vector`:

x[1], x[:A], x[:, 1]

# Para capturar apenas uma linha como `DataFrame`, podemos indexar assim:

x[1, :]

# Podemos capturar uma única célula ou elemento com a mesma sintaxe usada para capturar um elemento de uma array.

x[1, 1]

# Atribuição pode ser feita em intervalos para um escalar,

x[1:2, 1:2] = 1
x

# ou para um vetor de comprimento igual ao número de linhas atribuídas,

x[1:2, 1:2] = [1,2]
x

# ou para outro data frame de tamanho correspondente.

x[1:2, 1:2] = DataFrame([5 6; 7 8])
x
