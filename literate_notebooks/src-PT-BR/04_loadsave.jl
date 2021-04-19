# # Introdução ao DataFrames
# **[Bogumił Kamiński](http://bogumilkaminski.pl/about/), 23 de Maio de 2018**
#
# Tradução de [Jose Storopoli](https://storopoli.io).

using DataFrames # carregar o pacote

# ## Carregando e Salvando DataFrames
# Não cobrimos todos os recursos dos pacotes. Consulte a documentação para aprendê-los.
#
# Aqui vamos carregar o pacote `CSV` para ler e escrever arquivos CSV e o pacote `JLD`, que nos permite trabalhar com um formato binário nativo Julia.

using CSV
using JLD

# Vamos criar um `DataFrame` simples para fins de teste,

x = DataFrame(A=[true, false, true], B=[1, 2, missing],
              C=[missing, "b", "c"], D=['a', missing, 'c'])


# e usar `eltypes` para ver os tipos de colunas.

eltypes(x)

# Vamos usar o pacote `CSV` para salvar `x` no disco; certifique-se de que `x.csv` não entre em conflito com algum arquivo em seu diretório de trabalho.

CSV.write("x.csv", x)

# Agora podemos ver como ele foi salvo lendo `x.csv`.

print(read("x.csv", String))

# Também podemos carregá-lo de volta. `use_mmap = false` desativa o mapeamento de memória para que no Windows o arquivo possa ser excluído na mesma sessão.

y = CSV.read("x.csv", use_mmap=false)

# Ao carregar em um `DataFrame` de um `CSV`, todas as colunas permitem `Missing` por padrão. Observe que os tipos de coluna mudaram!

eltypes(y)

# Agora vamos salvar `x` em um arquivo em formato binário; certifique-se de que `x.jld` não exista em seu diretório de trabalho.

save("x.jld", "x", x)

# Depois de carregar `x.jld` como `y`, vemos que `y` é idêntico a` x`.

y = load("x.jld", "x")

# Observe que os tipos de coluna de `y` são iguais aos de `x`!

eltypes(y)

# A seguir, criaremos os arquivos `bigdf.csv` e `bigdf.jld`, então tome cuidado para que você ainda não tenha esses arquivos no disco!
#
# Em particular, vamos cronometrar quanto tempo leva para escrevermos um `DataFrame` com 10^3 linhas e 10^5 colunas para arquivos `.csv` e `.jld`. *Você pode apostar que o JLD seja mais rápido!* Use `compress = true` para reduzir o tamanho dos arquivos.

bigdf = DataFrame(Bool, 10^3, 10^2)
@time CSV.write("bigdf.csv", bigdf)
@time save("bigdf.jld", "bigdf", bigdf)
getfield.(stat.(["bigdf.csv", "bigdf.jld"]), :size)

# Finalmente, vamos fazer uma faxina geral dos arquivos que criamos. Não execute a próxima célula a menos que tenha certeza de que seus arquivos importantes não serão apagados.

foreach(rm, ["x.csv", "x.jld", "bigdf.csv", "bigdf.jld"])
