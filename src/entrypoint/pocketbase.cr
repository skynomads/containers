require "../component/litestream.cr"
require "../component/pocketbase.cr"
require "./entrypoint"

class PocketbaseEntrypoint < Entrypoint
  getter components : Array(Component) = [Pocketbase.new] of Component
end

PocketbaseEntrypoint.new.run
