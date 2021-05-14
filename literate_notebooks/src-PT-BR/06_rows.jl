# # Introdução ao DataFrames
# **[Bogumił Kamiński](http://bogumilkaminski.pl/about/), 23 de Maio de 2018**
#
# Tradução de [Jose Storopoli](https://storopoli.io).

using DataFrames # carregar o pacote
srand(1);

# ## Manipulando linhas de DataFrame

# -

# ### Reordenando linhas

x = DataFrame(id=1:10, x=rand(10), y=[zeros(5); ones(5)]) # we esperamos x[:x] não esteja já ordenado :)

# -

issorted(x), issorted(x, :x) # verifica se um DataFrame ou um subconjunto das suas colunas está ordenado

# -

sort!(x, :x) # ordena x *in-place*

# -

y = sort(x, :id) # novo DataFrame

# -

sort(x, (:y, :x), rev=(true, false)) # ordena por duas columnas, primeira é de maneira descrescente, segunda é de maneira crescente

# -

sort(x, (order(:y, rev=true), :x)) # o mesmo que acima

# -

sort(x, (order(:y, rev=true), order(:x, by=v -> -v))) # mais uma maneira elegante de ordenar

# -

x[shuffle(1:10), :] # reordena linhas (agora de maneira aleatória)

# -

sort!(x, :id)
x[[1,10],:] = x[[10,1],:] # trocar linhas
x

# -

x[1,:], x[10,:] = x[10,:], x[1,:] # mais uma troca
x

# ### Mesclando/adicionando linhas

x = DataFrame(rand(3, 5))

# -

[x; x] # mesclar por linhas - os data frames devem ter os mesmos nomes de colunas; assim como vcat

# -

y = x[reverse(names(x))] # obtenha y com outra ordenação de nomes de colunas

# -

vcat(x, y) # nós conseguimos o que queremos, pois o vcat faz a correspondência dos nomes das colunas

# -

vcat(x, y[1:3]) # mas os nomes das colunas ainda devem corresponder

# -

append!(x, x) # o mesmo mas modifica x *in-place*

# -

append!(x, y) # aqui os nomes das colunas devem corresponder exatamente

# -
push!(x, 1:5) #  # adicione uma linha a x no final; deve fornecer o número correto de valores assim como os tipos corretos
x

# -

push!(x, Dict(:x1 => 11, :x2 => 12, :x3 => 13, :x4 => 14, :x5 => 15)) # também funciona com dicionários
x

# ### Subconjunto/removendo linhas

x = DataFrame(id=1:10, val='a':'j')

# -

x[1:2, :] # por índice

# -

view(x, 1:2) # o mesmo mas uma *view*

# -

x[repmat([true, false], 5), :] # por `Bool`, requer comprimento exato

# -

view(x, repmat([true, false], 5), :) # *view* de novo

# -

deleterows!(x, 7) # deleta uma linha

# -

deleterows!(x, 6:7) # deleta uma coleção de linhas

# -

x = DataFrame([1:4, 2:5, 3:6])

# -

filter(r -> r[:x1] > 2.5, x) # crie um novo DataFrame onde a função de filtragem opera em `DataFrameRow`

# -

## modificação *in-place* de x, um exemplo com uma sintaxe de bloco `do`
filter!(x) do r
    if r[:x1] > 2.5
        return r[:x2] < 4.5
    end
    r[:x3] < 3.5
end

# ### "Desduplicando"

x = DataFrame(A=[1,2], B=["x","y"])
append!(x, x)
x[:C] = 1:4
x

# -

unique(x, [1,2]) # obtém as primeiras linhas únicas para determinado índice

# -

unique(x) # agora considerando todas as linhas

# -

nonunique(x, :A) # obtém indicadores de linhas não-únicas

# -

unique!(x, :B) # modifica x *in-place*

# ### Extraíndo uma linha do `DataFrame` em um vetor

x = DataFrame(x=[1,missing,2], y=["a", "b", missing], z=[true,false,true])

# -

cols = [:x, :y]
[x[1, col] for col in cols] # subconjunto de colunas

# -

[[x[i, col] for col in names(x)] for i in 1:nrow(x)] # vetor de vetores, cada elemento contém uma linha completa de x

# -

Tuple(x[1, col] for col in cols) # construtor similar para Tuplas, quando portado para Julia 0.7 NamedTuples (Tupla Nomeada) será adicionada
