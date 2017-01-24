require 'fileutils'

module FrameworkGenerate
  class Runner
    def self.generate
      file_path = "#{Dir.pwd}/FrameworkSpec"

      unless File.exist?(file_path)
        puts "Couldn't find FrameworkSpec. Do you want to create one? [Y/N]"
        create_file = gets.chomp

        if create_file == "Y"
          sample_framework_spec = File.join(File.dirname(__FILE__), 'SampleFrameworkSpec')

          FileUtils.cp(sample_framework_spec, file_path)

          raise "Created a FrameworkSpec. Update the contents of the FrameworkSpec file and rerun the command"
        elsif
          raise "Cannot create a project without a FrameworkSpec"
        end
      end

      file_contents = File.read(file_path)

      project = FrameworkGenerate::Project.new
      project.instance_eval(file_contents, file_path)

      project.generate
    end
  end

  autoload :Project, 'framework-generate/project'
  autoload :Language, 'framework-generate/language'
  autoload :Platform, 'framework-generate/platform'
  autoload :Target, 'framework-generate/target'
  autoload :Script, 'framework-generate/script'
end
