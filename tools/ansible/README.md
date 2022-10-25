# Overview

A very simple couple of playbooks to create a root CA and self-signed CA cert. Not an ansible role, yet.

## `ca.yml`

Required variables:

`root_ca_key`: Path to the CA's private key (to be created)

`root_ca_cert`: Path to the CA's self-signed cert (to be created)

`ca_privkey_passphrase_file`: Path to a file containing the passphrase - used for idempotency. If the file exists, a new CA will not be created

## generate-and-sign.yml

`private_key_path`: ./myprivkey

`csr_path`: Path to the CSR (to be created)

`common_name`: Common Name (CN) for the generated certificate, also add to the SAN field

`cert_path`: Path to the certificate (to be created)

`ownca_path`: Path to the root CA certificate (pre-existing)

`ownca_privatekey_path`: Path to the root CA private key

`ownca_privatekey_passphrase`: The root CA private key's passphrase