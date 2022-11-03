class Config
  alias Value = String | Bool | Float64 | Int32 | Hash(String, Value) | Array(Value)

  def self.env_to_hash(prefix, delete_prefix : Bool = true, downcase : Bool = true) : Hash(String, Value)
    hash = Hash(String, Value).new
    ENV.each do |e, value|
      next unless e.starts_with?(prefix)
      keys = (delete_prefix ? e.lchop(prefix).lchop('_').lchop('_') : e).split("__")
      hash_set_nested(hash, keys, parse_env_value(value), downcase)
    end
    # if downcase
    #   hash.transform_keys(&.downcase)
    # else
    #   hash
    # end
    hash
  end

  def self.hash_set_nested(hash : Hash(String, Value), path : Array(String), value : Value, downcase : Bool = true)
    key = path.shift.as(String)
    # key = key.downcase if downcase
    if path.empty?
      hash[key] = value
    else
      hash[key] = Hash(String, Value).new unless hash.has_key?(key)
      hash_set_nested(hash[key].as(Hash(String, Value)), path, value)
    end
  end

  def self.parse_env_value(value) : Value
    # quoted string
    return value.lchop('"').rchop('"').as(Value) if value.starts_with?('"') && value.ends_with?('"')

    # bool
    return (value == "true").as(Value) if %w[true false].includes?(value)

    # integer
    begin
      return value.to_i.as(Value)
    rescue ArgumentError
    end

    # float
    begin
      value.to_f.as(Value)
    rescue ArgumentError
    end

    # string
    value.as(Value)
  end
end
