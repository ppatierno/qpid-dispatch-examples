# create certificates db
# certutil -N -d <my_cert_db> -f <cert_password_file>
certutil -N -d qpidd-cert/ -f qpidd-cert-db.pwd

# import CA certificate
# certutil -A -d <my_cert_db> -f <cert_password_file> -i <my_CA_cert_file> -t 'CT,,' -n 'test-CA'
certutil -A -d qpidd-cert/ -f qpidd-cert-db.pwd -i ca-cert.pem -t 'CT,,' -n 'test-CA'

# import broker certificate PKCS12
# pk12util -d <my_cert_db>  -i <broker_pkcs12_cert>
pk12util -i broker-cert-pwd.p12 -d qpidd-cert/

# verify imported cert
# certutil -V -n '<nick_cert>' -u C -d <my_cert_db>
# certutil -V -n '<nick_cert>' -u V -d <my_cert_db>
certutil -V -n 'localhost.localdomain - Trust Me Inc.' -u C -d qpidd-cert/
certutil -V -n 'localhost.localdomain - Trust Me Inc.' -u V -d qpidd-cert/

# starts qpidd
qpidd --ssl-cert-db /qdrouterd/ssl_certs/qpidd-cert/ --ssl-cert-password-file /qdrouterd/ssl_certs/qpidd-cert-db.pwd --ssl-cert-name 'localhost.localdomain - Trust Me Inc.' --ssl-require-client-authentication
