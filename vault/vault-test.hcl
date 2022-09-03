ui = true

storage "file" {
  path = "./vault-data"
}

listener "tcp" {
  address = "127.0.0.1:8200"
  tls_cert_file = "./cert/localhost.crt"
  tls_key_file = "./cert/localhost.key"
}