require "yaml"
require "../config.cr"

abstract class Component
  macro inherited
    def self.new
      if File.exists?("/etc/#{{{ @type.stringify }}.downcase}.yaml")
        from_yaml(File.read("/etc/#{{{ @type.stringify }}.downcase}.yaml"))
      else
        hash = Config.env_to_hash({{ @type.stringify }}.downcase)
        from_yaml(hash.to_yaml)
      end
    end
  end

  abstract def init : Component?
  abstract def initialized? : Bool
  abstract def configure

  def command : Array(String)?
    nil
  end

  def rand_hexstring(len : Int32 = 32) : String
    s = Slice(UInt8).new(len // 2)
    Random::Secure.random_bytes(s)
    s.hexstring
  end
end
