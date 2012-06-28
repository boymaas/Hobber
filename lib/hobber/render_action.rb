require 'hobber/renderable_object'
require 'hobber/rendered_object'

module Hobber
  class RenderAction
    attr_accessor :rewrite_paths
    attr_accessor :rewrite_urls

    def initialize robjects, binding=nil, &block
      @robjects         = robjects
      @tmpl_vars        = {}
      @layouts          = []
      @rewrite_paths    = []
      @rewrite_urls    = []
      @target_extention = nil
      @caller_binding = binding || ( block && block.binding )

      if block
        block.arity <= 0 ? instance_eval(&block) : block.call(self)
      end
    end

    def layout *robjects
      robjects.each do |robject|
        raise ArgumentError.new('Expected RenderableObject as a layout') unless robject.is_a?(RenderableObject)
      end
      @layouts.concat  robjects
    end

    def tmpl_vars vars=[]
      if vars.empty?
        return @tmpl_vars
      end
      @tmpl_vars.merge!(vars)
    end

    def _parse_rewrite_args *args
      if args.count == 1 && args[0].is_a?(Hash)
        regexp, replacement = args[0].keys.first, args[0].values.first 
      elsif args.count == 2
        regexp, replacement = args 
      else
        raise ArgumentError.new('[rewrite_path] Expected either [regexp => sub] or [regexp, replacement] as arguments')
      end
      return regexp, replacement
    end

    def rewrite_path *args
      regexp, replacement = _parse_rewrite_args(*args)
      @rewrite_paths << [regexp, replacement]
    end

    def rewrite_url *args
      regexp, replacement = _parse_rewrite_args(*args)
      @rewrite_urls << [regexp, replacement]
    end

    def target_extention ext
      @target_extention = ext.to_s
    end

    # Performs the render actions by 
    # iterating over robjects with
    # the specified configuration
    def perform
      @robjects.map do |ro|
        RenderedObject.new(
          :data=>_render_renderable_object(ro, { :item => ro }.merge(@tmpl_vars), @layouts),
          :renderable_object=>ro,
          :layouts=> @layouts,
          :path=>_rewrite_paths(ro.path, @rewrite_paths),
          :url=>_rewrite_paths(ro.path, @rewrite_urls))
      end
    end

    protected

    def _render_renderable_object ro, tmpl_vars={}, layouts=[]
        tmpl_vars.merge!(ro.tmpl_vars)
        tmpl_vars.merge!(:current_renderable_object => ro)

        result = ro.render(tmpl_vars, @caller_binding)

        render_chain = layouts.reverse
        render_chain.each do |layout|
          tmpl_vars = layout.tmpl_vars.merge(tmpl_vars)
          result = layout.render(tmpl_vars, @caller_binding) { result }
        end
        result
    end

    def _rewrite_paths path, rewrites
      target_path = path.dup
      rewrites.each do |regexp, replacement|
        target_path.gsub!(regexp, replacement)
      end

      if @target_extention
        target_path.gsub!(/\..*?$/, ".#{@target_extention}")
      end

      target_path
    end
  end
end
