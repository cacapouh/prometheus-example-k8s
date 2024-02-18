minikube delete --all
minikube start --memory=4096  # メモリのデフォルト値は2GBで気持ちやや少なめなので、4GBで起動

minikube image build -t simple-app:latest .

# Prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
kubectl create ns monitoring
helm upgrade -i prometheus prometheus-community/kube-prometheus-stack \
--namespace monitoring \
--set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false \
--set fullnameOverride=prometheus
kubectl wait --for=condition=Ready pod --all --all-namespaces --timeout=-1s
kubectl apply -f service-monitor.yaml

## simple-app
kubectl apply -f simple-app.yaml
kubectl wait --for=condition=Ready pod --all --all-namespaces --timeout=-1s

minikube service simple-app --url &
minikube service prometheus-prometheus -n monitoring --url &
