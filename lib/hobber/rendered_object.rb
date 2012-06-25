module Hobber
  class RenderedObject
    attr_reader :data, :path

    def initialize opts={}
      @data = opts.fetch(:data)
      @renderable_object = opts.fetch(:renderable_object)
      @path = opts.fetch(:path)
      @layouts = opts.fetch(:layouts)
    end

  end
end
