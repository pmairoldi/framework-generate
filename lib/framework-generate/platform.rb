module FrameworkGenerate
  class Platform
    attr_accessor :type, :minimum_version, :search_paths

    def initialize(type = nil, minimum_version = nil, search_paths = nil)
      @type = type
      @minimum_version = minimum_version
      @search_paths = search_paths == nil ? default_search_paths : search_paths

      yield(self) if block_given?
    end

    def to_s
      "Platform<#{type}, #{minimum_version}, #{search_paths}>"
    end

    def self.supported_platforms(platforms, is_test_target = false)
      platforms
          .reject { |platform| is_test_target && platform.type == :watchos }
          .map { |platform| platform.raw_values }
          .join(' ')
    end

    def self.find_platform(platforms, type)
      platforms.find { |platform| platform.type == type }
    end

    def self.deployment_target(platforms, type)
      find_platform(platforms, type).minimum_version
    end

    def self.search_paths(platforms, type)
      find_platform(platforms, type).search_paths
    end

    def raw_values
      case @type
      when :macos
        'macosx'
      when :ios
        'iphoneos iphonesimulator'
      when :tvos
        'appletvos appletvsimulator'
      when :watchos
        'watchos watchsimulator'
      else
        abort 'platform not supported!'
      end
    end

    def default_search_paths
      case @type
      when :macos
        '$(SRCROOT)/Carthage/Build/Mac/ $(inherited)'
      when :ios
        '$(SRCROOT)/Carthage/Build/iOS/ $(inherited)'
      when :tvos
        '$(SRCROOT)/Carthage/Build/tvOS/ $(inherited)'
      when :watchos
        '$(SRCROOT)/Carthage/Build/watchOS/ $(inherited)'
      else
        abort 'platform not supported!'
      end
    end
  end
end
