require 'tilt'

module Hobber
  class RenderableObject
    attr_reader :path

    def initialize(path)
      @path = path 
    end

    def render(vars={})
      context = vars.fetch(:binding, Object.new)
      data = File.read(@path)
      _render_template_chain(@path, data, context, vars)
    end
    
    def to_a
      [self]
    end

    private

    def _render_template_chain(path, data, context, vars)
      # termination condition, if tilt template class
      # is  
      tilt_template_class = Tilt[path]
      unless tilt_template_class
        return data
      end

      template = tilt_template_class.new(@path) { |t| data }

      # remove extention
      path = path.gsub(/\.\w+$/,'')
      data = template.render(context, vars)

      # iterate again to next available template 
      # engine
      _render_template_chain(path, data, context, vars)
    end
  end
end
