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

    def perform
      @robjects.each do |ro|
        puts "Rendering #{ro.path}" 
      end
    end
  end
end
