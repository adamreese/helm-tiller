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

TILLER_NAMESPACE=${TILLER_NAMESPACE:-kube-system}

pod_name() {
  kubectl -n "${TILLER_NAMESPACE}" get pod --selector=name=tiller,app=helm -o jsonpath='{.items..metadata.name}'; echo
}

image() {
  kubectl -n "${TILLER_NAMESPACE}" get pod "$(pod_name)" -o jsonpath='{.spec.containers[0].image}'; echo
}

describe() {
  kubectl -n "${TILLER_NAMESPACE}" describe pod "$(pod_name)"
}

logs() {
  kubectl -n "${TILLER_NAMESPACE}" logs "$(pod_name)" "$@"
}

destroy() {
  kubectl -n "${TILLER_NAMESPACE}" delete deployment tiller-deploy
  kubectl -n "${TILLER_NAMESPACE}" delete service tiller-deploy
  kubectl -n "${TILLER_NAMESPACE}" delete secret tiller-secret 2>/dev/null || :
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
