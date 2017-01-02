module FrameworkGenerate
  class Language

    attr_accessor :type, :version

    def initialize(type, version)
      @type = type
      @version = version
    end

  end
end
