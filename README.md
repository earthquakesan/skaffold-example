# skaffold-example
Building and deploying golang application using skaffold.

## Required tools

* make
* docker
* golang
* bash
* skaffold
* kind

Docker should be running with kind cluster created.

## Niceties

* [kube-ps1](https://github.com/jonmosco/kube-ps1)

# Workflow for producing the artifacts

Without skaffold:

```
# Test go code
make test
# Create docker image
make docker-build
# Test docker image
make docker-test
# Push to the docker hub
make docker-push
```

With skaffold:

```
# Test go code
make test
# Create docker image
make docker-build-skaffold
# Test docker image
make docker-test
# Push to the docker hub
make docker-push
# Deploy to the kind cluster
make skaffold-deploy
# Clean up from the kind cluster
make skaffold-delete
```
