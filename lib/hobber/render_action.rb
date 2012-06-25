require 'hobber/renderable_object'
require 'hobber/rendered_object'

module Hobber
  class RenderAction
    def initialize robjects, &block
      @robjects      = robjects
      @tmpl_vars     = {}
      @layouts        = []
      @rewrite_paths = []

      if block
        block.arity <= 0 ? instance_eval(&block) : block.call(self)
      end
    end

    def layout robject
      raise ArgumentError.new('Expected RenderableObject as a layout') unless robject.is_a?(RenderableObject)
      @layouts << robject
    end

    def tmpl_vars vars
      @tmpl_vars.merge!(vars)
    end

    def rewrite_path regexp, replacement
      @rewrite_paths = [regexp, replacement]
    end

    # Performs the render actions by 
    # iterating over robjects with
    # the specified configuration
    def perform
      rendered_objects = 
        @robjects.map do |ro|
        RenderedObject.new(
          :data=>render_renderable_object(ro, @layouts),
          :renderable_object=>ro,
          :path=>rewrite_path(ro.path, @rewrite_paths))
      end
    end

    protected

    def render_renderable_object ro, layouts=[]
        tmpl_vars = {}
        tmpl_vars.merge(ro.tmpl_vars)

        result = ro.render(tmpl_vars)

        render_chain = layouts.reverse
        render_chain.each do |layout|
          tmpl_vars = layout.tmpl_vars.merge(tmpl_vars)
          result = layout.render(tmpl_vars) { result }
        end
        result
    end

    def rewrite_paths path, rewrites
      target_path = path.dup
      rewrites.each do |regexp, replacement|
        target_path.gsub!(regexp, replacement)
      end
      target_paths
    end
  end
end
