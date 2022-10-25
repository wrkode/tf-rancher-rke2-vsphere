Please drop the tls-material in here before running the `terraform plan`/`terraform apply`

- A Signed CA certificate, named `cacerts.pem`
- A certificate and private key to cover the hostname of the Rancher UI and any Rancher ingresses, named `tls.crt` and `tls.key` respectively

```
├── cacerts.pem
├── tls.crt
└── tls.key
```