require 'net/http'
require 'json'

# def http_wait(url, tries = 5)
#   Net::HTTP.get(url)
# rescue StandardError => e
#   raise(e) unless tries.positive?

#   tries -= 1
#   sleep 1
#   retry
# end

# retryable version of http.request
def http_request(http, req, body = nil, retries = 5)
  res = http.request(req, body)
  raise StandardError.new "HTTP code #{res.code}: #{res.body}" if res.code >= 400

  res
rescue StandardError => e
  raise(e) unless retries.positive?

  retries -= 1
  sleep 1
  retry
end

def post_json(url, data, header = {})
  uri = URI(url)
  req = Net::HTTP::Post.new(uri.path, header.merge({ 'Content-Type': 'application/json', 'Accept': 'application/json"' }))
  req.body = data.to_json
  res = http_request(Net::HTTP.new(uri.host, uri.port), req)
  JSON.parse(res.body)
end
