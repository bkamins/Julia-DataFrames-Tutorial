# # Introdução ao DataFrames
# **[Bogumił Kamiński](http://bogumilkaminski.pl/about/), 23 de Maio de 2018**
#
# Tradução de [Jose Storopoli](https://storopoli.io).

using DataFrames # carregar o pacote

# ## Trabalhando com CategoricalArrays (Matrizes Categóricas)

# -

# ### Construtor

x = categorical(["A", "B", "B", "C"]) # não-ordenado

# -

y = categorical(["A", "B", "B", "C"], ordered=true) # ordenado, por padrão por padrão, a ordem é a ordem de classificação

# -

z = categorical(["A","B","B","C", missing]) # não-ordenado com `missing`s

# -

c = cut(1:10, 5) # ordenados, em contagens iguais, é possível renomear rótulos e personalizar os cortes (breaks)

# -

by(DataFrame(x=cut(randn(100000), 10)), :x, d -> DataFrame(n=nrow(d)), sort=true) # apenas para ter certeza de que funciona bem

# -

v = categorical([1,2,2,3,3]) # contém inteiros, não strings

# -

Vector{Union{String,Missing}}(z) # às vezes você precisa converter de volta para um vetor padrão

# ### Manipulando níveis

arr = [x,y,z,c,v]

# -

isordered.(arr) # verifique se a array categórica está ordenada

# -

ordered!(x, true), isordered(x) # faça x ser ordenado

# -

ordered!(x, false), isordered(x) # e não-ordenado novamente

# -

levels.(arr) # liste os níveis

# -

unique.(arr) # `missing`s serão incluídos

# -

y[1] < y[2] # pode comparar enquanto y for ordenado

# -

v[1] < v[2] # não comparável, v não está ordenado, embora contenha inteiros

# -

levels!(y, ["C", "B", "A"]) # você pode reordenar os níveis, principalmente útil para CategoricalArrays ordenadas

# -

y[1] < y[2] # observe que a ordem é alterada

# -

levels!(z, ["A", "B"]) # você tem que especificar todos os níveis que estão presentes

# -

levels!(z, ["A", "B"], allow_missing=true) # a menos que a array subjacente permita `missing`s e faça uma remoção forçada de níveis

# -

z[1] = "B"
z # agora z somente tem elementos "B"

# -

levels(z) # mas lembra os níveis que tinha (o motivo é principalmente o desempenho)

# -

droplevels!(z) # desta forma podemos limpá-lo
levels(z)

# ### Manipulação de dados

x, levels(x)

# -

x[2] = "0"
x, levels(x) # novo nível adicionado ao fim (funciona apenas para não-ordenados)

# -

v, levels(v)

# -

v[1] + v[2] # mesmo que os dados subjacentes sejam Int, não podemos operar sobre eles

# -

Vector{Int}(v) # você deve recuperar os dados por conversão (pode ser caro)

# -

get(v[1]) + get(v[2]) # ou obter um único valor

# -

get.(v) # isso funcionará para arrays sem `missing`s

# -

get.(z) # mas falhará na presença valores `missing`s

# -

Vector{Union{String,Missing}}(z) # você tem que converter

# -

z[1] * z[2], z.^2 # a única exceção são as CategoricalArrays baseados em String - você pode operá-las normalmente

# -

recode([1,2,3,4,5,missing], 1 => 10) # recodifique alguns valores de uma array; também possível fazer o equivalente *in-place* com recode!

# -

recode([1,2,3,4,5,missing], "a", 1 => 10, 2 => 20) # aqui, fornecemos um valor padrão para recodificações não mapeadas

# -

recode([1,2,3,4,5,missing], 1 => 10, missing => "missing") # para recodificar `missing` você tem que fazer de maneira explícita

# -

t = categorical([1:5; missing])
t, levels(t)

# -

recode!(t, [1,3] => 2)
t, levels(t) # note que os níveis não são removidos após a recodificação

# -

t = categorical([1,2,3], ordered=true)
levels(recode(t, 2 => 0, 1 => -1)) # e se você introduzir novos níveis, eles serão adicionados no final na ordem de surgimento

# -

t = categorical([1,2,3,4,5], ordered=true) # ao usar o padrão, ele se torna o último nível
levels(recode(t, 300, [1,2] => 100, 3 => 200))

# ### Comparações

x = categorical([1,2,3])
xs = [x, categorical(x), categorical(x, ordered=true), categorical(x, ordered=true)]
levels!(xs[2], [3,2,1])
levels!(xs[4], [2,3,1])
[a == b for a in xs, b in xs] # todas são iguais - compara apenas os conteúdos

# -

signature(x::CategoricalArray) = (x, levels(x), isordered(x)) # esta é na verdade a assinatura completa de CategoricalArray
## todos são diferentes, observe que x [1] e x [2] não estão ordenados, mas têm uma ordem diferente de níveis
[signature(a) == signature(b) for a in xs, b in xs]

# -

x[1] < x[2] # você não pode comparar elementos de CategoricalArray não-ordenada

# -

t[1] < t[2] # mas você pode fazer isso em uma ordenada

# -

isless(x[1], x[2]) # isless funciona dentro da mesma CategoricalArray, mesmo que não esteja ordenada

# -

y = deepcopy(x) # mas não entre CategoricalArrays
isless(x[1], y[2])

# -

isless(get(x[1]), get(y[2])) # você pode usar get para fazer uma comparação do conteúdo de CategoricalArray

# -

x[1] == y[2] # os testes de igualdade funcionam OK em CategoricalArrays

# ### Colunas categóricas em um DataFrame

df = DataFrame(x=1:3, y='a':'c', z=["a","b","c"])

# -

categorical!(df) # converte todas colunas eltype(AbstractString) para categótica

# -

showcols(df)

# -

categorical!(df, :x) # conversão manual da coluna :x em categórica

# -

showcols(df)
