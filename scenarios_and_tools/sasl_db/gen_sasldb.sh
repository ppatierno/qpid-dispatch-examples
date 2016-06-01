# https://github.com/apache/qpid-dispatch/blob/8783d5e22b0a9bf29728c03e8c3204a4db18d4e9/tests/system_tests_sasl_plain.py
# http://www.sendmail.org/~ca/email/cyrus2/options.html

saslpasswd2 -c -p -f qdrouterd.sasldb -u domain.com test
