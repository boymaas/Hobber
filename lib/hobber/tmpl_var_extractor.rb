module Hobber
  class ProblemParsingYaml < RuntimeError; end
  class TmplVarExtractor
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
    rescue Psych::SyntaxError => e
      raise ProblemParsingYaml.new([e.message, "while trying to extract tmpl_vars from [#{@path}]"] * " -- ")
    end
  end
end
