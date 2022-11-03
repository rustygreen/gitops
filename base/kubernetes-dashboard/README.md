# Kubernetes Dashboard

TODO

```yaml
kubectl get secret -n kubernetes-dashboard ${SECRET_NAME} -o 'jsonpath={.data.token}' | base64 --decode
```