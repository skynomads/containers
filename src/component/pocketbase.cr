require "json"
require "yaml"
require "crypto/bcrypt"
require "./component"
require "./sqlite_database"
require "./litestream"

class Pocketbase < Component
  include YAML::Serializable

  struct Admin
    include YAML::Serializable

    getter email : String

    # Plain password or bcrypt hash
    getter password : String
  end

  getter init : Pocketbase?

  getter litestream : Litestream?

  getter database : SQLiteDatabase = SQLiteDatabase.new("/var/pocketbase/data.db")

  getter port : Int32 = 8000

  getter admin : Admin?

  getter settings : YAML::Any?

  def initialized? : Bool
    File.file?(database.path)
  end

  def configure
    if litestream = @litestream
      litestream.database = database
      litestream.configure
    end
    database.configure

    Process.run("litestream", ["restore", "-if-db-not-exists", "-if-replica-exists", Path[database.path].parent.to_s])
    Process.run("pocketbase", ["--dir", Path[database.path].parent.to_s, "serve", "--http", "0.0.0.0:#{port}"]) do |p|
      sleep 2
      p.terminate
    end

    database.open do |db|
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
    cmd = ["pocketbase", "--dir", Path[database.path].parent.to_s, "serve", "--http", "0.0.0.0:#{port}"]
    if litestream = @litestream
      cmd = litestream.command + ["-exec", Process.quote(cmd)]
    else
      cmd
    end
  end
end
