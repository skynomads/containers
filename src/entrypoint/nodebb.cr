require "../component/litestream.cr"
require "../component/nodebb.cr"
require "./entrypoint"

class NodeBBEntrypoint < Entrypoint
  getter components : Array(Component) = [NodeBB.new] of Component
end

NodeBBEntrypoint.new.run
