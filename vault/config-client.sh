

set VAULT_ADDR=https://localhost:8200

export VAULT_ADDR=https://localhost:8200

# export VAULT_TOKEN=<client token>

vault token lookup

vault kv get secret/fakebank

vault kv get secret/fakebank


# root
export VAULT_TOKEN=s.Bmqoozh5Ta8pBYrcrkLGmbrC  
vault token create -policy=java-app -wrap-ttl=120


# default, wrapping_token
vault unwrap s.6REQDyIBsMqQoL90mUVhzckg

# login with java-app
vault login s.frlzOcOitFfge6tvQ94Nn5yY

# check policies
vault token lookup

# read secret
vault kv get secret/hello 

# app-role, jenkins
vault write auth/approle/role/jenkins  policies="jenkins"

vault read auth/approle/role/jenkins/role-id
=> role_id    c348717f-df08-fbdf-d4a6-6f9d03b6a3bb

vault write -f auth/approle/role/jenkins/secret-id
=> secret_id   b6dd55fe-2b5f-0b20-bd13-e225e1e4cd11

vault write auth/approle/login role_id=${ROLE_ID} secret_id=${SECRET_ID}


# app-role, java-example
vault write auth/approle/role/java-example  secret_id_ttl=60m  token_ttl=60m  token_max_tll=120m  policies="bank-policy"

vault read auth/approle/role/java-example

vault read auth/approle/role/java-example/role-id
=> role_id    379ca378-64a3-a591-951e-d1e9f98fd926

vault write -f auth/approle/role/java-example/secret-id
=> secret_id   f0c6fd9f-1aa6-4476-f0b7-5552d6b79a9b

vault write auth/approle/login role_id=${ROLE_ID} secret_id=${SECRET_ID}
vault write auth/approle/login role_id=379ca378-64a3-a591-951e-d1e9f98fd926 secret_id=f0c6fd9f-1aa6-4476-f0b7-5552d6b79a9b
=> token   s.uGwPOyd0HJpKacjyZlkLvmF5.GezTB

set VAULT_TOKEN=s.uGwPOyd0HJpKacjyZlkLvmF5.GezTB

vault kv get secret/bank

vault token lookup
