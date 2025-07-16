# Guia de Deploy do Projeto Suna no Railway (Versão Automatizada)

Olá! Com o novo arquivo `railway.json` adicionado ao projeto, o processo de deploy se tornou muito mais simples. Agora, o Railway irá configurar quase tudo automaticamente.

**O que o arquivo `railway.json` faz?**
Ele instrui o Railway a criar e configurar todos os 5 serviços necessários (Redis, RabbitMQ, Backend, Worker e Frontend) sem que você precise fazer isso manualmente.

---

### **Processo de Deploy (Agora Simplificado)**

**Passo 1: Faça o Commit e Push**

Certifique-se de que os novos arquivos (`railway.json` e este guia atualizado) sejam enviados para o seu repositório no GitHub.

```bash
git add railway.json RAILWAY_DEPLOYMENT_GUIDE.md
git commit -m "Adicionar configuração de deploy automatizado para o Railway"
git push
```

**Passo 2: Crie o Projeto no Railway**

1.  Acesse sua conta no [Railway](https://railway.app/).
2.  Na tela principal, clique em **New Project**.
3.  Escolha a opção **Deploy from GitHub repo**.
4.  Selecione o repositório do seu projeto Suna.
5.  **Mágica!** O Railway encontrará e lerá o arquivo `railway.json`. Ele começará a criar todos os 5 serviços automaticamente. Aguarde alguns minutos enquanto ele constrói e implanta tudo.

---

### **Passo 3: Configure as Variáveis de Ambiente (Única Tarefa Manual)**

Esta é a **única parte** que você precisa fazer manualmente, pois envolve segredos e chaves de API que não devem estar no código.

1.  No seu painel do Railway, você verá os 5 serviços criados. Clique em cada um deles (`backend`, `worker`, `frontend`) e vá para a aba **Variables**.
2.  **Para o `backend` e `worker`:**
    -   O Railway já terá conectado o Redis e o RabbitMQ.
    -   Você precisa adicionar as outras variáveis que estão no arquivo `backend/.env.example`. Para cada linha como `NOME=valor` nesse arquivo, crie uma nova variável no Railway com o `NOME` e o `valor` correspondente.
3.  **Para o `frontend`:**
    -   Crie uma variável chamada `NEXT_PUBLIC_API_URL`. O valor dela será o endereço do seu backend. O Railway cria essa variável para você. Clique no campo de valor e selecione a variável que se parece com `${{backend.RAILWAY_PRIVATE_DOMAIN}}` ou `${{backend.RAILWAY_PUBLIC_DOMAIN}}`.
    -   Adicione as outras variáveis que estão no arquivo `frontend/.env.example`.

---

### **Passo 4: Acesse sua Aplicação**

Para tornar seu site público, vá para a aba **Settings** do serviço `frontend` e clique em **Generate Domain**. A URL gerada será o endereço público do seu site.

É isso! O processo agora é 90% automático.

---

### **Solução de Problemas (IMPORTANTE!)**

**Erro: "Nixpacks build failed"**

Se você vir este erro, significa que o Railway **NÃO** leu o arquivo `railway.json`. Isso quase sempre acontece porque você está tentando reimplantar um projeto antigo.

**Solução:**
1.  **Delete completamente o projeto antigo** no painel do Railway.
2.  Siga o "Passo 2" deste guia novamente e **crie um projeto totalmente novo** a partir do seu repositório do GitHub.

Um novo projeto forçará o Railway a escanear o repositório do zero, encontrar o `railway.json` e configurar tudo corretamente.
