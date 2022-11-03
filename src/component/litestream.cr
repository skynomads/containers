require "yaml"
require "./base"
require "./sqlite"
require "./s3"

class Component::Litestream < Component::Base
  include YAML::Serializable

  getter s3_path : String?

  def initialized? : Bool
    File.file?("/etc/litestream.yaml")
  end

  def configure
    db = get_component!(SQLite).as(SQLite)
    s3 = get_component!(S3).as(S3)

    File.write "/etc/litestream.yaml",
      {
        "dbs" => [
          {
            "path"     => db.path,
            "replicas" => [
              {
                "type"              => "s3",
                "endpoint"          => s3.endpoint,
                "bucket"            => s3.bucket,
                "access-key-id"     => s3.access_key_id,
                "secret-access-key" => s3.secret_access_key,
                "path"              => s3_path,
                # "skip-verify"       => skip_verify,
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
