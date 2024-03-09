
# Diretório ---------------------------------------------------------------

setwd("C:/FCD/ProjetosFer/2 - Prevendo Eficiência de Extintores de Incêndio")
getwd()
list.files()


# Demanda -----------------------------------------------------------------


"Prever se a Chama será Extinta ou Não ao usar um Extintor de Incêndio"



# Pacotes -----------------------------------------------------------------

library(readxl)
library(tidyverse)
library(Hmisc)
library(ggplot2)
library(gridExtra)
library(corrplot)
library(randomForest)
library(caret)
library(e1071)




# Dados -------------------------------------------------------------------

dados <- read_excel("Acoustic_Extinguisher_Fire_Dataset.xlsx")
View(dados)



# Dicionário de Dados -----------------------------------------------------

#Size        =  Tamanho ("REgistrado como 7cm= 1, 12cm= 2, 14cm= 3, 16cm= 4,
#                         20cm= 5, meio acelerador = 6, acelerador máximo = 7") 
#Fuel        =  Combustível ("1 = Gasoline, 2 = Kerosene, 3 = Thinner, 4 = LPG")
#Distance    =  Distância
#Desibel     =  Desibel
#Airflow     =  Fluxo de ar
#Frequency   =  Frequência
#Status      =  Status ("0 = indica o estado de não extinção, 
#                        1 = indica o estado de extinção)



# Exploração dos Dados ----------------------------------------------------

# Verificar a dimensão dos dados, quantas linhas e colunas.
dim(dados)

# Verificar o tipo da variável
str(dados)
glimpse(dados)

# Resumo estatístico, incluindo medidas de tendência central,
# dispersão e outros valores relevantes.
summary(dados)

# Verificar valores ausentes
colSums(is.na(dados))


# Verifique quais linhas têm valores em branco após a remoção de espaços
indices_em_branco <- which(nchar(trimws(dados$STATUS)) == 0)

# Exiba os índices das linhas com valores em branco
print(indices_em_branco)



# Histograma

# Explorando a distribuição das variáveis numéricas
hist(dados$SIZE)
hist(dados$DISTANCE)
hist(dados$DESIBEL)
hist(dados$AIRFLOW)
hist(dados$FREQUENCY)



# Tabela de contingência para variável categórica
table(dados$FUEL)
table(dados$SIZE)
table(dados$STATUS)


# Resumo abrangente, incluindo média, desvio padrão, quartis etc.
describe(dados$AIRFLOW)
describe(dados$SIZE)
describe(dados$FUEL)
describe(dados$DISTANCE)
describe(dados$DESIBEL)
describe(dados$FREQUENCY)
describe(dados$STATUS)

# Gráfico de barras - Contagem ordenada por Desibel
count <- table(dados$DESIBEL)
barplot(sort(count, decreasing = TRUE), 
        main = "Numero de Desibel", 
        xlab = "Desibeis",
        ylab = "Frequencia")


# Gráfico de barras - Contagem ordenada por Fuel
count <- table(dados$FUEL)
barplot(sort(count, decreasing = TRUE), 
        main = "Numero de Fuel", 
        xlab = "Fuel",
        ylab = "Frequencia")


# Gráfico de barras - Contagem ordenada por Airflow
count <- table(dados$AIRFLOW)
barplot(sort(count, decreasing = TRUE), 
        main = "Numero de Airflow", 
        xlab = "Fluxo de Ar",
        ylab = "Frequencia")



# Gráficos de Interpretação para "STATUS da CHAMA 0 e 1"

ggplot(dados) + geom_bar(aes(x= AIRFLOW)) + facet_grid(~STATUS)          

ggplot(dados) + geom_bar(aes(x= FREQUENCY)) + facet_grid(~STATUS) 

ggplot(dados) + geom_bar(aes(x= DESIBEL)) + facet_grid(~STATUS)






