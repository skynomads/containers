require "yaml"
require "./component"
require "./sqlite_database"

class Litestream < Component
  include YAML::Serializable

  getter init : SQLiteDatabase?

  property database : SQLiteDatabase?

  getter endpoint : String?

  getter bucket : String

  @[YAML::Field(key: "accessKeyID")]
  getter access_key_id : String

  @[YAML::Field(key: "secretAccessKey")]
  getter secret_access_key : String

  getter bucket : String

  getter path : String?

  @[YAML::Field(key: "skipVerify")]
  getter skip_verify : Bool?

  @[YAML::Field(key: "forcePathStyle")]
  getter force_path_style : Bool?

  def initialized? : Bool
    File.file?("/etc/litestream.yaml")
  end

  def configure
    File.write "/etc/litestream.yaml",
      {
        "dbs" => [
          {
            "path"     => database.not_nil!.path,
            "replicas" => [
              {
                "type"              => "s3",
                "endpoint"          => endpoint,
                "bucket"            => bucket,
                "access-key-id"     => access_key_id,
                "secret-access-key" => secret_access_key,
                "path"              => path,
                "skip-verify"       => skip_verify,
              },
            ],
          },
        ],
      }.to_yaml
  end

  def command
    ["litestream", "replicate"]
  end
end
