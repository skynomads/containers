require "yaml"
require "sqlite3"
require "./component"

class SQLiteDatabase < Component
  include YAML::Serializable

  getter path : String

  getter init : SQLiteDatabase?

  def initialize(@path)
  end

  def initialized? : Bool
    true
  end

  def configure
  end

  def open
    DB.open "sqlite3://#{path}" do |db|
      yield db
    end
  end
end
