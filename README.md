# gitops

flux bootstrap github --owner=rustygreen --repository=homelab --branch=main --path=./cluster --personal --components=source-controller,kustomize-controller,helm-controller,notification-controller --components-extra=image-reflector-controller,image-automation-controller
