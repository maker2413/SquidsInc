#!/bin/bash

set -e

echo "Creating ArgoCD manager service account..."
kubectl create serviceaccount argocd-manager -n kube-system

echo "Creating cluster role binding..."
kubectl create clusterrolebinding argocd-manager-binding \
  --clusterrole=cluster-admin \
  --serviceaccount=kube-system:argocd-manager

echo "Creating service account token secret..."
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: argocd-manager-token
  namespace: kube-system
  annotations:
    kubernetes.io/service-account.name: argocd-manager
type: kubernetes.io/service-account-token
EOF

echo "Waiting for token to be populated..."
sleep 2

echo ""
echo "Bearer Token:"
kubectl get secret argocd-manager-token -n kube-system -o jsonpath='{.data.token}' | base64 -d
echo ""
echo ""
echo "CA Data:"
kubectl config view --raw --minify --flatten -o jsonpath='{.clusters[0].cluster.certificate-authority-data}'
echo ""