# Multiplot Grid
p.SIZE               <- ggplot(dados) + geom_density(aes(SIZE))
p.FUEL               <- ggplot(dados) + geom_bar(aes(FUEL))
p.DISTANCE           <- ggplot(dados) + geom_density(aes(DISTANCE))
p.DESIBEL            <- ggplot(dados) + geom_density(aes(DESIBEL))
p.AIRFLOW            <- ggplot(dados) + geom_density(aes(AIRFLOW))
p.FREQUENCY          <- ggplot(dados) + geom_density(aes(FREQUENCY))

# Organiza no grid
grid.arrange(p.SIZE, 
             p.FUEL, 
             p.DISTANCE, 
             p.DESIBEL, 
             p.AIRFLOW, 
             p.FREQUENCY, 
             nrow = 2, 
             ncol = 3)




# Análise Estatística -----------------------------------------------------

# **ANÁLISE DA VARIÁVEL NUMÉRICA DESIBEL**

p1 <- ggplot(dados, aes(x=DESIBEL)) + 
  geom_histogram(aes(y=..density..), binwidth=1, colour="black", fill="white") +
  geom_density(alpha=.2, fill="#FA8072") +
  labs(x="DESIBEL", y="Densidade")

p2 <- ggplot(dados, aes(x=DESIBEL)) + 
  geom_density(aes(y=..density..), fill="#FA8072", alpha=0.5) +
  labs(x="DESIBEL", y="Densidade")

p3 <- ggplot(dados, aes(x="", y=DESIBEL)) + 
  geom_boxplot(fill="#FA8071", width=0.2) +
  labs(y="DESIBEL")

p4 <- ggplot(dados, aes(x=DESIBEL)) +
  geom_histogram(binwidth = 5, fill="#FA8072", color="black") +
  labs(title="", x="DESIBEL", y="Frequência")

# Combine os gráficos em uma única visualização
grid.arrange(p4, p3, ncol=2)
grid.arrange(p1)


-------------------------------------------------------------------------

# **ANÁLISE DA VARIÁVEL NUMÉRICA AIRFLOW**

p5 <- ggplot(dados, aes(x=AIRFLOW)) + 
  geom_histogram(aes(y=..density..), binwidth=1, colour="black", fill="white") +
  geom_density(alpha=.2, fill="#66e1e3") +
  labs(x="Fluxo_de_ar", y="Densidade")

p6 <- ggplot(dados, aes(x=AIRFLOW)) + 
  geom_density(aes(y=..density..), fill="#66e1e3", alpha=0.5) +
  labs(x="Fluxo_de_ar", y="Densidade")

p7 <- ggplot(dados, aes(x="", y=AIRFLOW)) + 
  geom_boxplot(fill="#66e1e3", width=0.2) +
  labs(y="Fluxo_de_ar")

p8 <- ggplot(dados, aes(x=AIRFLOW)) +
  geom_histogram(binwidth = 5, fill="#66e1e3", color="black") +
  labs(title="", x="Fluxo_de_ar", y="Frequência")

# Combine os gráficos em uma única visualização
grid.arrange(p8,p7, ncol=2)
grid.arrange(p5)


-------------------------------------------------------------------------

# **ANÁLISE DA VARIÁVEL NUMÉRICA FREQUENCY**
  
  
g1 <- ggplot(dados, aes(x=FREQUENCY)) + 
  geom_histogram(aes(y=..density..), binwidth=1, colour="black", fill="white") +
  geom_density(alpha=.2, fill="#77aaff") +
  labs(x="Frequencia", y="Densidade")

g2 <- ggplot(dados, aes(x=FREQUENCY)) + 
  geom_density(aes(y=..density..), fill="#77aaff", alpha=0.5) +
  labs(x="Frequencia", y="Densidade")

g3 <- ggplot(dados, aes(x="", y=FREQUENCY)) + 
  geom_boxplot(fill="#77aaff", width=0.2) +
  labs(y="Frequencia")

g4 <- ggplot(dados, aes(x=FREQUENCY)) +
  geom_histogram(binwidth = 5, fill="#77aaff", color="black") +
  labs(title="", x="Frequencia", y="Frequência")


# Combine os gráficos em uma única visualização
grid.arrange(g4,g3, ncol=2)
grid.arrange(g2)


