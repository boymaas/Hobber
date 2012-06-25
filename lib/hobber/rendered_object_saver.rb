require 'thor'
require 'fileutils'

module Hobber
  class RenderedObjectSaver
    include FileUtils
    include Thor::Shell

    def initialize(rendered_object)
      @rendered_object = rendered_object 
    end

    def save
      path_name = Pathname.new(@rendered_object.path)
      mkdir_p(path_name.dirname)
      unless file_collision(path_name)
        return
      end

      File.open(@rendered_object.path, 'w') do |f|
        f.write(@rendered_object.data)
      end
    end
  end
end
