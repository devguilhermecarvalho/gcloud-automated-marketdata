#!/bin/bash

# Criando Conta de Serviço:
gcloud iam service-accounts create data-engineer-administrator \
    --description="Usuário administrador geral" \
    --display-name="Data Engineer - Administrator" 

# Lista Contas de Serviço:
gcloud iam service-accounts list --project=project-automated-data-market

# Como executar o arquivo no GCloud CMD:
# 1. Navegue até o diretório:
#    > chmod +x assign_roles.sh
# 2. Execute o script:
#    > ./assign_roles.sh

# Substitua USER_EMAIL pelo e-mail da conta de serviço e PROJECT_ID pelo ID do seu projeto
USER_EMAIL="data-engineer-administrator@project-automated-data-market.iam.gserviceaccount.com"
PROJECT_ID="project-automated-data-market"
REGION="us-central1"
FUNCTION_NAME="project-data-market"

# Adiciona a função de Administrador do Cloud Functions
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$USER_EMAIL" \
  --role="roles/cloudfunctions.admin"

# Adiciona a função de Administrador do Storage
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$USER_EMAIL" \
  --role="roles/storage.admin"

# Adiciona a função de Administrador do BigQuery
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$USER_EMAIL" \
  --role="roles/bigquery.admin"

# Adiciona a função de Editor do Cloud Build
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$USER_EMAIL" \
  --role="roles/cloudbuild.builds.editor"

# Adiciona a função de Administrador do Cloud Scheduler
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$USER_EMAIL" \
  --role="roles/cloudscheduler.admin"

# Adiciona a função de Administrador do Compute Engine
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$USER_EMAIL" \
  --role="roles/compute.admin"

# Adiciona a função de Visualizador de Objetos do Storage
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$USER_EMAIL" \
  --role="roles/storage.objectViewer"

# Adiciona a função de Get de Objetos do Storage
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$USER_EMAIL" \
  --role="roles/storage.objects.get"

# Adiciona a permissão de invocação à função Cloud Functions
gcloud functions add-iam-policy-binding $FUNCTION_NAME \
    --regions=$REGION \
    --member="serviceAccount:$USER_EMAIL" \
    --role="roles/cloudfunctions.invoker"

# Adiciona a função de Invoker do Cloud Run
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$USER_EMAIL" \
  --role="roles/run.invoker"

# Lista as funções na região especificada
gcloud functions list --project=$PROJECT_ID --regions=$REGION

# Adiciona permissão de invocação à função se existir
if gcloud functions describe $FUNCTION_NAME --project=$PROJECT_ID --regions=$REGION; then
    gcloud functions add-iam-policy-binding $FUNCTION_NAME \
        --regions=$REGION \
        --member="serviceAccount:$USER_EMAIL" \
        --role="roles/cloudfunctions.invoker"
else
    echo "Função $FUNCTION_NAME não encontrada na região $REGION."
    exit 1