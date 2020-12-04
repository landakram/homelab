# Homelab

## Notes

* Remote user is assumed to be `mark`
* Remote sudo password is retrieved from keychain on ansible controller

## Provisioning a new machine

1. Install ubuntu server edition on the new machine
2. Enable [SSH password authentication](https://serverpilot.io/docs/how-to-enable-ssh-password-authentication/)
3. Note the IP address of the new host. This can be done with `nmap` if necessary. 
4. Add the new host's IP address to a group in `inventory/homelab/hosts.ini`. If adding a new k8s node (not a master), it should be added under the `[node]` section. Note that this file is not checked into version control.

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

## Building a homelab from scratch

This playbook used [k3s-io/k3s-ansible](https://github.com/k3s-io/k3s-ansible) as a starting point. To create a cluster from scratch, one must create inventory files, which are not version controlled in this repo.

So to create a cluster from scratch:

1. Clone this repository
2. Copy the `inventory/sample` directory from [k3s-io/k3s-ansible](https://github.com/k3s-io/k3s-ansible/tree/master/inventory/sample) as `inventory/homelab` in this repo.
3. Follow the instructions from [Provisioning a new machine](#provisioning-a-new-machine).
