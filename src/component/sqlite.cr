require "yaml"
require "sqlite3"
require "./base"

class Component::SQLite < Component::Base
  include YAML::Serializable

  getter path : String

  def initialize(@path)
  end

  def initialized? : Bool
    File.file?(path)
  end

  def dir : String
    Path[path].parent.to_s
  end

  def open
    DB.open "sqlite3://#{path}" do |db|
      yield db
    end
  end
end
