#!/usr/bin/env python
# -*- coding: utf-8 -*-
import argparse
import logging
import logging.handlers
import SocketServer

from datetime import datetime as dt

HOST = '0.0.0.0'
PORT = 843
POLICYREQUEST = '<policy-file-request/>'

_policy = """<?xml version="1.0" encoding="utf-8" ?>
<cross-domain-policy>
<site-control permitted-cross-domain-policies="all"/>
<allow-access-from domain="*" to-ports="*"/>
<allow-http-request-headers-from domain="*" headers="*"/>
</cross-domain-policy>"""
_timeout = 5

_logger = logging.getLogger('Logger')
_logger.setLevel(logging.DEBUG)


def main(port):
    server = SocketServer.ThreadingTCPServer((HOST, port), RequestHandler)
    server.serve_forever()


class RequestHandler(SocketServer.StreamRequestHandler):
    timeout = _timeout
    allow_reuse_address = True

    def handle(self):
        self.data = self.request.recv(128).strip()
        _logger.info('%s %s' % (dt.now().strftime('%Y-%m-%d %H:%M:%S'), self.data))

        if self.data.startswith(POLICYREQUEST):
            self.request.sendall(_policy)

        self.request.close()


if __name__ == "__main__":
    parser =\
        argparse.ArgumentParser(description=u'Flash Socket Policy Server')
    parser.add_argument('-f', '--file', type=str, default=None,
                        help=u'policy file path')
    parser.add_argument('-p', '--port', type=int, default=PORT,
                        help=u'listening port')
    parser.add_argument('-t', '--timeout', type=int, default=_timeout,
                        help=u'request timeout')
    parser.add_argument('-l', '--logfile', type=str, default=None,
                        help=u'log file path')
    args = parser.parse_args()

    _timeout = args.timeout

    if args.file is not None:
        with open(args.file, 'r') as f:
            _policy = f.read()

    if args.logfile is None:
        handler = logging.StreamHandler()
    else:
        handler = logging.handlers.RotatingFileHandler(args.logfile,
                                                       maxBytes=1024 ** 3,
                                                       backupCount=5)
    _logger.addHandler(handler)

    main(args.port)
