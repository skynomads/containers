require "json"
require "yaml"
require "crypto/bcrypt"
require "./base"
require "./sqlite"
require "./litestream"

class Component::Pocketbase < Component::Base
  include YAML::Serializable

  struct Admin
    include YAML::Serializable

    getter email : String

    # Plain password or bcrypt hash
    getter password : String
  end

  getter port : Int32 = 8000

  getter admin : Admin?

  getter settings : YAML::Any?

  def initialized? : Bool
    true
  end

  def configure
    sqlite = get_component!(SQLite).as(SQLite)

    Process.run("litestream", ["restore", "-if-db-not-exists", "-if-replica-exists", sqlite.dir])
    Process.run("pocketbase", ["--dir", sqlite.dir, "serve", "--http", "0.0.0.0:#{port}"]) do |p|
      sleep 2
      p.terminate
    end

    sqlite.open do |db|
      if admin = @admin
        db.exec(
          "INSERT OR REPLACE INTO _admins (email, passwordHash, id, tokenKey) VALUES (?, ?, ?, ?)",
          admin.email,
          admin.password.starts_with?(/\\$2.?\\$/) ? admin.password : Crypto::Bcrypt.hash_secret(admin.password, 13),
          rand_hexstring(16),
          rand_hexstring,
        )
      end

      if settings = @settings
        db.query("SELECT value FROM _params WHERE key = 'settings'") do |result|
          current = JSON.parse(result.read(String)).as_h
          merged = current.merge(settings.as_h).to_json
          db.exec("UPDATE _params SET value = (?) WHERE key = 'settings'", merged)
        end
      end
    end
  end

  def command
    sqlite = get_component!(SQLite).as(SQLite)
    ["pocketbase", "--dir", sqlite.dir, "serve", "--http", "0.0.0.0:#{port}"]
  end
end
