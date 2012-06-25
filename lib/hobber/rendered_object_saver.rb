require 'thor'
require 'fileutils'
require 'logger'

module Hobber
  class RenderedObjectSaver
    include FileUtils
    include Thor::Shell

    def initialize(rendered_object, safe_mode=false, logger=Logger.new(STDOUT))
      @rendered_object = rendered_object 
      @safe_mode = safe_mode 
      @logger = logger
    end

    def save
      path_name = Pathname.new(@rendered_object.path)
      if @safe_mode && path_name.exist? && !file_collision(path_name)
        return
      end

      mkdir_p(path_name.dirname)

      @logger.info("writing target [#{path_name}] ..")
      File.open(@rendered_object.path, 'w') do |f|
        f.write(@rendered_object.data)
      end
    end
  end
end
