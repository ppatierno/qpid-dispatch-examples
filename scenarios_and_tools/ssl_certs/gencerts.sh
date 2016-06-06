# generate private key for CA
openssl genrsa -out ca-key.pem 2048
# generate a certificate request for CA
openssl req -new -sha256 -key ca-key.pem -subj '/O=Trust Me Inc./CN=Trusted.CA.com' -out ca-csr.pem
# generate a self signed X509 certificate for CA
openssl x509 -req -in ca-csr.pem -signkey ca-key.pem -out ca-cert.pem

# generate private key for router
openssl genrsa -out router-key.pem 2048
# generate a certificate request for router
openssl req -new -sha256 -key router-key.pem -subj '/O=A-MQ7 Interconnet/CN=localhost.localdomain' -out router-csr.pem
# generate X509 certificate for router signed by CA
openssl x509 -req -in router-csr.pem -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out router-cert.pem

# Router Key password protected
# generate private key for router
openssl genrsa -des3 -passout pass:routerKeyPassword -out router-key-pwd.pem 2048
# generate a certificate request for router
openssl req -new -sha256 -key router-key-pwd.pem -passin pass:routerKeyPassword -subj '/O=A-MQ7 Interconnet/CN=localhost.localdomain' -out router-csr-pwd.pem
# generate X509 certificate for router signed by CA
openssl x509 -req -in router-csr-pwd.pem -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out router-cert-pwd.pem

# generate private key for receiver client
openssl genrsa -out recv-key.pem 2048
# generate a certificate request for receiver client
openssl req -new -sha256 -key recv-key.pem -subj '/O=A-MQ7 Receiver client/CN=127.0.0.1' -out recv-csr.pem
# generate X509 certificate for receiver client signed by CA
openssl x509 -req -in recv-csr.pem -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out recv-cert.pem

# generate private key for sender client
openssl genrsa -out send-key.pem 2048
# generate a certificate request for sender client
openssl req -new -sha256 -key send-key.pem -subj '/O=A-MQ7 Sender client/CN=127.0.0.1' -out send-csr.pem
# generate X509 certificate for sender client signed by CA
openssl x509 -req -in send-csr.pem -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out send-cert.pem

# Bad CA : in order to have client and router using different CA certificates and SSL handshake fails
# generate private key for CA
openssl genrsa -out bad-ca-key.pem 2048
# generate a certificate request for CA
openssl req -new -sha256 -key bad-ca-key.pem -subj '/O=Trust Me Inc./CN=Trusted.CA.com' -out bad-ca-csr.pem
# generate a self signed X509 certificate for CA
openssl x509 -req -in bad-ca-csr.pem -signkey bad-ca-key.pem -out bad-ca-cert.pem

# *** ActiveMQ ***
# Broker key password protected
# generate private key for broker
openssl genrsa -des3 -passout pass:brokerKeyPassword -out broker-key-pwd.pem 2048
# generate a certificate request for broker
openssl req -new -sha256 -key broker-key-pwd.pem -passin pass:brokerKeyPassword -subj '/O=ActiveMQ/CN=localhost.localdomain' -out broker-csr-pwd.pem
# generate X509 certificate for broker signed by CA
openssl x509 -req -in broker-csr-pwd.pem -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out broker-cert-pwd.pem
# export certificate and private key in PKCS12 format (needed by keystore)
openssl pkcs12 -export -in broker-cert-pwd.pem -inkey broker-key-pwd.pem -passin pass:brokerKeyPassword -certfile ca-cert.pem -out broker-cert-pwd.p12
# import certificates into keystore
keytool -importkeystore -srckeystore broker-cert-pwd.p12 -destkeystore broker.ks -srcstoretype pkcs12

# print information about certificates
# openssl x509 -in ca-cert.pem -text
# openssl x509 -in router-cert.pem -text

