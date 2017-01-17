module FrameworkGenerate
  class Runner
    def self.generate
      file_path = "#{Dir.pwd}/FrameworkSpec"

      unless File.exist?(file_path)
        abort "Couldn't find FrameworkSpec"
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
