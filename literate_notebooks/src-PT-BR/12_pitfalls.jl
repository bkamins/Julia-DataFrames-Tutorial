# # Introdução ao DataFrames
# **[Bogumił Kamiński](http://bogumilkaminski.pl/about/), 23 de Maio de 2018**
#
# Tradução de [Jose Storopoli](https://storopoli.io).

using DataFrames

# ## Possíveis armadilhas

# -

# ### Saiba o que é copiado ao criar um `DataFrame`

x = DataFrame(rand(3, 5))

# -

y = DataFrame(x)
x === y # nenhuma cópia realizada

# -

y = copy(x)
x === y # não é o mesmo objeto

# -

all(x[i] === y[i] for i in ncol(x)) # mas as colunas são as mesmas

# -

x = 1:3; y = [1, 2, 3]; df = DataFrame(x=x, y=y) # o mesmo ao criar arrays ou atribuir colunas, exceto ranges

# -

y === df[:y] # o mesmo objeto

# -

typeof(x), typeof(df[:x]) # range é convertido para vetor

# ### Não modifique o "pai" de um `GroupedDataFrame`

x = DataFrame(id=repeat([1,2], outer=3), x=1:6)
g = groupby(x, :id)

# -

x[1:3, 1] = [2,2,2]
g # bem - está errado agora, g é apenas uma view

# ### Lembre-se de que você pode filtrar colunas de um `DataFrame` usando booleanos

srand(1)
x = DataFrame(rand(5, 5))

# -

x[x[:x1] .< 0.25] # bem - filtramos colunas, não linhas por acidente, pois você pode selecionar colunas usando booleanos

# -

x[x[:x1] .< 0.25, :] # provavelmente isso é o que queríamos

# ### Cseleção de coluna para DataFrame cria aliases, a menos que explicitamente copiado

x = DataFrame(a=1:3)
x[:b] = x[1] # alias
x[:c] = x[:, 1] # também alias
x[:d] = x[1][:] # cópia
x[:e] = copy(x[1]) # cópia explícita
display(x)
x[1,1] = 100
display(x)
