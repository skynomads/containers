require 'net/http'
require 'json'

JSON_HEADERS = { 'Content-Type': 'application/json', 'Accept': 'application/json"' }.freeze

# retryable version of http.request
def http_request(http, req, body = nil, retries = 5)
  res = http.request(req, body)
  raise StandardError.new "HTTP code #{res.code}: #{res.body}" unless res.is_a? Net::HTTPSuccess

  res
rescue StandardError => e
  raise(e) unless retries.positive?

  retries -= 1
  sleep 1
  retry
end

def json_request(uri, req, data)
  req.body = data.to_json
  res = http_request(Net::HTTP.new(uri.host, uri.port), req)
  JSON.parse(res.body)
end

def post_json(url, data, headers = {})
  uri = URI(url)
  req = Net::HTTP::Post.new(uri.path, headers.merge(JSON_HEADERS))
  json_request(url, req, data)
end

def patch_json(url, data, headers = {})
  uri = URI(url)
  req = Net::HTTP::Patch.new(uri.path, headers.merge(JSON_HEADERS))
  json_request(url, req, data)
end
