
## create self-signed cert, no password

export MSYS_NO_PATHCONV=1   

openssl req -x509 -newkey rsa:4096 -keyout localhost.key -out localhost.crt -days 365 -nodes -subj '/C=US/CN=foo' 	 -addext "subjectAltName=DNS:example.com,DNS:www.example.com,DNS:localhost"


