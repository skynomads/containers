require "yaml"
require "./base"

class Component::SMTP < Component::Base
  include YAML::Serializable

  enum Encryption
    NONE
    STARTTLS
    TLS
  end

  @host : String

  getter port : String?

  getter username : String

  getter password : String

  @[YAML::Field(converter: Enum::ValueConverter(Encryption))]
  getter encryption : Encryption = Encryption::TLS

  def host
    if h = @host
      h
    else
      case encryption
      when Encryption::NONE
        25
      when Encryption::STARTTLS
        587
      when Encryption::TLS
        465
      end
    end
  end
end
