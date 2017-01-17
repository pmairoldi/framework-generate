module FrameworkGenerate
  class Script
    attr_accessor :name, :script, :inputs

    def initialize(name = nil, script = nil, inputs = nil)
      @name = name
      @script = script
      @inputs = inputs

      yield(self) if block_given?
    end

    def to_s
      "Script<#{script}, #{inputs}>"
    end
  end
end
