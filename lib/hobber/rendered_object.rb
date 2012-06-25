module Hobber
  class RenderedObject
    attr_reader :data

    def initialize opts={}
      @data = opts.fetch(:data)
      @renderable_object = opts.fetch(:renderable_object)
      @path = opts.fetch(:path)
    end

  end
end
