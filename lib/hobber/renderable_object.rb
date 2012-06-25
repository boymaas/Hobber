require 'tilt'

module Hobber
  class RenderableObject
    attr_reader :path

    def initialize(path)
      @path = path 
    end

    def render(vars={})
      ctx = vars.fetch(:binding, Object.new)
      unless Tilt[@path]
        return File.read(@path)
      end
      @template ||= Tilt.new(@path)
      @template.render(ctx, vars)
    end
  end
end
