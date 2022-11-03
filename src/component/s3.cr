require "yaml"
require "./base"

class Component::S3 < Component::Base
  include YAML::Serializable

  getter endpoint : String?

  getter region : String?

  getter bucket : String

  getter access_key_id : String

  getter secret_access_key : String
end
