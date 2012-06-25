require "hobber/version"
require 'hobber/renderable_object'
require 'hobber/rendered_object_saver'
require 'hobber/render_action'

module Hobber
  def chdir path, &block
    Dir.chdir(path, &block)
  end
  
  def scan glob
    Dir[glob].map { |p| RenderableObject.new(p) }
  end

  def file path
    RenderableObject.new(path)
  end

  def render robjects, opts={}, &block
    rv = RenderAction.new(robjects.to_a, &block).perform
    robjects.is_a?(Array) ? rv : rv.first
  end

  def save *args
    args.flatten.map { |rendered_object|
      RenderedObjectSaver.new(rendered_object).save
    }
  end
end
