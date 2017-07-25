require 'xcodeproj'

module FrameworkGenerate
  class Project
    attr_accessor :name, :targets, :scripts_directory

    def initialize(name = nil, targets = nil, scripts_directory = nil)
      @name = name
      @targets = targets
      @scripts_directory = scripts_directory

      yield(self) if block_given?
    end

    def project
      yield(self) if block_given?
      self
    end

    def to_s
      "Project<#{name}, #{targets}>"
    end

    # DSL
    def new_target
      Target.new do |target|
        yield(target)
      end
    end

    def new_platform
      Platform.new do |platform|
        yield(platform)
      end
    end

    def new_language
      Language.new do |language|
        yield(language)
      end
    end

    def new_script
      Script.new do |script|
        yield(script)
      end
    end

    # sugar
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
      return @name if File.extname(@name) == '.xcodeproj'

      "#{@name}.xcodeproj"
    end

    def general_build_settings(settings)
      settings['SDKROOT'] = 'macosx'
      settings['TARGETED_DEVICE_FAMILY'] = '1,2,3,4'
      settings['CODE_SIGN_IDENTITY'] = ''
      settings['COMBINE_HIDPI_IMAGES'] = 'YES'
      settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
      settings['CLANG_WARN_INFINITE_RECURSION'] = 'YES'
      settings['CLANG_WARN_SUSPICIOUS_MOVE'] = 'YES'
      settings['ENABLE_STRICT_OBJC_MSGSEND'] = 'YES'
      settings['GCC_NO_COMMON_BLOCKS'] = 'YES'
      settings['CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING'] = 'YES'
      settings['CLANG_WARN_COMMA'] = 'YES'
      settings['CLANG_WARN_NON_LITERAL_NULL_CONVERSION'] = 'YES'
      settings['CLANG_WARN_OBJC_LITERAL_CONVERSION'] = 'YES'
      settings['CLANG_WARN_RANGE_LOOP_ANALYSIS'] = 'YES'
      settings['CLANG_WARN_STRICT_PROTOTYPES'] = 'YES'

      settings
    end

    def test_build_settings(settings)
      settings['LD_RUNPATH_SEARCH_PATHS'] = '$(inherited) @executable_path/Frameworks @loader_path/Frameworks'
      settings['LD_RUNPATH_SEARCH_PATHS[sdk=macosx*]'] = '$(inherited) @executable_path/../Frameworks @loader_path/../Frameworks'

      settings
    end

    def target_with_name(project, name)
      project.native_targets.detect { |e| e.name == name }
    end

    def generate
      project = Xcodeproj::Project.new(project_path)

      schemes_dir = Xcodeproj::XCScheme.user_data_dir(project.path)
      FileUtils.rm_rf(schemes_dir)
      FileUtils.mkdir_p(schemes_dir)

      xcschememanagement = {}
      xcschememanagement['SchemeUserState'] = {}
      xcschememanagement['SuppressBuildableAutocreation'] = {}

      project.build_configurations.each do |configuration|
        general_build_settings(configuration.build_settings)
      end

      @targets.each do |target|
        target.create(project, target.language, @scripts_directory)
      end

      @targets.each do |target|
        scheme = Xcodeproj::XCScheme.new

        created_target = target_with_name(project, target.name)

        scheme.add_build_target(created_target)

        if created_target.test_target_type?
          scheme.add_test_target(created_target)
        end

        unless target.test_target.nil?
          created_test_target = target_with_name(project, target.test_target.name)

          created_test_target.add_dependency(created_target)

          scheme.add_test_target(created_test_target)
        end

        unless scheme.test_action.nil?
          scheme.test_action.code_coverage_enabled = target.enable_code_coverage
        end

        scheme.save_as(project.path, target.name, true)
        xcschememanagement['SchemeUserState']["#{target.name}.xcscheme"] = {}
        xcschememanagement['SchemeUserState']["#{target.name}.xcscheme"]['isShown'] = true
      end

      project.native_targets.each do |target|
        next unless target.test_target_type?
        target.build_configurations.each do |configuration|
          test_build_settings(configuration.build_settings)
        end
      end

      xcschememanagement_path = schemes_dir + 'xcschememanagement.plist'
      Xcodeproj::Plist.write_to_path(xcschememanagement, xcschememanagement_path)

      project.save

      puts "Successfully generated #{project_path}"
    end
  end
end
