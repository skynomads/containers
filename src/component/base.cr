require "yaml"

abstract class Component::Base
  def initialized? : Bool
    true
  end

  @[YAML::Field(ignore: true)]
  property components : Array(Component::Base)?

  def configure
  end

  def command : Array(String)?
    nil
  end

  def get_component?(t : T) forall T
    if components = @components
      components.find(&.is_a?(T))
    end
  end

  def get_component!(t : T) forall T
    get_component?(T).not_nil!
  end

  def rand_hexstring(len : Int32 = 32) : String
    s = Slice(UInt8).new(len // 2)
    Random::Secure.random_bytes(s)
    s.hexstring
  end
end
