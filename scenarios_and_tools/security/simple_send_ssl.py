#!/usr/bin/env python
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

from __future__ import print_function, unicode_literals
import optparse
from proton import Message, SSLDomain
from proton.handlers import MessagingHandler
from proton.reactor import Container


class Send(MessagingHandler):
    def __init__(self, url, messages, ssl_domain=None):
        super(Send, self).__init__()
        self.url = url
        self.sent = 0
        self.confirmed = 0
        self.total = messages
        self.connection = None
        self.container = None
        self.ssl_domain = ssl_domain
        self.sender = None

    def on_start(self, event):
        self.container = event.container
        self.connection = self.container.connect(self.url, ssl_domain=self.ssl_domain)
	# for SASL PLAIN authentication
	#self.connection = self.container.connect(self.url, ssl_domain=self.ssl_domain, sasl_enabled=True, allowed_mechs=b"PLAIN", user="test@domain.com", password="password")
        self.sender = self.container.create_sender(self.connection, "examples")

    def on_sendable(self, event):
        while event.sender.credit and self.sent < self.total:
            msg = Message(id=(self.sent+1), body={'sequence':(self.sent+1)})
            event.sender.send(msg)
            self.sent += 1

    def on_accepted(self, event):
        self.confirmed += 1
        if self.confirmed == self.total:
            print("all messages confirmed")
            event.connection.close()

    def on_disconnected(self, event):
        self.sent = self.confirmed

parser = optparse.OptionParser(usage="usage: %prog [options]",
                               description="Send messages to the supplied address.")

parser.add_option("-a", "--address", default="amqps://127.0.0.1:5672",
                  help="address to which messages are sent (default %default)")

parser.add_option("-m", "--messages", type="int", default=100,
                  help="number of messages to send (default %default)")

parser.add_option("-t", "--ssl-trustfile", default="/home/gmurthy/opensource/dispatch/tests/config-2/ca-certificate.pem",
                  help="The trust file")

parser.add_option("-c", "--ssl-certificate", default="/home/gmurthy/opensource/dispatch/tests/config-2/client-certificate.pem",
                  help="The cert file")

parser.add_option("-k", "--ssl-key", default="/home/gmurthy/opensource/dispatch/tests/config-2/client-private-key.pem",
                  help="The trust key")

parser.add_option("-p", "--ssl-password", default="client-password",
                  help="The trust file")

opts, args = parser.parse_args()

try:
    ssl_domain = SSLDomain(SSLDomain.MODE_CLIENT)
    ssl_domain.set_trusted_ca_db(str(opts.ssl_trustfile))
    ssl_domain.set_peer_authentication(SSLDomain.VERIFY_PEER, str(opts.ssl_trustfile))
    # for client authentication and private key password protected
    #ssl_domain.set_credentials(str(opts.ssl_certificate), str(opts.ssl_key), str(opts.ssl_password))
    # for client authentication and private key NOT password protected
    #ssl_domain.set_credentials(str(opts.ssl_certificate), str(opts.ssl_key), None)
    Container(Send(opts.address, opts.messages, ssl_domain=ssl_domain)).run()
except KeyboardInterrupt: pass
