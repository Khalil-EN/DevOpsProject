helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update

kubectl create namespace consul

helm install consul hashicorp/consul \
  --namespace consul \
  --set ui.enabled=true \
  --set connectInject.enabled=true \
  --set syncCatalog.enabled=true
