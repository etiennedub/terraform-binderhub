for f in /tmp/*.template
do
    filename=$(basename $f .template)
    cat $f | envsubst > /tmp/${filename}.yaml
    rm $f
done

while [ ! -f /var/lib/cloud/instance/boot-finished ]; do sleep 10; done

kubectl create -f /tmp/pv.yaml
sudo helm install --name kube-lego --namespace=support  stable/kube-lego -f /tmp/kube-lego.yaml
sudo helm repo add jupyterhub https://jupyterhub.github.io/helm-chart
sudo helm repo update
sudo helm install jupyterhub/binderhub --version=v0.1.0-85ac189 \
  --name=binderhub --namespace=binderhub -f /tmp/binderhub.yaml
