require "json"
require "yaml"
require "./base"
require "./postgres"
require "./smtp"

class Component::Fider < Component::Base
  include YAML::Serializable

  struct Tenant
    include YAML::Serializable
    getter email : String
    getter name : String
    legal_agreement : Bool = false
    subdomain : String = ""
  end

  # struct Email
  #   include YAML::Serializable
  #   smtp : SMTP?
  # end

  getter tenant : Tenant?

  # getter signup_disabled : Bool = false

  # getter host_mode : String = "single"

  # getter host_domain : String?

  # getter port : UInt32 = 8000

  # getter jwt_secret : String

  def env
    postgres = get_component!(Postgres).as(Postgres)
    ENV["DATABASE_URL"] = postgres.url
  end

  def configure
    Process.run("fider", ["migrate"])
  end

  def command
    ["fider"]
  end
end
