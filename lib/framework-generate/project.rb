require 'xcodeproj'

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

    # DSL
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

    # Interface
    def project_path
      if File.extname(@name) == '.xcodeproj'
        return @name
      end

      "#{@name}.xcodeproj"
    end

    def general_build_settings(settings)
      settings['SDKROOT'] = 'macosx'
      settings['SUPPORTED_PLATFORMS'] = FrameworkGenerate::Platform::supported_platforms(@platforms)
      settings['TARGETED_DEVICE_FAMILY'] = '1,2,3,4'
      settings['MACOSX_DEPLOYMENT_TARGET'] = FrameworkGenerate::Platform::deployment_target(@platforms, :macos)
      settings['IPHONEOS_DEPLOYMENT_TARGET'] = FrameworkGenerate::Platform::deployment_target(@platforms, :ios)
      settings['TVOS_DEPLOYMENT_TARGET'] = FrameworkGenerate::Platform::deployment_target(@platforms, :tvos)
      settings['WATCHOS_DEPLOYMENT_TARGET'] = FrameworkGenerate::Platform::deployment_target(@platforms, :watchos)
      settings['CODE_SIGN_IDENTITY'] = ''
      settings['COMBINE_HIDPI_IMAGES'] = 'YES'
      settings['FRAMEWORK_SEARCH_PATHS[sdk=macosx*]'] = FrameworkGenerate::Platform::search_paths(@platforms, :macos)
      settings['FRAMEWORK_SEARCH_PATHS[sdk=iphone*]'] = FrameworkGenerate::Platform::search_paths(@platforms, :ios)
      settings['FRAMEWORK_SEARCH_PATHS[sdk=appletv*]'] = FrameworkGenerate::Platform::search_paths(@platforms, :tvos)
      settings['FRAMEWORK_SEARCH_PATHS[sdk=watch*]'] = FrameworkGenerate::Platform::search_paths(@platforms, :watchos)
      settings['SWIFT_VERSION'] = @language.version
      settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
      settings['CLANG_WARN_INFINITE_RECURSION'] = 'YES'
      settings['CLANG_WARN_SUSPICIOUS_MOVE'] = 'YES'
      settings['ENABLE_STRICT_OBJC_MSGSEND'] = 'YES'
      settings['GCC_NO_COMMON_BLOCKS'] = 'YES'

      settings
    end

    def test_build_settings(settings)
      settings['SUPPORTED_PLATFORMS'] = FrameworkGenerate::Platform::supported_platforms(@platforms, true)

      settings['LD_RUNPATH_SEARCH_PATHS'] = '$(inherited) @executable_path/Frameworks @loader_path/Frameworks'
      settings['LD_RUNPATH_SEARCH_PATHS[sdk=macosx*]'] = '$(inherited) @executable_path/../Frameworks @loader_path/../Frameworks'

      settings
    end


    def share_schemes(project)
      user_scheme_dir = Xcodeproj::XCScheme.user_data_dir(project.path)

      Dir[File.join(user_scheme_dir, '*.xcscheme')].map do |scheme_path|

        scheme_extension = File.extname scheme_path
        scheme_name = File.basename scheme_path, scheme_extension

        Xcodeproj::XCScheme.share_scheme(project.path, scheme_name)
      end
    end

    def generate

      project = Xcodeproj::Project.new(project_path)

      project.build_configurations.each do |configuration|
        general_build_settings(configuration.build_settings)
      end

      @targets.each do |target|
        created_target = target.create(project, language)

        if target.test_target != nil
          created_test_target = target.test_target.create(project, language)
          created_test_target.add_dependency(created_target)
        end
      end

      project.native_targets.each do |target|
        next unless target.test_target_type?
        target.build_configurations.each do |configuration|
          test_build_settings(configuration.build_settings)
        end
      end

      share_schemes(project)
      project.save

      puts "Successfully generated #{project_path}"
    end

  end
end