require "yaml"
require "json"
require "./component"

class NodeBB < Component
  include YAML::Serializable

  getter init : NodeBB?

  getter url : String?

  def initialized? : Bool
    File.file?("/usr/share/nodebb/config.json")
  end

  def configure
    # TODO secret etc https://docs.nodebb.org/configuring/config/
    File.write "/usr/share/nodebb/config.json",
      {
        "upload_path" => "/var/nodebb/uploads",
        "url"         => url,
      }.to_json

    Dir.cd("/usr/share/nodebb") do
      Process.run("./nodebb", ["setup"])
    end
  end

  def command
    ["node", "/usr/share/nodebb/nodebb", "start"]
  end
end
