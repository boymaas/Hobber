require 'thor'
require 'fileutils'

module Hobber
  class RenderedObjectSaver
    include FileUtils
    def initialize(rendered_object)
      @rendered_object = rendered_object 
    end

    def save
      path_name = Pathname.new( @rendered_object.path )
      # mkdir_p path_name.dirname
    end
  end
end
