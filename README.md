# Homelab

## Notes

* Remote user is assumed to be `mark`
* Remote sudo password is retrieved from keychain on ansible controller

## Provisioning a new machine

1. Install ubuntu server edition on the new machine
2. Enable [SSH password authentication](https://serverpilot.io/docs/how-to-enable-ssh-password-authentication/)
3. Note the IP address of the new host. This can be done with `nmap` if necessary. 
4. Add the new host's IP address to a group in `inventory/homelab/hosts.ini`. Note that this file is not checked into version control.

5. Install ansible dependencies:

```sh
ansible-galaxy install -r requirements.yml
```

6. Bootstrap the node. Note that this will add an SSH key and disable SSH password authentication, making `-s` unnecessary in all subsequent calls:

```sh
ansible-playbook bootstrap.yml -i inventory/homelab/hosts.ini -e @credentials -s
```

7. Install k3s and applications:

```sh
ansible-playbook site.yml -i inventory/homelab/hosts.ini -e @credentials
```

---

README from template:

# Build a Kubernetes cluster using k3s via Ansible

Author: <https://github.com/itwars>

## K3s Ansible Playbook

Build a Kubernetes cluster using Ansible with k3s. The goal is easily install a Kubernetes cluster on machines running:

- [X] Debian
- [X] Ubuntu
- [X] CentOS

on processor architecture:

- [X] x64
- [X] arm64
- [X] armhf

## System requirements

Deployment environment must have Ansible 2.4.0+
Master and nodes must have passwordless SSH access

## Usage

First create a new directory based on the `sample` directory within the `inventory` directory:

```bash
cp -R inventory/sample inventory/my-cluster
```

Second, edit `inventory/my-cluster/hosts.ini` to match the system information gathered above. For example:

```bash
[master]
192.16.35.12

[node]
192.16.35.[10:11]

[k3s_cluster:children]
master
node
```

If needed, you can also edit `inventory/my-cluster/group_vars/all.yml` to match your environment.

Start provisioning of the cluster using the following command:

```bash
ansible-playbook site.yml -i inventory/my-cluster/hosts.ini
```

## Kubeconfig

To get access to your **Kubernetes** cluster just

```bash
scp debian@master_ip:~/.kube/config ~/.kube/config
```
