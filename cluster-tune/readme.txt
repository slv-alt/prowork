Информация о нодах, выводы команд:
kubectl get node -o wide --show-labels
kubectl get nodes -o custom-columns=NAME:.metadata.name,TAINTS:.spec.taints