require "yaml"
require "../component/litestream"
require "../component/nodebb"
require "./entrypoint"

class Entrypoint::NodeBB < Entrypoint::Base
  include YAML::Serializable

  getter nodebb : Component::NodeBB

  def components : Array(Component::Base)
    [nodebb] of Component::Base
  end

  def exec : Array(String)
    nodebb.command
  end
end

Entrypoint::NodeBB.new.run
