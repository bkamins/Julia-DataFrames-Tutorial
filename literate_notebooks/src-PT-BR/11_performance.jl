# # Introdução ao DataFrames
# **[Bogumił Kamiński](http://bogumilkaminski.pl/about/), 23 de Maio de 2018**
#
# Tradução de [Jose Storopoli](https://storopoli.io).

using DataFrames
using BenchmarkTools

# ## Dicas de desempenho

# -

# ### O acesso por número de coluna é mais rápido do que por nome

x = DataFrame(rand(5, 1000))
@btime x[500];
@btime x[:x500];

# ### Ao trabalhar com dados `DataFrame`, use funções de barreira ou anotação de tipo

function f_bad() # essa função será lenta
    srand(1); x = DataFrame(rand(1000000, 2))
    y, z = x[1], x[2]
    p = 0.0
    for i in 1:nrow(x)
        p += y[i] * z[i]
    end
    p
end

@btime f_bad();

# -

@code_warntype f_bad() # a razão é que Julia não conhece os tipos de colunas no `DataFrame`

# -

## a solução 1 é usar a função de barreira (deve ser possível usá-la em quase qualquer código)
function f_inner(y, z)
    p = 0.0
    for i in 1:length(y)
        p += y[i] * z[i]
    end
    p
end

function f_barrier() # extrair o trabalho para uma função interna
    srand(1); x = DataFrame(rand(1000000, 2))
    f_inner(x[1], x[2])
end

function f_inbuilt() # ou use a função embutida, se possível
    srand(1); x = DataFrame(rand(1000000, 2))
    dot(x[1], x[2])
end

@btime f_barrier();
@btime f_inbuilt();

# -

## a solução 2 é fornecer os tipos de colunas extraídas
## é mais simples, mas há casos em que você não conhecerá esses tipos
function f_typed()
    srand(1); x = DataFrame(rand(1000000, 2))
    y::Vector{Float64}, z::Vector{Float64} = x[1], x[2]
    p = 0.0
    for i in 1:nrow(x)
        p += y[i] * z[i]
    end
    p
end

@btime f_typed();

# ### Considere usar uma técnica de criação de `DataFrame` "atrasada"

function f1()
    x = DataFrame(Float64, 10^4, 100) # trabalhamos com DataFrame diretamente
    for c in 1:ncol(x)
        d = x[c]
        for r in 1:nrow(x)
            d[r] = rand()
        end
    end
    x
end

function f2()
    x = Vector{Any}(100)
    for c in 1:length(x)
        d = Vector{Float64}(10^4)
        for r in 1:length(d)
            d[r] = rand()
        end
        x[c] = d
    end
    DataFrame(x) # atrasamos a criação do DataFrame somente depois de terminarmos nosso trabalho
end

@btime f1();
@btime f2();

# ### Você pode adicionar linhas a um `DataFrame` de maneira *in-place* e é rápido

x = DataFrame(rand(10^6, 5))
y = DataFrame(transpose(1.0:5.0))
z = [1.0:5.0;]

@btime vcat($x, $y); # cria um novo DataFrame - lento
@btime append!($x, $y); # *in-place* - rápido

x = DataFrame(rand(10^6, 5)) # redefinir para o mesmo ponto de partida
@btime push!($x, $z); # adiciona uma única linha *in-place* - o mais rápido

# ### Permitindo `missing`s assim como `categorical`s reduz o desempenho

using StatsBase

function test(data) # usa a função countmap para testar desempenho
    println(eltype(data))
    x = rand(data, 10^6)
    y = categorical(x)
    println(" raw:")
    @btime countmap($x)
    println(" categorical:")
    @btime countmap($y)
    nothing
end

test(1:10)
test([randstring() for i in 1:10])
test(allowmissing(1:10))
test(allowmissing([randstring() for i in 1:10]))
