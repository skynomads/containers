require "yaml"
require "option_parser"
require "../config"
require "../component/base"

abstract class Entrypoint::Base
  macro inherited
    def self.new
      if File.exists?("/etc/#{{{ @type.stringify }}.downcase}.yaml")
        from_yaml(File.read("/etc/#{{{ @type.stringify }}.downcase}.yaml"))
      elsif config = ENV["CONTAINER_CONFIG"]
        from_yaml(config)
      else
        hash = Config.env_to_hash({{ @type.stringify }}.downcase)
        from_yaml(hash.to_yaml)
      end
    end
  end

  enum Command
    Run
    Debug
  end

  @verbose : Bool = false
  @command : Command = Command::Run

  abstract def components : Array(Component::Base)
  abstract def exec : Array(String)

  def run
    OptionParser.parse do |parser|
      parser.banner = "Usage: entrypoint [command] [arguments]"
      parser.on("run", "Run") do
        @command = Command::Run
        parser.banner = "Usage: run [arguments]"
        # parser.on("-t NAME", "--to=NAME", "Specify the name to salute") { |_name| name = _name }
      end
      parser.on("debug", "Debug") do
        @command = Command::Debug
        parser.banner = "Usage: debug [arguments]"
      end
      parser.on("-v", "--verbose", "Enabled verbose output") { @verbose = true }
      parser.on("-h", "--help", "Show this help") do
        puts parser
        exit
      end
      parser.invalid_option do |flag|
        STDERR.puts "ERROR: #{flag} is not a valid option."
        STDERR.puts parser
        exit(1)
      end
    end

    components.each { |c| c.components = components }

    case @command
    when Command::Run
      components.each do |component|
        if component.initialized?
          component.configure
        else
          component.configure
          # TODO optional separate init config
          # base = YAML.parse(component.to_yaml).as_h
          # init = YAML.parse(component.init.to_yaml).as_h
          # component.class.from_yaml(base.merge(init).to_json).configure
        end
      end
      cmd = exec
      Process.exec(cmd[0], cmd.skip(1))
    when Command::Debug
      components.each { |c| puts c.to_yaml }
    end
  end
end
