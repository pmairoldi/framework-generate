module FrameworkGenerate
  class Project
    attr_accessor :name, :platforms, :language, :targets

    def initialize(name = nil, platforms = nil, language = nil, targets = nil)
      @name = name
      @platforms = platforms
      @language = language
      @targets = targets

      yield(self) if block_given?
    end

    def project
      yield(self) if block_given?
      self
    end

    def to_s
      "Project<#{name}, #{platforms}, #{language}, #{targets}>"
    end

    def target(&block)
      Target.new do |target|
        block.call(target)
      end
    end

    def macos(version, search_paths = nil)
      Platform.new(:macos, version, search_paths)
    end

    def ios(version, search_paths = nil)
      Platform.new(:ios, version, search_paths)
    end

    def tvos(version, search_paths = nil)
      Platform.new(:tvos, version, search_paths)
    end

    def watchos(version, search_paths = nil)
      Platform.new(:watchos, version, search_paths)
    end

    def swift(version)
      Language.new(:swift, version)
    end

    def objc
      Language.new(:objc, nil)
    end

  end
end
