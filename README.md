## Descrição do Projeto

Este projeto consiste no desenvolvimento de uma ferramenta que simula o funcionamento do **escalonamento de processos**, utilizando o algoritmo **Round Robin**.

A aplicação permite ao usuário configurar parâmetros como uso de CPU, operações de disco (E/S), número de processos e tempo de execução, possibilitando a visualização do comportamento da CPU ao longo do tempo.

## Formas de Execução

O projeto foi disponibilizado em duas versões para facilitar a execução em diferentes sistemas operacionais:

### 🐧 **Versão Linux**

📁 Pasta: `Simulador_RoundRobin_Linux`

#### Como executar:

1. Abra o terminal na pasta:

   ```bash
   cd Simulador_RoundRobin_Linux
   ```

2. Conceda permissão de execução (se necessário):

   ```bash
   chmod +x roundrobin
   ```

3. Execute o programa:

   ```bash
   ./roundrobin
   ```

### **Versão Windows**

📁 Pasta: `Simulador_RoundRobin_Windows`

#### Como executar:

1. Acesse a pasta:

   ```
   Simulador_RoundRobin_Windows
   ```

2. Execute o arquivo:

   ```
   roundrobin.exe
   ```

> ⚠️ **Importante:**
> Não remover arquivos da pasta, pois o executável depende das bibliotecas incluídas.

## ⚙️ Funcionalidades

- Criação e gerenciamento de processos
- Configuração de:
  - Tempo de CPU
  - Tempo de disco (E/S)
  - Número de rodadas
  - Quantum
  - Tempo total da simulação

- Execução do algoritmo Round Robin
- Visualização da linha do tempo da CPU
- Cálculo de:
  - Uso da CPU (%)
  - Tempo médio de espera

## Objetivo

O objetivo é proporcionar uma ferramenta didática para auxiliar na compreensão do funcionamento de algoritmos de escalonamento de processos em sistemas operacionais.

## Tecnologias Utilizadas

- Flutter
- Dart

## Autor

João Victor Ferreira da Silva
