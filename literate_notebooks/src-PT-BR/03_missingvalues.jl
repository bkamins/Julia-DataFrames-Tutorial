# # Introdução ao DataFrames
# **[Bogumił Kamiński](http://bogumilkaminski.pl/about/), 23 de Maio de 2018**
#
# Tradução de [Jose Storopoli](https://storopoli.io).

using DataFrames # carregar o pacote

# ## Lidando com valores faltantes
#
# Um tipo de *singleton* `Missings.Missing` nos permite lidar com valores ausentes.

missing, typeof(missing)

# As arrays criam automaticamente um tipo de união `Union` apropriado.

x = [1, 2, missing, 3]

# `ismissing` verifica se o valor passado é faltante (`missing`).

ismissing(1), ismissing(missing), ismissing(x), ismissing.(x)

# Podemos extrair o tipo combinado com `Missing` de uma `Union` por meio de
#
# (Isso é útil para matrizes!)

eltype(x), Missings.T(eltype(x))

# comparações de `missing` produzem `missing`.

missing == missing, missing != missing, missing < missing

# Isso também ocorre quando os `missing`s são comparados com valores de outros tipos.

1 == missing, 1 != missing, 1 < missing

# `isequal`, `isless`, e `===` produzem resultado de tipo `Bool`.

isequal(missing, missing), missing === missing, isequal(1, missing), isless(1, missing)

# Nos próximos exemplos, vemos que muitas (mas não todas) funções coseguem lidar com `missing`.

map(x -> x(missing), [sin, cos, zero, sqrt]) # parte 1

# -

map(x -> x(missing, 1), [+, - , *, /, div]) # parte 2

# -

map(x -> x([1,2,missing]), [minimum, maximum, extrema, mean, any, float]) # parte 3

# `skipmissing` retorna um iterador ignorando os valores `missing`s. Podemos usar `collect` e `skipmissing` para criar um array que exclui esses valores `missing`s.

collect(skipmissing([1, missing, 2, missing]))

# Da mesma forma, aqui combinamos `collect` e `Missings.replace` para criar uma array que substitui todos os valores `missing`s por algum valor (`NaN` neste caso).

collect(Missings.replace([1.0, missing, 2.0, missing], NaN))

# Uma outra maneira de fazer o mesmo:

coalesce.([1.0, missing, 2.0, missing], NaN)

# Cuidado: `nothing` também seria substituído aqui (para Julia 0.7 um comportamento mais sofisticado de `coalesce` que permite evitar este problema está planejado).

coalesce.([1.0, missing, nothing, missing], NaN)

# Você pode usar `recode` se tiver tipos de saída homogêneos.

recode([1.0, missing, 2.0, missing], missing => NaN)

# Você pode usar `unique` ou `levels` para obter valores únicos com ou sem `missing`s, respectivamente.

unique([1, missing, 2, missing]), levels([1, missing, 2, missing])

# No próximo exemplo, convertemos `x` em `y` com `allowmissing`, onde `y` tem um tipo que aceita `missing`s.

x = [1,2,3]
y = allowmissing(x)

# Então, nós convertemos de volta com `disallowmissing`. Isso falharia se `y` contivesse valores `missing`!

z = disallowmissing(y)
x, y, z

# No próximo exemplo, mostramos que o tipo de cada coluna de `x` é inicialmente `Int64`. Depois de usar `allowmissing!` Para aceitar valores `missing`s nas colunas 1 e 3, os tipos dessas colunas se tornam `Union`s de `Int64` e `Missings.Missing`.

x = DataFrame(Int, 2, 3)
println("Antes: ", eltypes(x))
allowmissing!(x, 1) # fazer com que a primeira coluna aceite `missing`s
allowmissing!(x, :x3) # fazer com que a coluna `:x3` aceite `missing`s
println("Depois: ", eltypes(x))

# Neste próximo exemplo, usaremos `completecases` para encontrar todas as linhas de um `DataFrame` que possuem dados completos.

x = DataFrame(A=[1, missing, 3, 4], B=["A", "B", missing, "C"])
println(x)
println("Casos completos:\n", completecases(x))

# Podemos usar `dropmissing` ou `dropmissing!` para remover as linhas com dados incompletos de um `DataFrame` para criar um novo `DataFrame` ou modificar o original *in-place*.

y = dropmissing(x)
dropmissing!(x)
[x, y]

# Quando usamos `showcols` em um `DataFrame` eliminando os valores `missing`s, as colunas ainda permitem valores `missing`s.

showcols(x)

# Uma vez que excluímos valores valores `missing`s, podemos usar com segurança `disallowmissing!` para que as colunas não aceitem mais valores `missing`s.

disallowmissing!(x)
showcols(x)
