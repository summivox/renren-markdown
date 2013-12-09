#!/usr/bin/coffee

http = require 'http'
url = require 'url'

if isNaN(port = parseInt process.argv.pop())
  console.log """need port"""
  return

server = http.createServer (req, res) ->
  if (b64 = url.parse(req.url).query) && b64.length <= 8192
    res.setHeader 'Content-Type', 'image/png'
    res.write new Buffer b64, 'base64'
  res.end()

server.listen port
