## **Machine Learning na Segurança do Trabalho Prevendo a Eficiência de Extintores de Incêndio.**

 ### **1. Introdução**


O teste hidrostático de extintor é um procedimento estabelecido pelas normas da ABNT 
NBR 12962/2016, que determinam que todos os extintores devem ser testados a cada cinco 
anos, com a finalidade de identificar eventuais vazamentos, além de também verificar a 
resistência do material do extintor.
Com isso, o teste hidrostático de extintor pode ser realizado em baixa e alta pressão, de acordo com estas normas em questão. O procedimento é realizado por profissionais técnicos 
da área e com a utilização de aparelhos específicos e apropriados para o teste, visto que eles 
devem fornecer resultados com exatidão.
Seria possível usar Machine Learning para prever o funcionamento de um extintor de 
incêndio com base em simulações feitas em computador e assim incluir uma camada adicional 
de segurança nas operações de uma empresa?
<br>
<br>


---
 ### **2. Objetivo**

O objetivo deste projeto é **construir um modelo de machine learning capaz de prever, se a chama será extinta ou não ao usar um extintor de incêndio.** Para isso, utilizaremos informações obtidas a partir de testes de extinção de chamas com ondas sonoras.

A importância desse modelo reside na possibilidade de aumentar a segurança das empresas. Ao prever a eficiência dos extintores de incêndio, podemos tomar medidas preventivas e garantir que os dispositivos estejam funcionando adequadamente quando necessário.
<br>
<br>

---
 ### **3. Organização do Projeto**

```
1. Introdução
2. Objetivo
3. Organização do Projeto
4. Descrição dos Dados
    4.1 Conjunto de dados
    4.2 Dicionário de dados 
    4.3 Pacotes  
    4.4 Análise Exploratória de Dados
        - Coletar os Dados
        - Explorar as Variváveis
        - Limpar os Dados
        - Detecção de Outliers
        - Transformação dos Dados
        - Análise Estatística: 
          - Variável Numérica
          - Correlação entre Variáveis
          - Variável Categórica
        - Balanceamento de Classes
        - Teste de Normalização 
5. Desenvolvimento do Projeto
    5.1 Seleção de Variáveis Significativas para o Modelo
    5.2 Regressão logística:
        - Treinamento e Teste de Modelos:
        - modelo_1
        - modelo_2
        - modelo_3
6. Conclusão do Projeto
7. Referências Bibliográficas 
```
<br>

---

 ### **4. Descrição de Dados**

