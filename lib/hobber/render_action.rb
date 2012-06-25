require 'hobber/renderable_object'

module Hobber
  class RenderAction
    def initialize robjects, &block
      @robjects      = robjects
      @tmpl_vars     = {}
      @layout        = []
      @rewrite_paths = []

      if block
        block.arity <= 0 ? instance_eval(&block) : block.call(self)
      end
    end

    def layout robject
      raise ArgumentError.new('Expected RenderableObject as a layout') unless robject.is_a?(RenderableObject)
      @layout << robject
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
      result = ""
      @robjects.each do |ro|
        tmpl_vars = {}
        tmpl_vars.merge(ro.tmpl_vars)

        result = ro.render(tmpl_vars)

        render_chain = @layout.reverse
        render_chain.each do |layout|
          tmpl_vars = layout.tmpl_vars.merge(tmpl_vars)
          result = layout.render(tmpl_vars) { result }
        end
      end
      result
    end
  end
end
