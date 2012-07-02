require 'yaml'
require 'active_support/core_ext/hash/indifferent_access'
require 'hobber/renderer/tilt'

module Hobber
  class ProblemParsingYaml < RuntimeError; end
  class RenderError < RuntimeError; end
  class RenderableObject
    attr_reader :path, :data, :renderer

    def initialize(path, a_renderer=nil)
      @path = path 
      @data = yield(self) if block_given?
      @renderer = a_renderer
    end

    def data
      @data ||= File.read(@path)
    end

    def renderer
      @renderer ||= Renderer::Tilt.new(path, data)
    end

    def render(vars={}, ctx=Object.new, &block)
      renderer.render(path, data, ctx, tmpl_vars.merge(vars), &block)
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


    def tmpl_vars
      @tmpl_vars ||= _extract_tmpl_vars
    end

    def _extract_tmpl_vars
      @tmpl_vars = {}
      if data.match(/\s*---.*---/m)
        ignore, yaml_buffer, template_data = data.split(/---/,3)
        @data = template_data
        @tmpl_vars = YAML.parse(yaml_buffer).to_ruby
      end
      HashWithIndifferentAccess.new(@tmpl_vars)
    rescue Psych::SyntaxError => e
      raise ProblemParsingYaml.new([e.message, "while trying to extract tmpl_vars from [#{path}]"] * " -- ")
    end
  end
end
