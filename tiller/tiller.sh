#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

usage() {
cat << EOF
Helpers for working with in-cluster tiller.

Available Commands:
  describe      Show the output of kubectl describe
  destroy       Delete tiller from cluster
  image         Get the image of tiller
  logs          Show the logs of the tiller pod
  pod           Get the name of the tiller pod

EOF
}

pod_name() {
  kubectl -n kube-system get pod --selector=name=tiller,app=helm -o jsonpath='{.items..metadata.name}'; echo
}

image() {
  kubectl -n kube-system get pod "$(pod_name)" -o jsonpath='{.spec.containers[0].image}'; echo
}

describe() {
  kubectl -n kube-system describe pod "$(pod_name)"
}

logs() {
  kubectl -n kube-system logs "$(pod_name)" "$@"
}

destroy() {
  kubectl -n kube-system delete deployment tiller-deploy
}

cmd="${1:-}"
(( "$#" > 0 )) && shift;

case "${cmd}" in
  pod)
    pod_name
    ;;
  logs)
    logs "$@"
    ;;
  describe)
    describe
    ;;
  image)
    image
    ;;
  destroy)
    destroy
    ;;
  help|--help|-h)
    usage
    ;;
  *)
    usage
    exit 1
    ;;
esac