-------------------------------------------------------------------------

# **ANÁLISE DA VARIÁVEL NUMÉRICA DISTANCE**


g5 <- ggplot(dados, aes(x=DISTANCE)) + 
  geom_histogram(aes(y=..density..), binwidth=1, colour="black", fill="white") +
  geom_density(alpha=.2, fill="#ebf1ad") +
  labs(x="Distancia", y="Densidade")

g6 <- ggplot(dados, aes(x=DISTANCE)) + 
  geom_density(aes(y=..density..), fill="#ebf1ad", alpha=0.5) +
  labs(x="Distancia", y="Densidade")

g7 <- ggplot(dados, aes(x="", y=DISTANCE)) + 
  geom_boxplot(fill="#ebf1ad", width=0.2) +
  labs(y="Distancia")

g8 <- ggplot(dados, aes(x=DISTANCE)) +
  geom_histogram(binwidth = 5, fill="#e7ee99", color="black") +
  labs(title="", x="Distancia", y="Frequência")

g9 <- ggplot(dados, aes(x=DISTANCE)) +
  geom_bar(fill="#e7ee99", color="black") +
  labs(title="", x="Distancia", y="Frequência")


# Combine os gráficos em uma única visualização
grid.arrange(g5,g6, g7,g9, ncol=2)



-------------------------------------------------------------------------

# **ANÁLISE DAS VARIÁVEIS CATEGÓRICAS SIZE, FUEL E STATUS**
 
# SIZE   
pp5 <- ggplot(dados, aes(x = as.factor(SIZE))) +
  geom_bar(aes(fill = ..count..)) +
  geom_text(stat='count', aes(label=..count..), vjust=-0.5) +
  scale_fill_gradient(low = "lightgreen", high = "#caffca") +
  guides(fill=FALSE) + # Isso remove a legenda de contagem
  labs(title = "", x = "Distribuição de Tamanho") +
  theme_minimal()

# FUEL
pp6 <- ggplot(dados, aes(x = as.factor(FUEL), fill = ..count..)) +
  geom_bar() +
  geom_text(stat='count', aes(label=..count..), vjust=-0.5, color="black") +
  scale_fill_gradient(low = "lightgreen", high = "#caffca") +
  guides(fill=FALSE) + # Isso remove a legenda de contagem
  labs(title = "", x = "Distribuição de Combustivel") +
  theme_minimal()

# STATUS
pp7 <- ggplot(dados, aes(x = as.factor(STATUS), fill = ..count..)) +
  geom_bar() +
  geom_text(stat='count', aes(label=..count..), vjust=-0.5, color="black") +
  scale_fill_gradient(low = "lightgreen", high = "#caffca") +
  guides(fill=FALSE) +
  labs(title = "", x = "Distribuição de Status") +
  theme_minimal()


# Combine os gráficos em uma única visualização
grid.arrange(pp5, pp6, ncol=2)
grid.arrange(pp7)




# Auto-Análise ------------------------------------------------------------


# vamos analisar se há padrões nas variaveis (DESIBEL, AIRFLOW & FREQUENCY)

# Vamos analisar todos os tamanhos da chama do combustivel 
# atraves dos valores "Min e Max" das variaveis.


# Observado:
# O Tamanho da chama (De 1:5) é extinta     == 1, se a "Frequência" for "BAIXA" e o "FLUXO_de_AR e DESIBEL" for "ALTO" 
# O Tamanho da chama (De 1:5) NÂO é extinta == 0, se a "Frequência" for "ALTA"  e o "FLUXO_de_AR e DESIBEL" for "BAIXO" 



# Gasoline:
# Se a "FREQUENCY for <= 72 "BAIXO" e "AIRFLOW for > 13.1 e DESIBEL" for > 109 "ALTO" == A CHAMA É EXTINTA
# Se a "FREQUENCY for   > 72 "ALTO" e "AIRFLOW for <= 13.1 e DESIBEL" for <= 109 "BAIXO" == A CHAMA NÂO É EXTINTA

