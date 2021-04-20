# # Introdução ao DataFrames
# **[Bogumił Kamiński](http://bogumilkaminski.pl/about/), 23 de Maio de 2018**
#
# Tradução de [Jose Storopoli](https://storopoli.io).

using DataFrames # carregar o pacote

# ## Redimensionando DataFrames

# -

# ### Amplo (*wide*) para comprido (*long*)

x = DataFrame(id=[1,2,3,4], id2=[1,1,2,2], M1=[11,12,13,14], M2=[111,112,113,114])

# -

melt(x, :id, [:M1, :M2]) # primeiro passe variáveis de identificação (id ou chaves) e então as variáveis de mensuração; meltdf produz uma view

# -

## opcionalmente você pode renomear colunas; melt e stack são idênticos mas a ordem dos argumentos é invertida
stack(x, [:M1, :M2], :id, variable_name=:key, value_name=:observed) # primeiro mensurações depois as id's; stackdf produz uma view

# -

## se o segundo argumento for omitido em melt ou stack, todas as outras colunas serão consideradas como o segundo argumento
## mas as variáveis de mensuração são selecionadas apenas se forem <: AbstractFloat
melt(x, [:id, :id2])

# -

melt(x, [1, 2]) # você pode usar o índice ao invés do símbolo

# -

bigx = DataFrame(rand(10^6, 10)) # um teste comparando a criação de um novo DataFrame e uma view
bigx[:id] = 1:10^6
@time melt(bigx, :id)
@time melt(bigx, :id)
@time meltdf(bigx, :id)
@time meltdf(bigx, :id);

# -

x = DataFrame(id=[1,1,1], id2=['a','b','c'], a1=rand(3), a2=rand(3))

# -

melt(x)

# -

melt(DataFrame(rand(3, 2))) # por padrão stack e melt trata floats como colunas de valores

# -

df = DataFrame(rand(3, 2))
df[:key] = [1,1,1]
mdf = melt(df) # duplicados nas chaves são silenciosamente aceitos

# ### Comprodido(*long*) para amplo (*wide*)

x = DataFrame(id=[1,1,1], id2=['a','b','c'], a1=rand(3), a2=rand(3))

# -

y = melt(x, [1,2])
display(x)
display(y)

# -

unstack(y, :id2, :variable, :value) # unstack padrão com chave única

# -

unstack(y, :variable, :value) # todas as outras colunas são tratadas como chaves

# -

## por padrão nomes como :id, :variable e :value são presumidos; neste caso, produz chaves duplicadas
unstack(y)

# -

df = stack(DataFrame(rand(3, 2)))

# -

unstack(df, :variable, :value) # não é possível fazer unstack quando não há coluna key presente
