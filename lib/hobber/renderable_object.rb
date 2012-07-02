require 'tilt'
require 'yaml'
require 'active_support/core_ext/hash/indifferent_access'

module Hobber
  class ProblemParsingYaml < RuntimeError; end
  class RenderError < RuntimeError; end
  class RenderableObject
    attr_reader :path, :data

    def initialize(path)
      @path = path 
      @data = yield(self) if block_given?
    end

    def render(vars={}, context=Object.new, &block)
      _render_template_chain(@path, data, context, vars, &block)
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

    def data
      @data ||= File.read(@path)
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

    private

    def _render_template_chain(path, data, context, vars, &block)
      # termination condition, if tilt template class
      # is  
      tilt_template_class = Tilt[path]
      unless tilt_template_class
        return data
      end

      template = tilt_template_class.new(@path) { |t| data }

      # remove extention
      path = path.gsub(/\.\w+$/,'')
      data = template.render(context, vars, &block)

      # iterate again to next available template 
      # engine
      _render_template_chain(path, data, context, vars, &block)
    rescue => e
      render_error = RenderError.new("#{self.class}: While rendering #{path} with #{tilt_template_class}: #{e.message}")
      render_error.set_backtrace(e.backtrace)
      raise render_error 
    end
  end
end
