#!/usr/bin/env bash
set -euo pipefail

CONSUL_NS="consul"

echo "[1/6] Vérification du contexte Kubernetes"
kubectl config current-context

echo "[2/6] Ajout du repo Helm HashiCorp"
helm repo add hashicorp https://helm.releases.hashicorp.com >/dev/null 2>&1 || true
helm repo update >/dev/null

echo "[3/6] Création du namespace Consul (si absent)"
kubectl get namespace ${CONSUL_NS} >/dev/null 2>&1 || kubectl create namespace ${CONSUL_NS}

echo "[4/6] Installation de Consul (Connect + SyncCatalog + UI)"
helm upgrade --install consul hashicorp/consul \
  --namespace ${CONSUL_NS} \
  --set global.name=consul \
  --set global.datacenter=dc1 \
  --set server.replicas=1 \
  --set ui.enabled=true \
  --set connectInject.enabled=true \
  --set syncCatalog.enabled=true\
  --set global.tls.enabled=true \
  --set global.tls.enableAutoEncrypt=true \
  --reuse-values

echo "[5/6] Attente que Consul soit prêt"
kubectl -n ${CONSUL_NS} rollout status statefulset/consul-server --timeout=180s
kubectl -n ${CONSUL_NS} get pods
echo "[6/6] FA24 — Intentions Consul (deny by default + allow strict minimum)"

# deny all (ok si déjà présent)
kubectl -n ${CONSUL_NS} exec -it statefulset/consul-server -- \
  consul intention create -deny '*' '*' || true

# allow strict minimum (doit réussir, sinon on veut voir l'erreur)
kubectl -n ${CONSUL_NS} exec -it statefulset/consul-server -- \
  consul intention create -allow frontend-service-default api-gateway-service-default

kubectl -n ${CONSUL_NS} exec -it statefulset/consul-server -- \
  consul intention create -allow api-gateway-service-default logic-api-service-default

kubectl -n ${CONSUL_NS} exec -it statefulset/consul-server -- \
  consul intention create -allow api-gateway-service-default feedback-api-service-default


echo ""
echo "✔ Consul installé avec Service Mesh, Service Discovery, Observabilité et Intentions"
echo "UI Consul : kubectl -n consul port-forward svc/consul-ui 8500:443"
echo "Lister les intentions : kubectl -n consul exec -it statefulset/consul-server -- consul intention list"
