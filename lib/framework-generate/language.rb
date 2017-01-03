module FrameworkGenerate
  class Language
    attr_accessor :type, :version

    def initialize(type = nil, version = nil)
      @type = type
      @version = version

      yield(self) if block_given?
    end

    def to_s
      "Language<#{type}, #{version}>"
    end
  end
end
