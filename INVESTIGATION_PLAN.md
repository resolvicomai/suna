# Plano de Investigação: Deploy do Suna no Railway

Este documento descreve o plano de ação para diagnosticar e resolver os erros de deploy do projeto Suna no Railway.

## Objetivo

Fazer o deploy bem-sucedido da aplicação Suna (backend, frontend, worker e Redis) no ambiente do Railway, garantindo que todos os serviços se comuniquem corretamente e a aplicação funcione como esperado.

## Fases da Investigação

### Fase 1: Análise do Ambiente e Configuração Atual (Concluída)

1.  **Revisão dos Arquivos de Deploy: [X]**
    *   Analisado `RAILWAY-DEPLOY.md` e `deploy-railway.sh`.
    *   Analisado `docker-compose.railway.yml`.
    *   Analisado os `Dockerfile`s do `backend` e `frontend`.

2.  **Coleta de Informações de Erro:**
    *   Solicitar ao usuário os logs de erro específicos do build ou do runtime que aparecem no dashboard do Railway. Sem os erros exatos, a análise fica limitada.

3.  **Verificação das Variáveis de Ambiente:**
    *   Confirmar se todas as variáveis de ambiente listadas no `.env.example` e no `RAILWAY-DEPLOY.md` estão sendo consideradas e se o usuário tem as chaves necessárias (Supabase, Anthropic, etc.).

### Fase 2: Simulação e Diagnóstico

1.  **Execução do Script de Deploy (Sugerido):**
    *   Com base na análise, sugerir a execução passo a passo do script `deploy-railway.sh` ou dos comandos do `RAILWAY-DEPLOY.md`.

2.  **Análise dos Logs em Tempo Real:**
    *   Acompanhar os logs de cada serviço (`backend`, `frontend`, `worker`) durante o processo de deploy usando os comandos `railway logs --service <nome-do-serviço>`.

3.  **Isolamento do Problema:**
    *   Identificar qual serviço está falhando (build, start, conexão com banco de dados, etc.) e focar a investigação nesse ponto.

### Fase 3: Proposta e Implementação da Solução (Em Andamento)

1.  **Desenvolvimento de um Plano de Correção: [X]**
    *   Plano de correção definido com foco no `Dockerfile` do frontend e no `docker-compose.railway.yml`.

2.  **Aplicação das Correções: [X]**
    *   `frontend/Dockerfile` atualizado para usar `node:20-alpine`, garantir a instalação de todas as dependências e adicionar um comando `CMD`.
    *   `docker-compose.railway.yml` atualizado para remover o `healthcheck` do frontend.

3.  **Novo Deploy e Verificação:**
    *   Realizar um novo deploy com as correções aplicadas.
    *   Verificar os health checks e a funcionalidade da aplicação para confirmar que o problema foi resolvido.

## Próximos Passos

*   Aguardando os logs de erro do Railway para iniciar a Fase 1.