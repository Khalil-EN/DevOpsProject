# Description de la remise

### Nom complet: XXXXX

### NIP: 111 111 111

### Liste des codes et descriptions des fonctionnalités sélectionnées:

Exemple:

- (FA2) Intégration du Service Mesh Consul-Connect ==> 5%
- (FA21) Intégration de la fonctionnalité de Service Discovery de Consul-Connect ==> 5%
- (FA22) Observabilité des services et de leurs états (healthcheck) au travers du UI de Consul ==> 5%
- (FA23) Définition d'Intentions limitant la communication entre les services au strict nécessaire ==> 10%
- (FA24) Configuration de Canary Deployment et/ou Blue-green/A-B Deployment ==> 10%

### Directives nécessaires à la correction

XXXXX

1- Création du cluster Kubernetes avec kind : kind create cluster --config cluster.yaml
2- Déploiement des services de l’application : kubectl apply -f submission/
3- Installation de l’Ingress Controller NGINX (spécifique à kind) : kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
4- Accès à l’application (frontend) : kubectl -n ingress-nginx port-forward svc/ingress-nginx-controller 8080:80
5- Puis ouvrir dans un navigateur : http://localhost:8080

### fonctionnalités avancees - Consul

6- Installation de Consul (Service Mesh, Service Discovery et Observabilité) :
a- helm repo add hashicorp https://helm.releases.hashicorp.com
b- helm repo update

    c- kubectl create namespace consul

    d- helm install consul hashicorp/consul \
    --namespace consul \
    --set ui.enabled=true \
    --set connectInject.enabled=true \
    --set syncCatalog.enabled=true

7- Accès à l’interface UI de Consul (observabilité) : kubectl -n consul port-forward svc/consul-ui 8500:80
8- Puis ouvrir : http://localhost:8500

### Commentaires généraux:

XXXXX
