# 📄 Inventory Configuration for OpenShift SNO Automation

This document explains the configurable values for the OpenShift Single Node (SNO) setup automation, focusing on the `inventory/hosts.yaml` and `inventory/group_vars/all.yaml` files. 🎛️

## ⚙️ Configuration Overview

### 📝 `inventory/hosts.yaml`

This file defines the hosts used in the OpenShift cluster, including `localhost` and the `sno1` node. 🖥️

#### Configuration Options:

- **localhost**:
  - **ansible_connection**: `local` — Indicates that Ansible should run locally. 🏠
  - **ansible_user**: `root` — The user to run the Ansible commands as. 👨‍💻
  - **bridge_if**: `"wlp3s0"` — The interface used for bridging in the virtual machine setup. 🌐

- **sno1**:
  - **ansible_host**: `192.168.1.100` — The IP address of the `sno1` node. 🌍
  - **ansible_user**: `core` — The user to run commands on the `sno1` node. 👨‍💻
  - **ansible_ssh_private_key_file**: `~/.ssh/id_rsa` — The path to the private key for SSH access to `sno1`. 🔑
  - **hostname**: `{{ inventory_hostname }}` — The hostname of the `sno1` node, dynamically set. 🖥️
  - **interface**: `enp0s3` — The network interface for the `sno1` node. 🌐
  - **mac_addr**: `"52:54:00:aa:bb:cc"` — The MAC address of the network interface. 🏷️
  - **cidr**: `192.168.1.0/24` — The CIDR block for the `sno1` network. 🌍
  - **raw_path**: `"/root/VirtualBox VMs/sno1/sno1.raw"` — The path to the raw disk image for the VM. 💾
  - **iso_path**: `"../deployment/agent.x86_64.iso"` — The path to the ISO file used for installation. 📀
  - **dns**: `192.168.1.1` — The DNS server for the node. 🌐
  - **gateway**: `192.168.1.1` — The default gateway for the `sno1` node. 🚪

### 🔧 `inventory/group_vars/all.yaml`

This file defines global variables used throughout the OpenShift SNO setup, especially for the install configuration files. 🌍

#### Configuration Options:

- **sno_cluster_name**: `"sno-cluster"` — The name of the OpenShift cluster. 🏰
- **base_domain**: `"test"` — The base domain for the cluster (e.g., `sno-cluster.test`). 🌐
- **sno_network_cidr**: `"192.168.1.0/24"` — The network CIDR for the cluster. 🌍
- **pull_secret**: `"{{ lookup('file', '../secrets/pull-secret.txt') | string }}"` — The pull secret used for accessing the OpenShift container registry. 🔐
- **ssh_public_key**: `"{{ lookup('file', '../secrets/id_rsa.pub') }}"` — The SSH public key used for access. 🔑

### 🛠️ Template Usage

The variables defined in `inventory/group_vars/all.yaml` are used in the templates for `agent-config.yaml` and `install-config.yaml`, as shown in the following:

#### `roles/sno_install/templates/agent-config.yaml.j2`

This template defines the configuration for the agent node, including networking, DNS settings, and interfaces. It uses variables like `sno_cluster_name`, `sno_ip`, and `sno_mac_addr` to configure the agent's network and IP settings. 🌐

#### `roles/sno_install/templates/install-config.yaml.j2`

This template defines the OpenShift install configuration, including details for the control plane, compute nodes, networking, and SSH keys. It uses the variables defined in the `all.yaml` file to fill in the necessary information for the cluster setup. 🖥️

---

## 🚀 How to Use

1. **Set up your environment**:
   - Make sure you have all the necessary configuration in the `inventory/hosts.yaml` and `inventory/group_vars/all.yaml` files. 🛠️
   - The `pull_secret` and `ssh_public_key` should be provided from your local secrets. 🔑

2. **Run the playbooks**:
   - To start the setup, run the following playbooks:
     ```bash
     ansible-playbook playbooks/base_setup.yaml 🛠️
     ansible-playbook playbooks/virtualbox.yaml 🖥️
     ansible-playbook playbooks/deploy_sno.yaml 🚀
     ```

3. **Customizing**:
   - Modify the variables in `inventory/group_vars/all.yaml` to match your OpenShift and network configuration. ✏️
   - Ensure that the `sno1` node has the appropriate settings for hostname, IP address, and other parameters. 🖥️


