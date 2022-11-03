require "yaml"
require "../component/postgres"
require "../component/fider"
require "./entrypoint"

class Entrypoint::Fider < Entrypoint::Base
  include YAML::Serializable

  getter postgres : Component::Postgres
  getter fider : Component::Fider

  def components : Array(Component::Base)
    [postgres, fider] of Component::Base
  end

  def exec : Array(String)
    fider.command
  end
end

Entrypoint::Fider.new.run
