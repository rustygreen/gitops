# GitOps

## :information_source: Overview

This repository is a centralized source for all my Kubernetes clusters. It serves as sort of [monorepository](https://fluxcd.io/flux/guides/repository-structure/#monorepo), which allows for workload definition and configuration reusability between clusters and environments. The point of this setup is to provide a single source for many (if not all) clusters which can share workload configurations, scripts, and other provisioning tools.

The point of this setup is to simplify cluster creation, management, and increase re-usability between clusters. All clusters defined in this repository should never be directly modified (using [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/)). All changes are made through commits/PRs to this repository. Each cluster will watch for changes to this repository and update accordingly (via [FluxCD](https://fluxcd.io/)).

## :sparkles: FluxCD

[FluxCD](https://fluxcd.io/) is used as the continuous and progressive delivery solution for watching the repository for changes and applying those changes to the cluster. The structure and use of this repository requires a basic understanding of FluxCD concepts. The following resources are recommended to get started with Flux:

- https://fluxcd.io/flux/concepts/
- https://fluxcd.io/flux/get-started/
- https://www.youtube.com/watch?v=NwAgATWoEcM
- https://anaisurl.com/full-tutorial-getting-started-with-flux-cd/

## :cd: Environment Setup

Each cluster makes use of different scripts/methods for bootstrapping and working with the cluster. View the README.md file in the root of each cluster folder to understand how to work with that cluster.

The idea is to have every cluster in this repository easily repeatable. The cluster should be able to be torn down, re-created, and restored through simple commands. Below is an example of bootstrapping an Azure cluster:

<iframe allowfullscreen style="border:none" src="https://clipchamp.com/watch/RpfVnbbcxTK/embed" width="640" height="360">
</iframe>

[Video Source](https://clipchamp.com/watch/RpfVnbbcxTK)

## :light: Philosophy

The following ideas, patterns, and philosophies are applied for clusters in this repository:

- Reusability of workload definitions and configurations across clusters (change once).
- Individual cluster behavior can be changed through the encrypted settings file see SOPs files section.
- All cluster dependencies are stored in this repository.
- Clusters only get updated through GitOps.

## :open_file_folder: Structure

The structure and setup of this repository is designed to allow for testable and trackable changes to be made to each cluster (by using Git). Each cluster has a documented bootstrapping process to allow for repeatable cluster initializations along with teardown and restore procedures. See the README.md file located in the root of each cluster for specific documentation on each cluster.

The following structure/convention is used:

```bash
📦gitops # repo root
 ┣ 📂base # contains all re-usable cluster workloads
 ┃ ┗ 📂example-workload # projects are grouped by client or other grouping
 ┃
 ┗ 📂clusters # contains all cluster definitions
   ┗ 📂my-cluster # root folder for "my-cluster"
     ┗ 📜README.md # see this file for all info on this cluster
     ┗ 📂staging # the staging environment for this cluster
     ┗ 📂production # the production environment for this cluster
       ┗ 📂workloads # defines all workloads for this cluster/environment
       ┗ 📂settings
         ┗ cluster-settings.sops.yaml # unique settings for cluster (encrypted with SOPS)
```

## :computer: Clusters

The following clusters are managed in this repository.

TODO

## :gear: Pull Request Workflow

Each cluster is setup so that Flux will automatically apply changes to the cluster when a change is pushed to this repository (a pull model, rather than push). Each cluster, with multiple environments, will be setup so that a [gitflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) process can be used.

**Example:**

- my-cluster/staging cluster is updated anytime changes are pushed to the `develop` branch
- my-cluster/production cluster is updated anytime changes are pushed to the `master` branch

![PR workflow](https://lucid.app/publicSegments/view/4b6f2312-defa-4026-9207-7c737470c804/image.jpeg)

## :key: SOPs files

Since the entire state of the cluster is stored in this repository, it is necessary to encrypt certain information for a cluster( such as, passwords, SSH keys, etc.). FluxCD has various decryption providers (see [docs here](https://fluxcd.io/flux/guides/mozilla-sops/#configure-in-cluster-secrets-decryption)). Clusters in this repository use [Mozilla SOPs](https://github.com/mozilla/sops) with the [age encryption tool](https://github.com/FiloSottile/age).
