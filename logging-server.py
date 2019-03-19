
from urllib import parse
from http.server import HTTPServer, BaseHTTPRequestHandler
from io import BytesIO


class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b'Hello, world!')

    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        body = self.rfile.read(content_length)
        logdata = dict(parse.parse_qsl(body.decode()))
        print(logdata)
        self.send_response(200)
        self.end_headers()

httpd = HTTPServer(('127.0.0.1', 8000), SimpleHTTPRequestHandler)
httpd.serve_forever()