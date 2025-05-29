# 🚀 OpenShift SNO Automation for Fedora 42

This repository provides Ansible automation for fully setting up a Single Node OpenShift (SNO) environment on Fedora 42 Server with VirtualBox. The workflow is optimized for repeatability and minimal manual steps.

## 🛡️ License

```
Apache License 2.0
```

## 📋 Overview

This project enables fast, automated deployment of an OpenShift SNO lab with the following features:

* Automated Fedora 42 host configuration (base packages, RPMFusion, sysctl, LVM, GRUB, intel-undervolt)
* Automated download and setup of OpenShift CLI tools (butane, openshift-install, oc, kubectl)
* Automated VirtualBox installation/configuration, including VNC/Oracle extension packs
* Fully automated generation and deployment of SNO installer artifacts
* Built-in backup, logging, and repeatable provisioning steps

## ⚡️ Quick Start

> **First, install Fedora 42 Server and clone this repository.**

```sh
sudo dnf install -y git
# (optionally set up your SSH key, if needed)
git clone https://github.com/masaki-furuta/openshift-sno-automation-ansible.git
cd openshift-sno-automation-ansible
```

### 1. 🛠️ Base Setup (Initial Host Configuration)

**Before running the playbooks, install Ansible and required collections:**

```sh
sudo dnf -y install ansible-core ansible-collection-community-general
```

Then, run **base\_setup** to initialize your Fedora 42 host:

```sh
ansible-playbook playbooks/base_setup.yaml
```

This will:

* Enable RPMFusion
* Install required packages
* Configure LVM, sysctl, GRUB
* Apply intel-undervolt settings

### 2. 📦 OpenShift CLI Tools

Run **openshift\_cli** to fetch and install all required OpenShift CLI tools:

```sh
ansible-playbook playbooks/openshift_cli.yaml
```

This will:

* Download and install butane, openshift-install, oc, kubectl

### 3. 🖥️ VirtualBox Installation

Run **virtualbox** to install and configure VirtualBox:

```sh
ansible-playbook playbooks/virtualbox.yaml
```

This will:

* Install VirtualBox
* Install VNC/Oracle extension packs (automatically shuts down running VMs if needed)

### 4. 🚦 Deploy OpenShift SNO

Now you can run the full SNO deployment playbook:

```sh
ansible-playbook playbooks/deploy_sno.yaml
```

This will:

* Remove old OpenShift install state if present
* Generate `agent-config.yaml` and `install-config.yaml` from Jinja2 templates and inventory/group\_vars
* Create a backup of config files and artifacts for each run
* Create the Agent ISO
* Provision and start the VirtualBox VM
* Wait for the cluster to become ready and print out access details

---

## 📁 Directory Structure

```text
openshift-sno-automation-ansible/
├── 📂 ansible.cfg                  # Ansible configuration file
├── 📂 scripts/                     # Helper scripts (setup, tools)
├── 📂 deployment/                  # Generated files, ISO, backups
│   ├── 🔐 auth/                    # kubeadmin credentials, kubeconfig
│   ├── 🕒 previous-run/            # Timestamped backups of each deployment
│   └── agent.x86_64.iso            # Generated SNO agent ISO
├── 📂 inventory/                   # Inventory and host/group variables
│   ├── 🗂️ group_vars/
│   │   └── all.yaml                # Cluster/global vars
│   └── hosts.yaml                  # Hosts and group membership
├── 📂 playbooks/                   # Main playbooks
│   ├── base_setup.yaml
│   ├── openshift_cli.yaml
│   ├── virtualbox.yaml
│   └── deploy_sno.yaml
├── 📂 roles/                       # Ansible roles (common, pre_install, sno_install, post_install)
│   ├── common/
│   ├── pre_install/
│   ├── sno_install/
│   └── post_install/
├── 📂 secrets/                     # Secrets (pull secret, SSH key)
│   ├── pull-secret.txt
│   └── id_rsa.pub
└── README.md                       # (This file)
```

## 📝 Notes

* You must provide a valid **Red Hat OpenShift pull secret** in `secrets/pull-secret.txt` and your SSH public key in `secrets/id_rsa.pub` before running `deploy_sno.yaml`.
* All cluster and host-specific variables can be edited in `inventory/group_vars/all.yaml` and `inventory/hosts.yaml`.
* The `deployment/previous-run/` directory contains a timestamped backup of each run, including configs and ISOs.

## 🤝 Contributing

Contributions and improvements are welcome! Please fork the repo and send pull requests.

## 🛡️ License

```
Licensed under the Apache License, Version 2.0
See LICENSE file for details.
```
