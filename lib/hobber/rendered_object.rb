module Hobber
  class RenderedObject
    attr_reader :data, :path, :url, :renderable_object

    def initialize opts={}
      @data = opts.fetch(:data)
      @renderable_object = opts.fetch(:renderable_object)
      @path = opts.fetch(:path)
      @layouts = opts.fetch(:layouts)
      @url = opts.fetch(:url)
    end

    def [](key)
      @renderable_object.tmpl_vars.fetch(key)
    end

  end
end
