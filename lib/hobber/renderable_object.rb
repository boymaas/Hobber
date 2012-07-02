require 'hobber/renderer/tilt'
require 'hobber/tmpl_var_extractor/yaml'

module Hobber
  class RenderError < RuntimeError; end

  class RenderableObject
    attr_reader :path, :tmpl_content, :renderer

    def initialize(path, a_renderer=nil, a_tmpl_var_extractor=nil)
      @path         = path
      @tmpl_content = block_given? ? yield(self) : File.read(@path)

      @renderer           = a_renderer           || Renderer::Tilt.new
      @tmpl_var_extractor = a_tmpl_var_extractor || TmplVarExtractor::Yaml.new(@tmpl_content, @path)
    end

    def render(vars={}, ctx=Object.new, &block)
      @renderer.render(path, tmpl_content, ctx, tmpl_vars.merge(vars), &block)
    end

    def to_a
      [self]
    end

    def [](key)
      tmpl_vars[key]
    end

    def fetch(*a)
      tmpl_vars.fetch(*a)
    end

    def tmpl_content
      @tmpl_var_extractor.tmpl_content
    end

    def tmpl_vars
      @tmpl_var_extractor.tmpl_vars
    end
  end
end