dados %>% 
  group_by(SIZE,FUEL,STATUS) %>% 
  filter(FUEL == "gasoline") %>%
  summarise( 
    min_freq = min(as.integer(FREQUENCY)),
    max_freq = max(as.integer(FREQUENCY)),
    min_Desibel = min(as.integer(DESIBEL)),
    max_Desibel = max(as.integer(DESIBEL)),
    total = n()
  )


# Kerosene: 
# Se a "FREQUENCY for <= 70 "BAIXO" e "AIRFLOW for > 13.2 e DESIBEL" for > 110 "ALTO" == A CHAMA É EXTINTA
# Se a "FREQUENCY for > 70 "ALTO" e "AIRFLOW for <= 13.2 e DESIBEL" for <= 110 "BAIXO" == A CHAMA NÂO É EXTINTA  

dados %>% 
  group_by(SIZE,FUEL,STATUS) %>% 
  filter(FUEL == "kerosene") %>%
  summarise( 
    min_freq = min(as.integer(FREQUENCY)),
    max_freq = max(as.integer(FREQUENCY)),
    min_Desibel = min(as.integer(DESIBEL)),
    max_Desibel = max(as.integer(DESIBEL)),
    total = n()
  )


# Thinner: 
# Se a "FREQUENCY for <= 70 "BAIXO" e "AIRFLOW for > 13.2 e DESIBEL" for > 110 "ALTO" == A CHAMA É EXTINTA
# Se a "FREQUENCY for > 70 "ALTO" e "AIRFLOW for <= 13.2 e DESIBEL" for <= 110 "BAIXO" == A CHAMA NÂO É EXTINTA  

dados %>% 
  group_by(SIZE,FUEL,STATUS) %>% 
  filter(FUEL == "thinner") %>%
  summarise( 
    min_freq = min(as.integer(FREQUENCY)),
    max_freq = max(as.integer(FREQUENCY)),
    min_Desibel = min(as.integer(DESIBEL)),
    max_Desibel = max(as.integer(DESIBEL)),
    total = n()
  ) 


# LPG: 
# Se a "FREQUENCY for <= 65 "BAIXO" e "AIRFLOW for > 12.2 e DESIBEL" for > 109 "ALTO" == A CHAMA É EXTINTA
# Se a "FREQUENCY for > 65 "ALTO" e "AIRFLOW for <= 12.2 e DESIBEL" for <= 109 "BAIXO" == A CHAMA NÂO É EXTINTA  

dados %>% 
  group_by(SIZE,FUEL,STATUS) %>% 
  filter(FUEL == "lpg") %>%
  summarise( 
    min_freq = min(as.integer(FREQUENCY)),
    max_freq = max(as.integer(FREQUENCY)),
    min_Desibel = min(as.integer(DESIBEL)),
    max_Desibel = max(as.integer(DESIBEL)),
    total = n()
  )




# Transformação dos Dados --------------------------------------------------

# Criar novo dataset
dados1 <- dados


# Renomear Colunas:
dados1 <- dados1 %>%
  rename(Tamanho = SIZE,
         Combustivel = FUEL,
         Distancia = DISTANCE,
         Desibel = DESIBEL,
         Fluxo_de_ar = AIRFLOW,
         Frequencia = FREQUENCY,
         Status = STATUS
  )

dados1$Combustivel <- as.factor(dados1$Combustivel)
dados1$Tamanho <- as.factor(dados1$Tamanho)



# Balanceamento de Classes ------------------------------------------------

## Variável Combustivel

# Identifique o tamanho da maior classe
max_size <- 5130

# Para cada nível de Tamanho, faça o oversampling até alcançar o max_size (limitado a 3078)
for (level in levels(dados1$Combustivel)) {
  size_current <- sum(dados1$Combustivel == level)
  size_to_add <- max_size - size_current
  
  if (size_to_add > 0) {
    rows_to_add <- dados1[dados1$Combustivel == level, , drop = FALSE]
    # Se o número de linhas disponíveis for menor que size_to_add, repita as linhas existentes
    repeat_rows <- if (nrow(rows_to_add) < size_to_add) TRUE else FALSE
    sampled_rows <- rows_to_add[sample(1:nrow(rows_to_add), min(size_to_add, 5100), replace = repeat_rows), ]
    dados1 <- rbind(dados1, sampled_rows)
  }
}

