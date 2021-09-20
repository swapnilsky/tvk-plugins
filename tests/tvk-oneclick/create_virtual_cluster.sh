#!/usr/bin/env bash

def create_vcluster()
{
  JOB_NAME=$1
  install_ns=$2
  curl -L -o /usr/local/bin/vcluster https://github.com/loft-sh/vcluster/releases/download/v0.4.0-beta.1/vcluster-linux-amd64 \
    && chmod +x /usr/local/bin/vcluster
  vcluster create "${JOB_NAME}" -n "${install_ns}" -f vcluster.yaml
  ## Connect vcluster
  sleep 30
  vcluster connect "${JOB_NAME}"  -n "${install_ns}" --update-current > /dev/null 2>&1 & disown
  sleep 120
  kubectl config use-context "vcluster_${install_ns}_${JOB_NAME}"
  kubectl get ns
  echo "vcluster setup is activated."

  ## Install CSI CRDs
  kubectl apply -f csi-crds.yaml
  echo "csi crds installation is completed."
}

def create_vcluster $1 $2