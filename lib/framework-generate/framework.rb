module FrameworkGenerate
  class Framework

    attr_accessor :name, :supported_platforms, :language, :targets

    def initialize(name, supported_platforms, language, targets)
      @name = name
      @supported_platforms = supported_platforms
      @language = language
      @targets = targets
    end

  end
end