summary(dados1$Combustivel)

# Gráfico
t1 <- ggplot(dados1, aes(x = as.factor(Combustivel), fill = ..count..)) +
  geom_bar() +
  geom_text(stat='count', aes(label=..count..), vjust=-0.5, color="black") +
  scale_fill_gradient(low = "lightgreen", high = "#caffca") +
  guides(fill=FALSE) + # Isso remove a legenda de contagem
  labs(title = "", x = "Distribuição de Combustivel") +
  theme_minimal()



 -------------------------------------------------------------------------

## Variável Tamanho


# Identifique o tamanho da maior classe
max_size_t <- 3078  


# Para cada nível de Tamanho, faça o oversampling até alcançar o max_size (limitado a 3078)
for (level in levels(dados1$Tamanho)) {
  size_current <- sum(dados1$Tamanho == level)
  size_to_add <- max_size_t - size_current
  
  if (size_to_add > 0) {
    rows_to_add <- dados1[dados1$Tamanho == level, , drop = FALSE]
    # Se o número de linhas disponíveis for menor que size_to_add, repita as linhas existentes
    repeat_rows <- if (nrow(rows_to_add) < size_to_add) TRUE else FALSE
    sampled_rows <- rows_to_add[sample(1:nrow(rows_to_add), min(size_to_add, 3078), replace = repeat_rows), ]
    dados1 <- rbind(dados1, sampled_rows)
  }
}

summary(dados1$Tamanho)

# Gráfico
t2 <- ggplot(dados1, aes(x = as.factor(Tamanho))) +
  geom_bar(aes(fill = ..count..)) +
  geom_text(stat='count', aes(label=..count..), vjust=-0.5) +
  scale_fill_gradient(low = "lightgreen", high = "#caffca") +
  guides(fill=FALSE) + # Isso remove a legenda de contagem
  labs(title = "", x = "Distribuição de Tamanho") +
  theme_minimal()


-------------------------------------------------------------------------
# GRÁFICOS DE BARRAS PARA VERIFICAR TRANSFORMAÇÃO após balanceamento.

# Combine os gráficos em uma única visualização
grid.arrange(t2, t1, ncol=2)




# Teste de Normalidade ----------------------------------------------------

# Nesse caso, aplicaremos o teste de Shapiro-Wilk, que compara os dados observados
# com os esperados de uma distribuição normal. A hipótese nula é que a amostra é normal,
# e se o teste for significativo (p < 0,05), a amostra é considerada não normal.    

# Além disso, o p-valor é um indicador estatístico que ajuda a decidir se 
# rejeitamos ou não a hipótese nula. A hipótese nula do teste de Shapiro-Wilk é
# que a população é distribuída normalmente. Um p-valor menor que o 
# nível de significância (geralmente 0.05) leva à rejeição da hipótese nula. 


# AIRFLOW - Fluxo_de_ar
# Selecionando uma amostra de 5000 observações da variável AIRFLOW
amostra_fluxo_de_ar <- sample(dados1$Fluxo_de_ar, 5000)

# Realizando o teste de Shapiro-Wilk na amostra
shapiro.test(amostra_fluxo_de_ar)

# RESULTADO: o p-valor é menor que 2.2e-16, que é extremamente pequeno e, portanto,
# rejeitamos a hipótese nula, concluindo que os dados não são normalmente distribuídos.

 -------------------------------------------------------------------------


# DESIBEL
amostra_desibel <- sample(dados1$Desibel, 5000)

# Realizando o teste de Shapiro-Wilk na amostra
shapiro.test(amostra_desibel)

# RESULTADO: o p-valor é menor que 2.2e-16, que é extremamente pequeno e, portanto,
# rejeitamos a hipótese nula, concluindo que os dados não são normalmente distribuídos.


 -------------------------------------------------------------------------


