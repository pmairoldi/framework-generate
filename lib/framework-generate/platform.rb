module FrameworkGenerate
  class Platform
    attr_accessor :type, :minimum_version, :search_paths

    def initialize(type = nil, minimum_version = nil, search_paths = nil)
      @type = type
      @minimum_version = minimum_version
      @search_paths = search_paths == nil ? default_search_paths(type) : search_paths

      yield(self) if block_given?
    end

    def to_s
      "Platform<#{type}, #{minimum_version}>"
    end

    def platform_values(type)
      case type
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

    def default_search_paths(type)
      case type
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
