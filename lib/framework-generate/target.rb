module FrameworkGenerate
  class Target

    attr_accessor :name, :info_plist, :bundle_id, :header, :include_files, :exclude_files, :dependencies

    def initialize(name, info_plist, bundle_id, header, include_files, exclude_files, dependencies)
      @name = name
      @info_plist = info_plist
      @bundle_id = bundle_id
      @header = header
      @include_files = include_files
      @exclude_files = exclude_files
      @dependencies = dependencies
    end

  end
end