# FREQUENCIA
# Teste de Shapiro-Wilk para a coluna FREQUENCIA
amostra_frequencia <- sample(dados1$Frequencia, 5000)

# Realizando o teste de Shapiro-Wilk na amostra
shapiro.test(amostra_frequencia)

# RESULTADO: O p-valor é menor que 2.2e-16, o que é significativamente abaixo de 0.05,
# levando à rejeição da hipótese nula de normalidade. 


-------------------------------------------------------------------------


# DISTANCIA
amostra_distancia <- sample(dados1$Distancia, 5000)

# Realizando o teste de Shapiro-Wilk na amostra
shapiro.test(amostra_distancia)

# RESULTADO: O p-valor é menor que 2.2e-16, o que é significativamente abaixo de 0.05,
# levando à rejeição da hipótese nula de normalidade. 




# Aplicação da Técnica de Normalização -------------------------------------------------


# A técnica utilizada para transformação dos dados será de RAIZ-QUADRADA para cada variavel.


dados1$Distancia <- sqrt(dados1$Distancia)
dados1$Desibel <- sqrt(dados1$Desibel)
dados1$Fluxo_de_ar <- sqrt(dados1$Fluxo_de_ar)
dados1$Frequencia <- sqrt(dados1$Frequencia)

# Verifique os resultados
summary(dados1)

# Plote um gráfico de probabilidade normal para verificar a distribuição
par(mfrow = c(2, 2))
for (col in c("Distancia", "Desibel", "Fluxo_de_ar", "Frequencia")) {
  qqnorm(dados1[[col]], main = col)
  qqline(dados1[[col]])
}





# Configuração para Multi-Gráficos Q-Q Plot -------------------------------------



# Configurar o layout para mostrar múltiplos gráficos
par(mfrow = c(2, 2))


# Criar um gráfico Q-Q para a variável DISTANCE_transformado
qqnorm(dados1$Distancia, main = "Distancia")
qqline(dados1$Distancia, col = "red")
# Distancia: Os valores vão de 3.162 a 13.784, com uma mediana de 10.000.
# A distribuição parece ser mais dispersa, indicando uma variação maior nos dados transformados.


# Criar um gráfico Q-Q para a variável DESIBEL_transformado
qqnorm(dados1$Desibel, main = "Desibel")
qqline(dados1$Desibel, col = "red")
# Desibel: Os valores estão entre 8.485 e 10.630, com uma mediana de 9.747.
# Os dados transformados parecem ter uma distribuição mais estreita e concentrada,
# sugerindo menos variabilidade após a transformação.


# Criar um gráfico Q-Q para a variável AIRFLOW_transformado
qqnorm(dados1$Fluxo_de_ar, main = "Fluxo_de_ar")
qqline(dados1$Fluxo_de_ar, col = "red")
# Fluxo_de_ar: A presença de um valor mínimo de 0.000 é incomum, pois a transformação 
# de raiz quadrada não deveria resultar em zeros, a menos que os dados originais também 
# contenham zeros. Isso pode indicar a presença de valores zero nos dados originais.


# Criar um gráfico Q-Q para a variável FREQUENCY_transformado
qqnorm(dados1$Frequencia, main = "Frequencia")
qqline(dados1$Frequencia, col = "red")
# Frequencia: Os valores variam de 1.000 a 8.660, com uma mediana de 5.244.
# A distribuição dos dados transformados parece ser mais equilibrada e menos inclinada
# do que a distribuição original.






# Análise de Correlação entre Variáveis -----------------------------------


# Definindo as colunas para análise de correlação
cols1 <- c("Tamanho","Combustivel","Distancia","Desibel","Fluxo_de_ar",
           "Frequencia","Status")


-------------------------- Aviso  ------------------------------------------
# Para executar o mapa de correlaçao é preciso que a variavel seja numerica
# Então desfazer a transformação da variavel fator para numerica 

# Transformar a variavel fator em numerica
dados1$Tamanho <- as.numeric(dados1$Tamanho)
dados1$Combustivel<- as.numeric(dados1$Combustivel)


