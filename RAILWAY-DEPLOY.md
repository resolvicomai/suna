#  Suna Railway Deployment Guide

Este guia fornece instruções específicas para deployar Suna no Railway com arquitetura multi-serviços.

##  Pré-requisitos

- [ ] Conta no Railway (railway.app)
- [ ] Railway CLI instalado: `npm install -g @railway/cli`
- [ ] Projeto Supabase configurado
- [ ] Chaves de API necessárias (Anthropic, Daytona, etc.)

## ️ Arquitetura no Railway

Suna será deployado como **3 serviços separados**:

1. **Backend Service** - API FastAPI (Python)
2. **Frontend Service** - Interface Next.js (React)  
3. **Redis Database** - Cache e sessões
4. **Worker Service** - Processamento background

##  Configuração Passo a Passo

### 1. Clone e Prepare o Repositório

```bash
git clone https://github.com/resolvicomai/suna.git
cd suna
```

### 2. Login no Railway

```bash
railway login
```

### 3. Crie um Novo Projeto

```bash
railway new suna-production
railway link
```

### 4. Deploy Backend Service

```bash
# Navegue para backend
cd backend

# Crie o serviço backend
railway up --service backend

# Configure variáveis de ambiente
railway variables set NODE_ENV=production --service backend
railway variables set PYTHONUNBUFFERED=1 --service backend
railway variables set PORT=8000 --service backend
railway variables set SUPABASE_URL=<sua-url-supabase> --service backend
railway variables set SUPABASE_SERVICE_ROLE_KEY=<sua-chave> --service backend
railway variables set ANTHROPIC_API_KEY=<sua-chave-anthropic> --service backend
```

### 5. Adicione Redis Database

```bash
# Volte ao diretório raiz
cd ..

# Adicione Redis
railway add redis --service redis

# Conecte Redis ao backend
railway variables set REDIS_URL=${{redis.REDIS_URL}} --service backend
```

### 6. Deploy Frontend Service

```bash
# Navegue para frontend
cd frontend

# Crie o serviço frontend
railway up --service frontend

# Configure variáveis de ambiente
railway variables set NODE_ENV=production --service frontend
railway variables set PORT=3000 --service frontend
railway variables set NEXT_TELEMETRY_DISABLED=1 --service frontend
railway variables set NEXT_PUBLIC_SUPABASE_URL=<sua-url-supabase> --service frontend
railway variables set NEXT_PUBLIC_SUPABASE_ANON_KEY=<sua-chave-anon> --service frontend
railway variables set NEXT_PUBLIC_BACKEND_URL=${{backend.url}}/api --service frontend
```
### 7. Deploy Worker Service

```bash
# Volte ao diretório backend
cd ../backend

# Crie worker service
railway up --service worker

# Configure comando específico para worker
railway config --service worker
# No dashboard, altere o comando para: python -m dramatiq run_agent_background

# Configure mesmas variáveis do backend
railway variables set REDIS_URL=${{redis.REDIS_URL}} --service worker
railway variables set SUPABASE_URL=<sua-url-supabase> --service worker
railway variables set SUPABASE_SERVICE_ROLE_KEY=<sua-chave> --service worker
railway variables set ANTHROPIC_API_KEY=<sua-chave-anthropic> --service worker
```

### 8. Gere Domínios Públicos

1. Acesse o dashboard do Railway
2. Para cada serviço (backend/frontend):
   - Vá em Settings → Networking
   - Clique em "Generate Domain"
   - Copie as URLs geradas

### 9. Atualize URLs de Conexão

```bash
# Atualize URL do backend no frontend
railway variables set NEXT_PUBLIC_BACKEND_URL=<backend-domain>/api --service frontend
```

##  Verificação de Deploy

### Health Checks

- **Backend**: `https://<backend-domain>/api/health`
- **Frontend**: `https://<frontend-domain>`

### Logs dos Serviços

```bash
# Backend logs
railway logs --service backend

# Frontend logs  
railway logs --service frontend

# Worker logs
railway logs --service worker

# Redis logs
railway logs --service redis
```

##  Troubleshooting

### Problemas Comuns

1. **Erro de Build Context**
   - Certifique-se de estar no diretório correto ao fazer deploy
   - Backend: `cd backend && railway up`
   - Frontend: `cd frontend && railway up`

2. **Conexão Redis Falha**
   - Verifique se `REDIS_URL` está configurado
   - Use: `${{redis.REDIS_URL}}` (Railway auto-popula)

3. **Frontend não conecta ao Backend**
   - Verifique `NEXT_PUBLIC_BACKEND_URL`
   - Deve ser: `https://<backend-domain>/api`

4. **Worker não processa jobs**
   - Verifique logs: `railway logs --service worker`
   - Confirme variáveis Redis e Supabase

### Comandos de Debug

```bash
# Status dos serviços
railway status

# Variáveis de ambiente
railway variables --service <service-name>

# Redeploy específico
railway redeploy --service <service-name>
```

##  Configurações Avançadas

### Scaling

```bash
# Scale worker para múltiplas instâncias
railway scale worker --replicas 3
```

### Monitoramento

- Use Railway dashboard para métricas
- Configure alertas para usage/errors
- Monitor logs em tempo real

### Backup

- Dados Supabase: configure backup automático
- Redis: dados são cache, não necessita backup
- Código: sempre mantido no Git

##  Recursos Adicionais

- [Railway Documentation](https://docs.railway.app)
- [Suna Self-Hosting Guide](./SELF-HOSTING.md)
- [Railway CLI Reference](https://docs.railway.app/cli)

---

**✅ Deploy Concluído!**

Sua instância Suna está agora rodando no Railway com arquitetura escalável e monitorada.