### ```4.1 Conjunto de Dados ``` 
O conjunto de dados [Acoustic Extinguisher Fire](https://ieee-dataport.org/documents/acoustic-extinguisher-fire-dataset) foi obtido por meio de testes de extinção de chamas usando um sistema de extinção baseado em ondas sonoras. Esse sistema inclui 4 subwoofers com uma potência total de 4.000 Watts. Durante os experimentos, foram utilizados diferentes tipos de combustíveis e variações no tamanho da chama. Além disso, o sistema envolveu medições de intensidade do som, fluxo de ar e temperatura da chama.
<br>

A fonte de alimentação que alimenta o sistema e o circuito do filtro garantindo que 
as **frequências de som** sejam transmitidas adequadamente para o sistema está localizada dentro 
da unidade de controle.
Enquanto o computador é usado como fonte de frequência, o 
anemômetro foi usado para medir o **fluxo de ar** resultante das ondas sonoras durante a fase de 
extinção da chama e um decibelímetro para medir a **intensidade do som.** <br>

Um termômetro infravermelho foi utilizado para medir a temperatura da chama e da lata de combustível, e uma 
câmera é instalada para **detectar o tempo de extinção da chama.** <br>
 Um **total de 17.442 testes** foram realizados com esta configuração experimental. 
<br>
<br>
<br>





### ```4.2 Dicionário de Dados ```


|Variável | Descrição |
|:------- | :--------- | 
|**Size:**   | Representa o tamanho da chama  (Registrado como 7 cm = 1, 12 cm = 2, 14 cm = 3, 16 cm = 4, 20 cm = 5, meio acelerador = 6, acelerador máximo = 7).|
|**Fuel:**   |    Indica o tipo de combustível usado (1 = Gasolina, 2 = Querosene, 3 = Solvente, 4 = GLP).|
|**Distance:**  |    Distância entre o extintor e a chama.   |   
|**Decibel:**    |    Intensidade do som.    |  
|**Airflow:**    |   Medida do fluxo de ar resultante das ondas sonoras durante a fase de extinção da chama.  |
|**Frequency:**    |   Frequência das ondas sonoras aplicadas durante o teste.   |  
|**Status:**    | Indica se a chama foi extinta ou não (0 = indica o estado de não extinção, 1 = indica o estado de extinção).|

<br>
<br>

### ```4.3 Pacotes:``` O projeto será realizado na Linguagem R.

* **Readxl:** Importa dados de arquivos Excel para o R.
* **Tidyverse:**   Facilita a manipulação, visualização e análise de dados com dplyr, ggplot2, tidyr etc.
* **Hmisc:** Úteis para análise de dados, gráficos, manipulação de strings, cálculo de tamanho de amostra etc.
* **Ggplot2:** Cria gráficos elegantes e personalizáveis.
* **GridExtra:** Combina vários gráficos em uma figura.
* **Corrplot:** Visualiza matrizes de correlação.
* **RandomForest:** Implementa o algoritmo de floresta aleatória para classificação e regressão.
* **Caret:** Facilita treinamento e avaliação de modelos de aprendizado de máquina.
* **e1071:** Suporte a diferentes tipos de kernel, como linear, polinomial, base radial e sigmoidal. Esses kernels são usados durante o treinamento e a previsão do SVM.


<br>
<br>


### ``` 4.4 Análise Exploratória de Dados```

 Nesta etapa, a análise exploratória de dados (AED) é um processo fundamental no campo da ciência de dados e estatísticas, cujo objetivo principal é entender a natureza dos dados disponíveis. Este processo envolve a utilização de diversas técnicas gráficas e estatísticas para resumir, visualizar e interpretar as características fundamentais de um conjunto de dados.



 * **Coletar os Dados:** Estamos usando a função ```read_excel()``` do pacote ```readxl``` para importar um conjunto de dados que está em um arquivo excel chamado “Acoustic_Extinguisher_Fire_Dataset.xlsx”,  e guardamos o conjunto de dados na variável dados. <br>
 ```**R**
dados <- read_excel("Acoustic_Extinguisher_Fire_Dataset.xlsx")
```
<br>

* **Explorar as Variáveis:** 
  * Dimensão do conjunto de dados: A função ```dim(dados)``` mostra que o conjunto de dados tem 17442 linhas e 7 colunas.<br>
  
  * Estrutura dos dados: A função  ```str(dados)``` mostra que é um objeto do tipo “tibble”, contem 7 variáveis, chamadas SIZE, FUEL, DISTANCE, DESIBEL, AIRFLOW, FREQUENCY e STATUS.
  
  * As variáveis numéricas: SIZE, DISTANCE, DESIBEL, AIRFLOW, FREQUENCY e STATUS.
  * Uma variável character: FUEL
<br>
  
* **Limpar os Dados:** 
  * Valores Ausentes: O código ```colSums(is.na(dados))``` soma o número de valores ausentes em cada coluna.  Neste caso, o conjunto de dados não possui valores faltantes.

  * Espaços em Branco: O código ```which(nchar(trimws(dados$STATUS))=="0")``` encontra as posições dos valores ausentes por espaços em branco na coluna STATUS do conjunto de dados. Neste caso, não possui espaço em branco.
<br>

* **Detecção de Outliers:** Apesar da ampla variação observada    nas variáveis numéricas, incluindo a presença de valores discrepantes (outliers), optou-se por não realizar o tratamento de outliers. Esta decisão é motivada pela natureza da demanda, que visa determinar a extinção da chama com base em diversas métricas, como distância (mais baixa ou mais alta), nível de decibéis (mais baixo ou mais alto), frequência (mais baixa ou mais alta) e fluxo de ar (mais baixo ou mais alto). Consequentemente, o modelo base será construído sem a modificação da variação dos dados, e qualquer tratamento para outliers será considerado posteriormente, se necessário.
<br>

* **Transformação dos Dados:**

  * Transformar Variáveis Numéricas em Categóricas: usando a função ```ordered``` para criar uma variável ordinal, que é um tipo especial de fator que tem uma ordem definida entre os níveis, as variáveis que serão transformadas são: (SIZE, FUEL, STATUS).

  * Renomear Colunas: usando a função ```rename``` do pacote ```tidyverse``` que permite alterar os nomes de colunas individuais usando a sintaxe ```novo_nome = nome_antigo```, apenas substituimos o idioma das variáveis de inglês para português.
  <br>

* **Análise Estatística:** As variáveis serão analisadas em dois grupos numéricos e categóricos e a correlação entre elas para verificar a distribuição e o balanceamento.  A função ```summary()``` será utilizada para descrever os dados, e gráficos ajudarão na interpretação. Medidas de tendência central, como média e mediana, são fundamentais para compreender a distribuição dos dados, identificar outliers e fundamentar decisões baseadas em evidências.<br>
  <br>
  <br>

  #### **ANÁLISE DA VARIÁVEL NUMÉRICA DESIBEL**
  ---
  <BR>

  Gráfico-1, **"Histograma de Desibel "** e **"Boxplot de Desibel"**
  ![alt text](https://github.com/FernandaPavan/Previsao_Eficiencia_de_Extintor/assets/110939025/d756f416-26ee-47a6-8b64-6e10f04f9bdb)

  <BR>
  <br>

  No gráfico-1, o menor valor registrado ```(Min.)``` é de **72.00** decibéis. O Primeiro Quartil (1st Qu.) indica que **25%** dos dados são menores ou iguais a **90.00** decibéis. A Mediana ```(Median)``` é o valor que se encontra no meio da amostra quando os dados estão ordenados, e neste caso, é de **95.00** decibéis. Isso significa que metade dos dados está abaixo desse valor e a outra metade está acima, dividindo a amostra em duas partes iguais.

  A Média ```(Mean)``` dos níveis de ruído é de **96.38** decibéis. Vale ressaltar que a média pode ser influenciada por valores muito altos ou muito baixos, o que pode distorcer a representação da distribuição dos níveis de ruído se existirem valores discrepantes (outliers). O Terceiro Quartil (3rd Qu.) mostra que **75%** dos dados são menores ou iguais a **104.00** decibéis, indicando que a maior parte dos níveis de ruído na amostra é consideravelmente alta.
  E, o valor Máximo ```(Max.)``` registrado é de **113.00** decibéis, refletindo o nível mais alto de ruído observado.
  <BR>
  <BR>
  <br>

  Gráfico-2, **"Densidade de Desibel"**
  ![alt text](https://github.com/FernandaPavan/Previsao_Eficiencia_de_Extintor/assets/110939025/858d3827-978a-4cf3-98fa-03f00871be98)


  No gráfico-2, assim como no histograma, observamos a presença de dois picos em uma distribuição bimodal. Isso indica que existem dois valores ou intervalos de valores que ocorrem com mais frequência na amostra de dados.  Essa configuração pode surgir em situações onde há duas tendências ou comportamentos diferentes influenciando os dados, resultando em duas modas predominantes. 
  <br>
  <br>
  <br>

  #### **ANÁLISE DA VARIÁVEL NUMÉRICA FLUXO_DE_AR**
  ---
  <br>

  Gráfico-3, **"Histograma de Fluxo_de_ar "** e  **"Boxplot de Fluxo_de_ar"**
  ![alt text](https://github.com/FernandaPavan/Previsao_Eficiencia_de_Extintor/assets/110939025/1a13d6ac-5ea9-4090-affd-7a1b3d1bf00f)

  <BR>
  <BR>
  
  No gráfico-3, o menor valor de fluxo de ar registrado ```(Min.)``` é **0.000**, o que pode sugerir momentos sem fluxo de ar ou medições em repouso. O Primeiro Quartil (1st Qu.) mostra que **25%** dos dados são **3.200** ou menos, indicando que a maioria dos valores de fluxo de ar é maior. A Mediana ```(Median)```, situada no ponto médio dos dados ordenados, é **5.800**, dividindo assim a amostra ao meio com valores tanto abaixo quanto acima desse ponto.

  A Média ```(Mean)``` do fluxo de ar é **6.976**, e é importante notar que ela pode ser influenciada por valores extremamente altos ou baixos. O Terceiro Quartil (3rd Qu.) indica que **75%** dos dados são **11.200** ou menos, o que sugere que a maior parte do fluxo de ar não é excessivamente alta. Por fim, o valor Máximo ```(Max.)``` observado é **17.000**, marcando o nível mais alto de fluxo de ar na amostra.
  
  <br>
  <br>
  <br>

  Gráfico-4, **"Densidade de Fluxo_de_ar"**
  ![alt text](https://github.com/FernandaPavan/Previsao_Eficiencia_de_Extintor/assets/110939025/8e1f1da2-5c03-43f3-9000-404fbae23fa9)


  No gráfico-4, a densidade do gráfico tem uma inclinação para a direita, com uma cauda mais longa estendendo-se para valores maiores. O Primeiro Quartil (1st Qu.) de **3.200** indica que **25%** dos valores estão abaixo desse ponto, e a densidade começa a aumentar a partir daqui. A Mediana (Median) de **5.800** marca um ponto significativo no gráfico, representando o valor central da distribuição dos dados. Já no Terceiro Quartil (3rd Qu.) de **11.200**, a densidade começa a se achatar, mostrando que **75%** dos valores estão abaixo desse nível e que há uma diminuição na frequência de valores mais altos.
<br>
<br>
<br>

  #### **ANÁLISE DA VARIÁVEL NUMÉRICA FREQUENCIA**
  ---
  <BR>

  Gráfico-5, **"Histograma de Frequencia "** e  **"Boxplot de Frequencia"**
  ![alt text](https://github.com/FernandaPavan/Previsao_Eficiencia_de_Extintor/assets/110939025/87bfb455-03d2-4ccb-b535-a30cd4c07288)

  <br>
  <br>

  No gráfico-5, a frequência mínima observada ```(Min.)``` é **1.00**, o que pode indicar períodos de inatividade ou registros pontuais. O Quartil Inferior (1st Qu.) revela que **25%** dos registros são **14.00** ou inferiores, sugerindo que os demais valores de frequência são superiores. A Mediana ```(Median)```, posicionada na metade dos dados classificados, é **27.50**, partindo a série de dados em dois grupos com valores abaixo e acima dessa marca.

  O Valor Médio ```(Mean)``` da frequência é **31.61**, e vale ressaltar que este pode ser afetado por registros muito altos ou muito baixos. O Quartil Superior (3rd Qu.) mostra que **75%** dos registros são **47.00** ou inferiores, indicando que a maior parte das frequências não é elevada. A frequência máxima registrada ```(Max.)``` é **75.00**, representando o pico de frequência nos dados.
  <br>
  <br>
  <br>

  Gráfico-6, **"Densidade de Frequencia"**
  ![alt text](https://github.com/FernandaPavan/Previsao_Eficiencia_de_Extintor/assets/110939025/bb306e6d-2645-4f1d-ae50-081262065bfb)


  Visualmente, o gráfico-6 de densidade mostra uma elevação progressiva do valor mínimo até alcançar um pico antes da mediana **(27.50)**. A média **(31.61)**, sendo maior que a mediana, sugere uma distribuição com uma extensão maior para os valores mais elevados de frequência, caracterizando uma cauda à direita. Esse aumento é seguido por um declínio que se acentua após o terceiro quartil **(47.00)**, concluindo em **75.00.**
  <br>
  <br>
  <br>

  #### **ANÁLISE DA VARIÁVEL NUMÉRICA DISTANCIA**
  ---
  <BR>

  Gráfico-7, **"Densidade, Histograma e Boxplot de Distancia"**
  ![alt text](https://github.com/FernandaPavan/Previsao_Eficiencia_de_Extintor/assets/110939025/970ab56f-554c-48fd-834f-b9db406c0432)


                Valor    | Frequência | Proporção
                ---------|------------|----------
                10       | 918        | 0.053
                20       | 918        | 0.053
                ...      | ...        | ...
                190      | 918        | 0.053
  <br>


  No gráfico-7, a variável Distancia possui valores distintos, que vão de **10 a 190 em intervalos de 10**, ocorre com a mesma frequência de **918 vezes**, o que representa uma **proporção de 0.053** do total de observações para cada valor.

  Conforme o histograma, isso é representado por barras de altura igual para cada intervalo de valores, refletindo a **distribuição uniforme**. A média e a mediana iguais a **100**, bem como a simetria dos quartis em torno da mediana, reforça a uniformidade da distribuição.
  <br>
  <br>

  #### **ANÁLISE DE CORRELAÇÃO ENTRE VARIÁVEIS.**
  ---

  Nesta etapa, analisamos a relação ou associação entre diferentes variáveis no conjunto de dados. A correlação nos ajuda a compreender como essas variáveis estão interligadas e a identificar padrões nos dados.

 <br>
 <br>
 <br>

  Gráfico-8, **"Matriz de Correlação"**
  ![alt text](https://github.com/FernandaPavan/Previsao_Eficiencia_de_Extintor/assets/110939025/b7c17e80-4a51-4c15-8ae3-f505f79a9eba)


  <br>
  
  Neste caso, as variáveis que estão mais correlacionadas são Desibel e Fluxo_de_ar. Iremos avaliá-las melhor em relação à variável alvo ‘Status’.
  <br>
  <br>
  <br>

  Gráfico-9, **"Fluxo_de_ar_x_Status"**
  ![alt text](https://github.com/FernandaPavan/Previsao_Eficiencia_de_Extintor/assets/110939025/399964e2-178e-4609-b95c-7fe5fbceec44)


  No gráfico-9,  ao analisarmos, notamos que há valores extremos (zeros). Seguindo a análise, percebemos um aumento no fluxo de ar que está associado à extinção da chama. Contudo, é preciso ter cautela ao considerar essa associação como absoluta, uma vez que o mesmo pico na frequência ‘3 e 5’ é observado em ambas as modalidades, tanto na chama (não extinta = 0) quanto na chama (extinta = 1).
  <BR>
  <BR>
  <BR>

  Gráfico-10, **"Frequência de fluxo de ar_x_Status"**
  ![alt text](https://github.com/FernandaPavan/Previsao_Eficiencia_de_Extintor/assets/110939025/ebb73dcb-9a68-44cb-a414-2137aafbc585)



  Os gráficos 9 e 10, apresentam a mesma informação, mas sob diferentes perspectivas angulares. A presença do pico "3 e 5" em ambos sugere que outros fatores podem estar influenciando o resultado.
  <br>
  <br>
  <br>


  Gráfico-11, **"Frequência de Desibel_x_Status"**
  ![alt text](https://github.com/FernandaPavan/Previsao_Eficiencia_de_Extintor/assets/110939025/999646e1-c070-4877-974b-bfa11abe1eb2)

  <br>
  <br>
  <br>
  <br>


  Gráfico-12, **"Correlação entre Desibel_x_Airflow_x_Status"**
  ![alt text](https://github.com/FernandaPavan/Previsao_Eficiencia_de_Extintor/assets/110939025/6c95807b-b306-441c-94b0-853a4f87d944)


  <br>
  No gráfico 11 e 12, vemos que a chama se apaga quando o nível de decibéis fica entre 86 e 113 e o fluxo de ar varia entre 3 e 17, com uma frequência entre 10 e 45. Porém, essa relação não é suficiente para explicar o fenômeno, pois também há um pico para as duas situações da chama: acesa (0) ou apagada (1).
  <BR>
  <BR>
  <BR>


  #### **ANÁLISE DAS VARIÁVEIS CATEGÓRICAS: TAMANHO, COMBUSTIVEL E STATUS.**
  ---
  <BR>

  Gráfico-13, **"Distribuição de Tamanho e Combustivel"**
  ![alt text](https://github.com/FernandaPavan/Previsao_Eficiencia_de_Extintor/assets/110939025/e18b1b5e-c650-4a10-9c17-25c1bd94d4b1)

  <br>
  <br>

  No gráfico-13, a variável **Tamanho** apresenta uma distribuição de frequência desigual, onde os **valores de 1 a 5 ocorrem 3078** vezes cada, indicando uma maior frequência em comparação com os **valores 6 e 7**, que aparecem **1026** cada.
  Na distribuição da variável **Combustivel**, observa-se também uma frequência desigual, indicando que gasolina, querosene e thinner têm a mesma alta frequência de ocorrências, cada um aparecendo **5130** vezes. Em contraste, o lpg é menos frequente, com **2052 ocorrências**. 
  

  <br>
  <br>
  <br>

  Gráfico-14, **"Distribuição de Status"**
  
  ![alt text](https://github.com/FernandaPavan/Previsao_Eficiencia_de_Extintor/assets/110939025/075dda1e-efc8-481c-9795-db8eb57c5b0a)

  <br>
  <br>

  No gráfico-14, a variável **Status** mostra uma distribuição quase equilibrada, com **8759** ocorrências do **valor 0** e **8683** ocorrências do **valor 1**, indicando uma proporção quase balanceada entre as duas categorias.
  <br>
  <br>
  <br>

* **Balanceamento de Classes:** Embora o desbalanceamento entre as classes "Status" seja leve, optamos por não aplicar técnicas de balanceamento neste momento. No entanto, o balanceamento será reavaliado em etapas posteriores, caso o desnível entre as classes se torne mais acentuado.
  <br>
  <br>
  <br>
 
* **Teste de Normalidade:** Verifica se os dados de uma variável seguem uma distribuição normal. Nesse contexto, aplicaremos o ```teste de Shapiro-Wilk```, que compara os dados observados com os esperados de uma distribuição normal.<br> 
  A hipótese nula é que a amostra é normal, e se o teste for significativo (p < 0,05), a amostra é considerada não normal.
  <br>
  <br>
  <br>
* Aplicado o Teste na Amostra da Variável: FLUXO_DE_AR
 ---
  ```
        Shapiro-Wilk normality test

  data:  amostra_fluxo_de_ar
  W = 0.94062, p-value < 2.2e-16
  ```
  <br>
 

  * Aplicado o Teste na Amostra da Variável: DESIBEL
 ---
  ```
        Shapiro-Wilk normality test

  data:  amostra_desibel
  W = 0.95074, p-value < 2.2e-16
  ```
  <br>


  * Aplicado o Teste na Amostra da Variável: FREQUENCIA
  ---

  ```
        Shapiro-Wilk normality test

  data:  amostra_frequencia
  W = 0.94346, p-value < 2.2e-16
  ```
  <br>
 

  * Aplicado o Teste na Amostra da Variável: DISTANCIA
  ---
  ```
        Shapiro-Wilk normality test

  data:  amostra_distancia
  W = 0.94712, p-value < 2.2e-166
  ```
  <br>

   * **Resultado:** Todas as amostras obteve o **valor p: < 2.2e-16** (ou seja, extremamente baixo). <br>
  A hipótese nula do teste é que a amostra segue uma distribuição normal.
  Como o valor p é muito menor que 0.05 (nível de significância comum), rejeitamos a hipótese nula.
  Portanto, com base nos resultados do teste, podemos concluir que as amostras **não seguem uma distribuição normal.**
  <br>
 
  * **Aplicação da Técnica de Normalização:** As variáveis Fluxo_de_ar, Desibel, Frequencia e Distancia não seguem uma distribuição normal. Portanto, vamos aplicar a transformação de raiz quadrada nas variáveis numéricas para tornar os dados mais uniformes. Na variável Fluxo_de_ar, temos valores como zero, que indicam zeros nos dados originais. Utilizaremos gráficos Q-Q para avaliar a normalidade; se os pontos estiverem alinhados com a linha diagonal, os dados podem ser considerados normalmente distribuídos. Desvios significativos dessa linha sugerem persistência de não normalidade. Vamos prosseguir com a análise para verificar a adequação da distribuição dos dados.

  <BR>

  Gráfico-16, **"Multi-Gráficos Normal QQ-Plot"**
 ![alt text](https://github.com/FernandaPavan/Previsao_Eficiencia_de_Extintor/assets/110939025/c56e2833-fc17-44b3-95e1-a46f15d4cadb)


    

  <BR>
  <BR>

  * **Distancia:** Os valores estão entre 3.162 e 13.784, com a mediana exatamente no meio do intervalo interquartil (10.000), sugerindo uma distribuição relativamente simétrica.<br>
  * **Desibel:** Com valores de 8.485 a 10.630, a média está muito próxima da mediana (9.808 vs 9.747), indicando uma distribuição quase simétrica.
  * **Fluxo_de_ar:** A variável tem valores de 0.000 a 4.123, e a média e a mediana são quase idênticas (2.399 vs 2.408), o que sugere uma distribuição simétrica.
  * **Frequencia:** Os valores vão de 1.000 a 8.660, e a média é praticamente igual à mediana (5.249 vs 5.244), indicando também uma distribuição simétrica.
  <br>
  <br>
  

   ### **5. Desenvolvimento do Projeto**
  ---
  ### ```5.1 Seleção de Variáveis Significativas para o Modelo. ``` 
  <br>

 A análise da importância das variáveis, exemplificada pelo modelo de **Random Forest** e pelo gráfico do ```varImpPlot```, é essencial na construção e interpretação de modelos estatísticos ou de aprendizado de máquina. Esse gráfico destaca as variáveis mais influentes nas previsões, facilitando a identificação das mais relevantes. Essa análise desempenha um papel fundamental na prevenção do overfitting, na otimização de recursos, na interpretação de resultados e no aprimoramento contínuo do modelo.
  <br>
  <br>
  <br>

  Gráfico-17, **"Importância das Variáveis"**
  ![alt text](https://github.com/FernandaPavan/Prevendo_Eficiencia_de_Extintores/blob/main/Plots/Grafico-17_varImp_plot.png)


  <br>

  * **MeanDecreaseAccuracy:** mede o impacto de cada variável na precisão geral do modelo. Quanto maior o valor mais importante a variável é para a precisão do modelo.<br>
  **20:** Baixa importância para a precisão.<br>
  **40:** Moderada importância para a precisão.<br>
  **60:** Importância considerável para a precisão.<br>
  **80:** Muito importante para a precisão.<br>
  <br>

  * **MeanDecreaseGini:** avalia como cada variável contribui para a pureza das divisões feitas pela árvore. Quanto maior o valor  mais importante a variável é para a separação eficaz das classes alvo.<br>
  **0:** Baixa importância para a pureza.<br>
  **1000:** Moderada importância para a pureza.<br>
  **2000:** Importância considerável para a pureza.<br>
  **3000:** Muito importante para a pureza.<br>
  **4000:** Extremamente importante para a pureza.<br>
  <br>

Neste caso, o modelo sugeriu apenas uma variável relevante: **‘Tamanho’** para o primeiro grupo, com base no critério **MeanDecreaseAccuracy**. No entanto, quando analisamos os gráficos de correlação entre as variáveis, notamos que as variáveis isoladas não correspondiam diretamente à extinção da chama. Isso ocorre porque elas sofrem interferência de outras variáveis. Para chegarmos à extinção da chama, é necessário considerar essas interações. Essa relação é evidenciada no segundo grupo de pureza, onde o critério **MeanDecreaseGini** também demonstra sua importância.

Ou seja, iremos construir o modelo base preditivo com todas as variáveis e, após avaliarmos seu desempenho, nos basearemos no segundo grupo para a retirada das variáveis menos relevantes.

  <br>

  ### ```5.2 Regressão Logística ```
  <br>

  A **regressão logística** é uma técnica estatística utilizada para prever uma variável categórica (binária ou com várias classes) com base em um conjunto de variáveis preditoras. Como exemplo, temos o Status da Chama, que pode ser representado como: 0 = não extinta ou 1 = extinta.

  Após concluir o processo de limpeza e tratamento dos dados, é fundamental dividir o conjunto de dados em treinamento e teste. A função ```createDataPartition``` do pacote Caret é frequentemente utilizada para realizar essa divisão. Neste caso, a proporção para essa divisão é **70%** para treinamento e **30%** para teste. Isso nos permitirá construir e avaliar o modelo de **machine learning.**

  <br>

  #### **TREINAMENTO E TESTE DE MODELOS: SVM | RANDOM FOREST | KNN.**
  ---
  <br>

  **Classificação com Support Vector Machines (SVM):**  é um conjunto de métodos de aprendizado supervisionado que será utilizado para classificação. O SVM encontra uma linha de separação (ou hiperplano) entre dados pertencentes a duas classes diferentes, mesmo quando os dados não têm uma separação linear clara. 
  <br>

  Modelo 1: Treino | Teste | Matriz de Confusão.

 ```fit1 <- train(Status ~., data = dados_treino, method = "svmRadial")```

 ```predicoes.svm <- predict(fit1, dados_teste)```

 ```confusionMatrix(predicoes.svm, dados_teste$Status)```


  ---

  ```
 Confusion Matrix and Statistics

          Reference
Prediction    0    1
         0 2489  172
         1  138 2432
                                        
               Accuracy : 0.9407        
                 95% CI : (0.934, 0.947)
    No Information Rate : 0.5022        
    P-Value [Acc > NIR] : < 2e-16       
                                        
                  Kappa : 0.8815        
                                        
 Mcnemar's Test P-Value : 0.06089       
                                        
            Sensitivity : 0.9475        
            Specificity : 0.9339        
         Pos Pred Value : 0.9354        
         Neg Pred Value : 0.9463        
             Prevalence : 0.5022        
         Detection Rate : 0.4758        
   Detection Prevalence : 0.5087        
      Balanced Accuracy : 0.9407        
                                        
       'Positive' Class : 0 
  ```
  <br>
  <br>

  Gráfico-18, **"Relação entre Custo e Acurácia - SVM "**
  ![alt text](https://github.com/FernandaPavan/Prevendo_Eficiencia_de_Extintores/blob/main/Plots/Grafico-18_acuracia_fit1.png)


  <br>
  O modelo SVM obteve uma excelente performance com uma acurácia de 0.94. Isso significa que ele acertou 94% das previsões. A matriz de confusão revela que:

  <br>

  **Classe Não Extinta (0):** Foi prevista 2489 vezes e o modelo errou 172 vezes.<br>
  **Classe Extinta (1):** O modelo errou 138 vezes, e acertou 2432 vezes.<br>
  

  <br>
  <br>

  ---
  <br>

  **Classificação com Random Forest:** é um algoritmo popular de aprendizado de máquina supervisionado que combina as saídas de vários modelos de árvores de decisão para chegar a um único resultado. Ele segue uma abordagem de conjunto (ensemble), o que significa que combina previsões de vários modelos menores, sendo cada um desses modelos menores uma árvore de decisão. O Random Forest contabiliza o número de previsões de cada classe (0 e 1) e escolhe a mais popular.
  <br>

  Modelo 2: Treino | Teste | Matriz de Confusão.

  ```fit2 <- train(Status ~., data = dados_treino, method = "rf")```

  ```predicoes.rf <- predict(fit2,dados_teste)```

  ```confusionMatrix(predicoes.rf, dados_teste$Status)```

  ---

  ```
  Confusion Matrix and Statistics

          Reference
Prediction    0    1
         0 2551   85
         1   76 2519
                                          
               Accuracy : 0.9692          
                 95% CI : (0.9642, 0.9737)
    No Information Rate : 0.5022          
    P-Value [Acc > NIR] : <2e-16          
                                          
                  Kappa : 0.9384          
                                          
 Mcnemar's Test P-Value : 0.5284          
                                          
            Sensitivity : 0.9711          
            Specificity : 0.9674          
         Pos Pred Value : 0.9678          
         Neg Pred Value : 0.9707          
             Prevalence : 0.5022          
         Detection Rate : 0.4877          
   Detection Prevalence : 0.5039          
      Balanced Accuracy : 0.9692          
                                          
       'Positive' Class : 0
  ```
  <br>
  <br>

  Gráfico-19, **"Relação da Acurácia - Random Forest "**
  ![alt text](https://github.com/FernandaPavan/Prevendo_Eficiencia_de_Extintores/blob/main/Plots/Grafico-19_acuracia_fit2.png)

  <br>
  O modelo RF obteve uma excelente performance com uma acurácia de 0.97. Isso significa que ele acertou 97% das previsões. A matriz de confusão revela que:

  <br>

  **Classe Não Extinta (0):** Foi prevista 2551 vezes e o modelo errou 85 vezes.<br>
  **Classe Extinta (1):** O modelo errou 76 vezes, e acertou 2519 vezes.<br>


  <br>
  <br>

    ---
  <br>

  **Classificação com KNN:** ou K-vizinhos mais próximos, é um algoritmo de aprendizado de máquina supervisionado utilizado para classificação e regressão. A classe do ponto de dados de teste é determinada pela classe mais frequente entre seus K vizinhos mais próximos.
  <br>

  Modelo 3: Treino | Teste | Matriz de Confusão.

  ```fit3 <- train(Status ~., data = dados_treino, method = "knn")```

  ```predicoes.knn <- predict(fit3,dados_teste)```

  ```confusionMatrix(predicoes.knn, dados_teste$Status)```

  ---

  ```
  CConfusion Matrix and Statistics

          Reference
Prediction    0    1
         0 2533   83
         1   94 2521
                                          
               Accuracy : 0.9662          
                 95% CI : (0.9609, 0.9709)
    No Information Rate : 0.5022          
    P-Value [Acc > NIR] : <2e-16          
                                          
                  Kappa : 0.9323          
                                          
 Mcnemar's Test P-Value : 0.4523          
                                          
            Sensitivity : 0.9642          
            Specificity : 0.9681          
         Pos Pred Value : 0.9683          
         Neg Pred Value : 0.9641          
             Prevalence : 0.5022          
         Detection Rate : 0.4842          
   Detection Prevalence : 0.5001          
      Balanced Accuracy : 0.9662          
                                          
       'Positive' Class : 0 
  ```
  <br>
  <br>

  Gráfico-20, **"Relação da Acurácia - KNN "**
  ![alt text](https://github.com/FernandaPavan/Prevendo_Eficiencia_de_Extintores/blob/main/Plots/Grafico-20_acuracia_fit3.png)

  <br>
  O modelo KNN obteve uma excelente performance com uma acurácia de 0.96. Isso significa que ele acertou 96% das previsões. A matriz de confusão revela que:

  <br>

  **Classe Não Extinta (0):** Foi prevista 2533 vezes e o modelo errou 83 vezes.<br>
  **Classe Extinta (1):** O modelo errou 94 vezes, e acertou 2521 vezes.<br>


  <br>
  <br>
  

   ### **6. Conclusão do Projeto**

  Após análise, chegamos à conclusão de que o Random Forest é o algoritmo mais adequado para este conjunto de dados. Ele demonstrou uma capacidade para explicar 97% da variância nos dados de teste, com uma taxa de erro menor, especialmente na previsão da classe “Extinta”. Portanto, recomendamos o uso do Random Forest como a versão final do modelo.
   
  <br>
  <br>
  <br>

---

  ### **7. Referências Bibliográficas**
 
 Pavan, Fernanda. (2024). **Previsão de Eficiência de Extintor de Incêndio.** Conclusão Acadêmica da Formação de Cientista de Dados. Data Science Academy, São Paulo, Brasil. Desenvolvido sob Mentoria dos Profissionais da Instituição. 

 Clique aqui para visitar a [Data Science Academy:](https://www.datascienceacademy.com.br)

 <br>
 <br>

  

  
  KOKLU M., TASPINAR YS, (2021). Determinando o status de extinção de chamas de combustível com ondas sonoras por métodos de aprendizado de máquina. Acesso IEEE, 9, pp.86207-86216, Doi: 10.1109/ACCESS.2021.3088612

  Clique aqui para baixar o conjunto de dados [Acoustic Extinguisher Fire Dataset:](https://ieee-dataport.org/documents/acoustic-extinguisher-fire-dataset)

