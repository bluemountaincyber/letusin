#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="kube-system"
SERVICE_ACCOUNT="readonly-user"
OUTPUT_FILE="readonly-user.kubeconfig"

echo "🔧 Generating kubeconfig for ServiceAccount '${SERVICE_ACCOUNT}' in namespace '${NAMESPACE}'..."

# --- Collect cluster info ---
CLUSTER_NAME=$(kubectl config view --minify -o jsonpath='{.clusters[0].name}')
SERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
CA_DATA=$(kubectl config view --raw --minify -o jsonpath='{.clusters[0].cluster.certificate-authority-data}')

# --- Create token (Kubernetes v1.24+) ---
TOKEN=$(kubectl -n "${NAMESPACE}" create token "${SERVICE_ACCOUNT}")

# --- Build kubeconfig file ---
cat <<EOF > "${OUTPUT_FILE}"
apiVersion: v1
kind: Config
clusters:
- name: ${CLUSTER_NAME}
  cluster:
    certificate-authority-data: ${CA_DATA}
    server: ${SERVER}
contexts:
- name: readonly-context
  context:
    cluster: ${CLUSTER_NAME}
    user: ${SERVICE_ACCOUNT}
current-context: readonly-context
users:
- name: ${SERVICE_ACCOUNT}
  user:
    token: ${TOKEN}
EOF

echo "✅ Kubeconfig created: ${OUTPUT_FILE}"
echo "👉 Test it with:"
echo "   KUBECONFIG=${OUTPUT_FILE} kubectl get pods --all-namespaces"
