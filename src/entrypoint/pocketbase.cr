require "yaml"
require "../component/sqlite"
require "../component/litestream"
require "../component/pocketbase"
require "../component/s3"
require "./entrypoint"

class Entrypoint::Pocketbase < Entrypoint::Base
  include YAML::Serializable

  getter sqlite : Component::SQLite = Component::SQLite.new("/var/pocketbase/data.db")
  getter s3 : Component::S3?
  getter litestream : Component::Litestream?
  getter pocketbase : Component::Pocketbase

  def components : Array(Component::Base)
    [sqlite, s3, litestream, pocketbase].reject(&.nil?).map(&.not_nil!)
  end

  def exec : Array(String)
    if litestream = @litestream
      litestream.command + ["-exec", Process.quote(pocketbase.command)]
    else
      pocketbase.command
    end
  end
end

Entrypoint::Pocketbase.new.run
