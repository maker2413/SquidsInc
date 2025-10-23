#!/bin/bash

set -e

echo "Deleting service account token secret..."
kubectl delete secret argocd-manager-token -n kube-system

echo "Deleting cluster role binding..."
kubectl delete clusterrolebinding argocd-manager-binding

echo "Deleting ArgoCD manager service account..."
kubectl delete serviceaccount argocd-manager -n kube-system
