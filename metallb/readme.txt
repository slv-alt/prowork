# MetalLB
helm repo add metallb https://metallb.github.io/metallb
helm install metallb metallb/metallb --namespace metallb-system --create-namespace
sleep 60
kubectl apply -f metallb-pool.yaml
