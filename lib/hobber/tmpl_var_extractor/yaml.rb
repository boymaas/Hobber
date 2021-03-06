require 'yaml'
require 'active_support/core_ext/hash/indifferent_access'

module Hobber
  class ProblemParsingYaml < RuntimeError; end
  module TmplVarExtractor
    class Yaml
      attr_reader :combined_content, :tmpl_content, :tmpl_vars

      def initialize(combined_content, path=nil)
        @combined_content = combined_content
        @path = path

        @tmpl_content = combined_content
        @tmpl_vars = {}
        extract
      end

      def extract
        @tmpl_vars = {}
        if @combined_content.match(/\s*---.*---/m)
          ignore, yaml_buffer, tmpl_content = @combined_content.split(/---/,3)
          @tmpl_content = tmpl_content
          @tmpl_vars = YAML.parse(yaml_buffer).to_ruby
          @tmpl_vars = HashWithIndifferentAccess.new(@tmpl_vars)
        end
      # rescue Psych::SyntaxError => e
      rescue => e
        debugger
        error = ProblemParsingYaml.new(["#{e.message} (#{e.class})", "while trying to extract tmpl_vars from [#{@path}]"] * " -- ")
        error.set_backtrace(e.backtrace)
        raise error
      end
    end
  end
end
