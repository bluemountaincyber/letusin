# Kubernetes Audit Preparation

## Prerequisites

- [ ] Access to the Kubernetes cluster with sufficient permissions to create resources (e.g., `ClusterAdmin` role).
- [ ] `kubectl` configured to communicate with the target Kubernetes cluster.

## Run Kube-Bench

1. Deploy `kube-bench` to perform automated checks of environment:

    ```bash
    # AWS EKS
    kubectl apply -f kube-bench-eks.yaml
    ```

2. Collect results after completion (about 1-2 minutes):

    ```bash
    KUBE_BENCH_POD=$(kubectl get pods -A | grep kube-bench | awk '{print $2}')
    kubectl logs "${KUBE_BENCH_POD}" > kube-bench-results.txt
    ```

3. Deliver the `kube-bench-results.txt` file for review.

## Creating a Service Account for Audit

1. Create a service account with read-only permissions:

    ```bash
    kubectl apply -f readonly-user.yaml
    ```

2. Generate the kubeconfig file for the service account:

    ```bash
    ./readonly-user.sh
    ```

3. The previous command will create a `readonly-user.kubeconfig` file. Deliver this file for audit access.

## Destroying Kube-Bench job

After collecting results, clean up the `kube-bench` resources:

```bash
kubectl delete -f kube-bench-eks.yaml
```

## Destroying the Service Account

When audit is complete, remove the service account and associated resources:

```bash
kubectl delete -f readonly-user.yaml
```
