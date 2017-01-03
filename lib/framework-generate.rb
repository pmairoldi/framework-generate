module FrameworkGenerate
  class Runner
    def self.generate(framework)
      framework.to_s
    end
  end

  autoload :Project, 'framework-generate/project'
  autoload :Language, 'framework-generate/language'
  autoload :Platform, 'framework-generate/platform'
  autoload :Target, 'framework-generate/target'
end
