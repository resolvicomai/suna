# Guia de Deploy do Projeto Suna no Railway (Versão Híbrida - A Mais Segura)

Olá! Após alguns problemas, chegamos a uma solução mais robusta que tem a maior chance de sucesso.

**O que vamos fazer:**
Usaremos o arquivo `railway.json` para criar automaticamente os serviços principais (Backend, Worker, Frontend). Os serviços de apoio (Redis e RabbitMQ) serão adicionados manualmente, pois isso evita um bug na plataforma Railway que parece estar ignorando a configuração completa.

---

### **Passo 1: Faça o Commit e Push**

Certifique-se de que as últimas alterações neste repositório foram enviadas para o seu GitHub.

---

### **Passo 2: Crie um Projeto NOVO no Railway (Importante!)**

1.  **DELETE o projeto antigo** no Railway para evitar qualquer conflito.
2.  Acesse sua conta no [Railway](https://railway.app/).
3.  Na tela principal, clique em **New Project**.
4.  Escolha a opção **Deploy from GitHub repo**.
5.  Selecione o repositório do seu projeto Suna.
6.  O Railway irá ler o `railway.json` e criar automaticamente os 3 serviços: `backend`, `worker`, e `frontend`.

---

### **Passo 3: Adicione o Redis e o RabbitMQ Manualmente**

Agora que os serviços principais existem, vamos adicionar os de apoio:

1.  No painel do seu projeto, clique no botão **+ New**.
2.  Na caixa de busca, digite **Redis** e adicione-o.
3.  Clique em **+ New** novamente, procure por **RabbitMQ** e adicione-o.

Ao final, você terá os 5 serviços no seu painel.

---

### **Passo 4: Configure as Variáveis de Ambiente**

Esta parte continua sendo manual e é crucial.

1.  Clique no serviço `backend` e vá para a aba **Variables**.
2.  **Conecte o Redis e o RabbitMQ**:
    -   Crie uma nova variável chamada `REDIS_URL`. No campo de valor, clique no ícone de referência e selecione a variável do serviço Redis (ex: `${{Redis.REDIS_URL}}`).
    -   Crie uma nova variável `RABBITMQ_URL` e referencie a variável do serviço RabbitMQ (ex: `${{RabbitMQ.AMQP_URL}}`).
3.  **Adicione as outras variáveis**: Copie todas as outras chaves e segredos do arquivo `backend/.env.example` para as variáveis do serviço `backend`.
4.  **Repita para o `worker`**: Vá para o serviço `worker` e adicione exatamente as mesmas variáveis que você configurou no `backend`.
5.  **Configure o `frontend`**:
    -   Vá para o serviço `frontend` -> **Variables**.
    -   Crie a variável `NEXT_PUBLIC_API_URL`.
    -   Para obter o valor, vá para o serviço `backend` -> **Settings** -> clique em **Generate Domain**. Copie a URL gerada.
    -   Cole a URL no valor da variável `NEXT_PUBLIC_API_URL` no serviço `frontend`.
    -   Adicione as outras variáveis do `frontend/.env.example`.

---

### **Passo 5: Acesse sua Aplicação**

Vá para a aba **Settings** do serviço `frontend` e, se ainda não houver um domínio, clique em **Generate Domain**. Esta é a URL pública do seu site.

Este método é a forma mais segura de garantir que o Railway construa seus serviços a partir dos `Dockerfile`s corretamente, contornando o erro do Nixpacks.
