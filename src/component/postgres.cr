require "yaml"
require "./base"

class Component::Postgres < Component::Base
  include YAML::Serializable

  # url like postgres://fider:s0m3g00dp4ssw0rd@db:5432/fider?sslmode=disable
  getter url : String

  def initialize(@url)
  end

  # def open
  #   DB.open "sqlite3://#{path}" do |db|
  #     yield db
  #   end
  # end
end
