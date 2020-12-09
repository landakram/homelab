# Homelab

A homelab running Kubernetes with [k3s](k3s.io/). Automated provisioning with [Ansible](https://www.ansible.com/).

## Notes

* Remote user is assumed to be `mark`.
* Remote sudo password is retrieved from keychain on ansible controller. A single sudo password is assumed for all remote hosts.
* DNS is assumed to be managed by CloudFlare nameservers. CloudFlare is used for public DNS entries (for internal, LAN IP addresses) and for dns-01 challenges for LetsEncrypt. 

## Provisioning a new machine

1. Install ubuntu server edition on the new machine. 
    * A `mark` user should be created in the `sudo` group. 
    * The `sudo` password should be the same as what is set in `keyring get ansible-sudo mark` on the ansible controller.
2. Enable [SSH password authentication](https://serverpilot.io/docs/how-to-enable-ssh-password-authentication/)
3. Note the IP address of the new host. This can be done with `nmap` if necessary:

```sh
nmap -p 22  10.0.0.0/24
```

4. Add the new host's IP address to a group in `inventory/homelab/hosts.ini`. If adding a new k8s node (not a master), it should be added under the `[node]` section. Note that this file is not checked into version control.

5. Install ansible dependencies:

```sh
ansible-galaxy install -r requirements.yml
```

6. Bootstrap the node. Note that this will add an SSH key and disable SSH password authentication, making `-k` unnecessary in any subsequent call:

```sh
ansible-playbook site.yml -e @credentials -k
```

## Building a homelab from scratch

This playbook used [k3s-io/k3s-ansible](https://github.com/k3s-io/k3s-ansible) as a starting point. To create a cluster from scratch, one must create inventory files, which are not version controlled in this repo.

So to create a cluster from scratch:

1. Clone this repository
2. Copy the `inventory/sample` directory from [k3s-io/k3s-ansible](https://github.com/k3s-io/k3s-ansible/tree/master/inventory/sample) as `inventory/homelab` in this repo.
3. Set the remote sudo password in the ansible controller's keychain:

```sh
keyring set ansible-sudo mark
```

4. Follow the instructions from [Provisioning a new machine](#provisioning-a-new-machine).
5. After setting up the k8s master, you might want to copy over its kube config so that you can use `kubectl` from the ansible controller:

```sh
scp mark@<master-ip>:~/.kube/config ~/.kube/config
```

**Note:** Additional variables are needed in `inventory/homelab/group_vars/all.yml` than what are stubbed out from k3s-io/k3s-ansible. At some point, I'll make this reproducible. For now, ansible will error out when it reaches an undefined variable. You should take that variable and define it in group_vars.
