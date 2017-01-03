module FrameworkGenerate
  class Target
    attr_accessor :name, :info_plist, :bundle_id, :header, :include_files, :exclude_files, :dependencies

    def initialize(name = nil, info_plist = nil, bundle_id = nil, header = nil, include_files = nil, exclude_files = nil, dependencies = nil)
      @name = name
      @info_plist = info_plist
      @bundle_id = bundle_id
      @header = header
      @include_files = include_files
      @exclude_files = exclude_files
      @dependencies = dependencies

      yield(self) if block_given?
    end

    def to_s
      "Target<#{name}, #{info_plist}, #{bundle_id}, #{header}, #{include_files}, #{exclude_files}, #{dependencies}>"
    end
  end
end
