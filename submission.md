# Description de la remise

### Nom complet: XXXXX

### NIP: 111 111 111

### Liste des codes et descriptions des fonctionnalités sélectionnées:

- (FA1) Sécuriser et encrypter les communications au travers de certificats SSL ==> 10%
- (FA2) Intégration du Service Mesh Consul-Connect ==> 5%
- (FA21) Intégration de la fonctionnalité de Service Discovery de Consul-Connect ==> 5%
- (FA22) Observabilité des services et de leurs états (healthcheck) au travers du UI de Consul ==> 5%
- (FA23) Définition d'Intentions limitant la communication entre les services au strict nécessaire ==> 10%
- (FA24) Définition d’Intentions limitant la communication entre les services au strict minimum ==> 10%

### Directives nécessaires à la correction

1- Création du cluster Kubernetes avec kind : kind create cluster --config cluster.yaml
2- Génération de la clé privée et du certificat SSL : - openssl genrsa -out ingress-cert.key 2048 - openssl req -new -x509 -key logic-api.key -out ingress-cert.crt -days 365
3- Création du secret TLS pour sécuriser les communications HTTPS :
-kubectl create secret tls ingress-tls --cert=ingress-cert.crt --key=ingress-cert.key -n default
4- Initialisation de Consul : exécution du script consul-install.sh situé à la racine du projet afin d’installer Consul (Service Mesh, intentions, UI, etc.).
5- Installation de l’Ingress Controller NGINX (spécifique à kind) : kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
6- Déploiement des services de l’application : kubectl apply -f submission/
7- Accès à l’application (frontend) : kubectl -n ingress-nginx port-forward svc/ingress-nginx-controller 8080:443
8- Puis ouvrir dans un navigateur : https://localhost:8080 : le certificat étant auto-signé, une alerte de sécurité peut apparaître dans le navigateur. Il suffit de l’accepter pour continuer.

### Fonctionnalités avancées - Consul

Le script ./consul-install.sh:

- installe Consul via Helm,
- active Consul Connect (Service Mesh),
- active syncCatalog (Service Discovery),
- configure les Intentions pour restreindre les communications inter-services.

9- Accès à l’interface UI de Consul (observabilité) : kubectl -n consul port-forward svc/consul-ui 8500:443
10- Puis ouvrir : https://localhost:8500

### Commentaires généraux:

- L’image Docker utilisée pour l’api-gateway a été modifiée pour utiliser : eclipse-temurin:8-jre-alpine
- Des dépendances supplémentaires ont été ajoutées dans le fichier requirements.txt du logic-api afin de supporter le traitement NLP (TextBlob / NLTK).
- Une étape spécifique a été ajoutée dans le Dockerfile du logic-api : RUN python3 -m nltk.downloader punkt_tab -d /usr/local/share/nltk_data pour guarantir que les ressources NLTK nécessaires sont disponibles au runtime.
- L’environnement repose entièrement sur kind, aucun outil externe n’est requis sur la machine du correcteur.
- Toutes les fonctionnalités avancées liées à Consul sont reproductibles via un seul script (consul-install.sh).
- Les communications inter-services sont sécurisées et limitées explicitement à l’aide des Intentions Consul.
