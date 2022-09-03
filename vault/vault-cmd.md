## create self-signed cert, no password

export MSYS_NO_PATHCONV=1   

openssl req -x509 -newkey rsa:4096 -keyout localhost.key -out localhost.crt -days 365 -nodes -subj '/C=US/CN=foo' 	 -addext "subjectAltName=DNS:example.com,DNS:www.example.com,DNS:localhost"


# config
```   vault-test.hcl

storage "file" {
  path = "./vault-data"
}
listener "tcp" {
  address = "127.0.0.1:8200"
  tls_cert_file = "./cert/localhost.cert"
  tls_key_file = "./cert/localhost.key"
}
```

# start vault

vault server -config ./vault-test.hcl

# init vault

export VAULT_ADDR=https://localhost:8200

export VAULT_CACERT=./localhost.cert

vault operator init

** this is init output **
Unseal Key 1: kxznzTGWH0QrxLXzrQzbcwv0uRWUqrEjbA+stlw8D7rS
Unseal Key 2: Jd39Fb97LabDWhn2tFRdGVnbTQ2jx6Fgw6ERYahaf6pr
Unseal Key 3: ueJlFK4nTaroWjMO36vfbdfHDoAepayhqCv2YaRRnaAb
Unseal Key 4: 6FhR/e1gBLhI9XUgTfUMMHTbuXwpta8MzV0D7zrwDt5g
Unseal Key 5: 4dwoCu06aGwFriHUnGSHaZUFyNAN1H5bAEIM0PVYa6CT

Initial Root Token: s.Bmqoozh5Ta8pBYrcrkLGmbrC

Vault initialized with 5 key shares and a key threshold of 3. Please securely
distribute the key shares printed above. When the Vault is re-sealed,
restarted, or stopped, you must supply at least 3 of these keys to unseal it
before it can start servicing requests.

Vault does not store the generated master key. Without at least 3 key to
reconstruct the master key, Vault will remain permanently sealed!
****

## show status

export VAULT_TOKEN=s.Bmqoozh5Ta8pBYrcrkLGmbrC  # <root token>

vault status

## now unseal Vault whenever vault restart or new setup 

  *** We need to provide any three of the five key
  
vault operator unseal kxznzTGWH0QrxLXzrQzbcwv0uRWUqrEjbA+stlw8D7rS
vault operator unseal Jd39Fb97LabDWhn2tFRdGVnbTQ2jx6Fgw6ERYahaf6pr
vault operator unseal ueJlFK4nTaroWjMO36vfbdfHDoAepayhqCv2YaRRnaAb
  
  ***   “Sealed” property is “false” in this case, which means that Vault is ready to accept commands.

## enable engine at path: secret

vault secrets enable -path=secret kv

## list secrets engine, 

vault secrets list

## put key-value

vault kv put secret/fakebank    api_key=abc1234 api_secret=1a2b3c4d  
  
## get key-value

vault kv get secret/fakebank 

## Delete the secrets at kv/my-secret.

vault kv delete kv/my-secret

## Creating New Tokens with 48-hour token_duration

vault token create -ttl  48h

## create new policy [read] for new token
``` sample-policy.hcl
path "secret/fakebank" {
    capabilities = ["read"]
}
```
export VAULT_TOKEN=s.Bmqoozh5Ta8pBYrcrkLGmbrC        # <root token>

vault policy write fakebank-readonly  ./sample-policy.hcl

## Creating New Tokens with 48-hour token_duration, readonly policy

vault token create -policy=fakebank-readonly  -ttl  48h

## get and write by new token

export VAULT_TOKEN=s.VhvqyHvFZpF8b6EFPGkqIPgO    # new readonly token
export VAULT_ADDR=https://localhost:8200

vault kv get secret/fakebank    *** should work

vault kv put secret/fakebank    api_key=1111   *** should failed

## configure Vault to use this database. 

vault secrets enable database

## create plugin and connection information :

vault write database/config/mysql-fakebank \
  plugin_name=mysql-database-plugin \
  connection_url="{{username}}:{{password}}@tcp(127.0.0.1:3306)/fakebank" \
  allowed_roles="my-role" \
  username="root" \
  password="abc"
  
## create a role that grants read-only access to all tables of the fakebank schema:

vault write database/roles/my-role \
    db_name=mysql-fakebank \
    creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT ALL PRIVILEGES ON fakebank.* TO '{{name}}'@'%';"  \
	default_ttl="24h" \
    max_ttl="48h"

	**** use base64 encode for statements ****
	
vault write database/roles/my-role \
    db_name=mysql-fakebank \
    creation_statements="Q1JFQVRFIFVTRVIgJ3t7bmFtZX19J0AnJScgSURFTlRJRklFRCBCWSAne3twYXNzd29yZH19JztHUkFOVCBBTEwgUFJJVklMRUdFUyBPTiBmYWtlYmFuay4qIFRPICd7e25hbWV9fSdAJyUnOw=="  \
	default_ttl="24h" \
    max_ttl="48h"
	
  
## get dynamic user / password , /creds prefix is used to generate credentials 
  
vault read database/creds/my-role

**** sample output ****
Key                Value
---                -----
lease_id           database/creds/my-role/4fzvLcgKQ9Cjwu49zJ9yT6MY   *** lease-id is used to renew or revoke these credentials.
lease_duration     24h
lease_renewable    true
password           WlvgdDtvkddY8sls-uvA                ** 
username           v-root-my-role-xtDdOiCANi0nHSmuf    ** 
**** 

## Creating a vault policy for client app,  mysql-client-policy.hcl
```
path "database/creds/my-role" {
  capabilities = ["read"]
}
path "sys/leases/renew" {
  capabilities = ["create"]
}
path "sys/leases/revoke" {
  capabilities = ["update"]
}
```

## creates the mysql-client-policy 

vault policy write mysql-client-policy mysql-client-policy.hcl

## Creating New client Tokens with 48-hour token_duration, readonly policy

vault token create -policy=mysql-client-policy  -ttl  48h

## get and write by client token

export VAULT_TOKEN=s.qTcrZMuOsQ7ZtMvsTyiJT1Ee    # new readonly token
export VAULT_ADDR=https://localhost:8200

vault read database/creds/my-role
**** output ****
Key                Value
---                -----
lease_id           database/creds/my-role/I5S8E8vCOHu5tbQ8B7fsTbz6
password           XhhARPGeKM-zl6xul-Ce
username           v-token-my-role-P6U2uBnE9qDYkc31

``` login mysql 

mysql -uv-token-my-role-P6U2uBnE9qDYkc31 -pXhhARPGeKM-zl6xul-Ce

```