# vetor com os metodos de correlação
metodos <- c("pearson","spearman")


# Aplicando os métodos de correlação com a função cor()
cors <- lapply(metodos, function(method)
  (cor(dados1[,cols1], method = )))

# visualização da escala positivo/negativo de 0 a 1
head(cors)

# Preparando o plot
require(lattice)
plot.cors <- function(x, labs){
  diag(x) <- 0.0
  plot(levelplot(x,
                 main = paste("Plot de Correlação usando Metodo", labs),
                 scales = list(x = list(rot =90), cex = 1.0)))
}

# Mapa de Correlação
# significa relação (positiva sendo 1) e menos (negativa -1) e não há relação proximo de 0.
Map(plot.cors,cors, metodos)






# Outra Visualização de Mapa de Correlação ------------------------------------------------

# Matriz de correlação
matriz_correlacao <- cor(dados1[, c("Tamanho", "Distancia", "Desibel", "Fluxo_de_ar", "Frequencia", "Status")])

matriz_correlacao <- cor(dados1[, c("Status", "Distancia", "Desibel", "Fluxo_de_ar", "Frequencia", "Tamanho")])


# Gráfico de matriz de correlação com corrplot
corrplot(matriz_correlacao, method = "circle", tl.col = "black", title = "")


 


# Criar modelo para selecionar as Variaveis significativas ----------------

#Refazer a transformação de numerica para fator
dados1$Status <- as.factor(dados1$Status)

# Criando um modelo para identificar os atributos com maior importância para o modelo preditivo

# Avaliando a importância de todas as variaveis
modelo <- randomForest(Status ~ .,
                       data = dados1,
                       ntree = 100,
                       nodesize = 10,
                       importance = TRUE)

# Plotando as variaveis por grau de importancia - quanto mais a direita melhor é a importância!
varImpPlot(modelo)

"Vou optar em utilizar todas as variaveis e depois retiro conforme avaliação de importância do modelo"





# Regressão Logística -----------------------------------------------------

# Funcao do Caret para divisao dos dados
split <- createDataPartition(y = dados1$Status, p = 0.7, list = FALSE)

# Criando dados de treino e de teste
dados_treino <- dados1[split,]
dados_teste <- dados1[-split,]


# verificando a distribuição dos dados originais e das partições
prop.table(table(dados_teste$Status)) * 100
prop.table(table(dados_treino$Status)) * 100





# Treino Modelo 1 ---------------------------------------------------------
?svm

fit1 <- train(Status ~., data = dados_treino, method = "svmRadial")

print(fit1)

plot(fit1)

# Teste - Modelo 3

# Previsão para dados de Teste
predicoes.svm <- predict(fit1, dados_teste)


# Matriz de confusão
confusionMatrix(predicoes.svm, dados_teste$Status)

# acuracia: 93%




# Treino Modelo 2 ---------------------------------------------------------
?randomForest

fit2 <- train(Status ~., data = dados_treino, method = "rf")

print(fit2)

# Teste - modelo 4

# Previsão para dados de Teste
predicoes.rf <- predict(fit2,dados_teste)

# Matriz de confusão
confusionMatrix(predicoes.rf, dados_teste$Status)

plot(fit2)

# Acuracia: 97%




# Conclusão ---------------------------------------------------------------


"O modelo Random forest (fit2), apresentou uma taxa de erro menor e, correspondendo 97% 
# da variancia nos dados de teste. Portanto, deve ser usado como versão final."

"Sim, conseguimos prever se a Chama será Extinta ou não."

# mude as variaveis - substitua "$Desibel" para fazer outras previsoes
cat(sprintf("\n Previsão de \"%s\" é \"%s\"\n", dados_teste$Desibel, predicoes.rf))




# Salvar Script -----------------------------------------------------------
library(openxlsx)

# salvar dataset em formato excel
write.xlsx(dados1, file = "dados_extintor_oficial.xlsx")

# salvar dataset em formato CSV
write.csv(dados1, 'dados_extintor_oficial', row.names = F)

# View dos arquivos
getwd()
list.files()


