def env_to_hash(prefix, delete_prefix: true)
  hash = {}
  ENV.filter { |n, _| n.start_with?(prefix) }.each do |e, value|
    keys = (delete_prefix ? e.delete_prefix(prefix).delete_prefix('_') : e).downcase.split('_')
    hash_set_nested(hash, keys, parse_env_value(value))
  end
  hash
end

def hash_set_nested(hash, path, value)
  key = path.shift
  if path.empty?
    hash[key] = value
  else
    hash[key] = {} unless hash.key?(key)
    hash_set_nested(hash[key], path, value)
  end
end

def parse_env_value(value)
  # quoted string
  return value.delete_prefix('"').delete_suffix('"') if value.start_with?('"') && value.end_with?('"')

  # bool
  return value == 'true' if %w[true false].include?(value)

  # integer
  i = Integer(value, exception: false)
  return i unless i.nil?

  # float
  f = Float(value, exception: false)
  return f unless f.nil?

  # string
  value
end
