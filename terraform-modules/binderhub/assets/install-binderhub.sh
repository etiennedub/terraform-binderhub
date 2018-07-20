#!/bin/bash
for f in /tmp/*.template
do
    filename=$(basename $f .template)
    cat $f | envsubst > /tmp/${filename}.yaml
    rm $f
done

if [[ -z "${gcp}" ]]; then
    while [ ! -f /var/lib/cloud/instance/boot-finished ]; do sleep 10; done
fi

kubectl create -f /tmp/pv.yaml
# Wait until helm tiller is initialized
helm install --name kube-lego --namespace=support  stable/kube-lego -f /tmp/kube-lego.yaml
helm repo add jupyterhub https://jupyterhub.github.io/helm-chart
helm repo update
helm install jupyterhub/binderhub --version=v0.1.0-85ac189 \
  --name=binderhub --namespace=binderhub -f /tmp/binderhub.yaml
