# home-gitops

## Setup

* create cluster with metalLB using this [repo](https://github.com/rossreicks/k3s-ansible)

* I forked techno tim's repo and added the cifs plugin to the config from this [repo](https://github.com/fstab/cifs) because I rely on cifs to attach my zfs pool to the cluster for persistent storage.

* create cloudflare secret using api token (base64 encoded):

to base 64 encode the api token:
```bash
echo -n "YOUR_API_TOKEN" | base64
```

```bash
kubectl create secret generic cloudflare-token-secret --from-literal=cloudflare-token=YOUR_API_TOKEN_BASE64 -n cert-manager
```

* create bitwarden secret using machine key:

```bash
kubectl create secret generic bitwarden-access-token -n bitwarden-secret-store --from-literal=token=YOUR_BITWARDEN_MACHINE_KEY
```

* create a secret for the cifs plugin:

```bash
kubectl create secret generic cifs-secret --from-literal=username=YOUR_CIFS_USERNAME_BASE64 --from-literal=password=YOUR_CIFS_PASSWORD_BASE64
```

