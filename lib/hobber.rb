require "hobber/version"
require 'hobber/renderable_object'
require 'hobber/render_action'

module Hobber
  def chdir path
    Dir.chdir(path)
  end
  
  def scan glob
    Dir[glob].map { |p| RenderableObject.new(p) }
  end

  def file path
    RenderableObject.new(path)
  end

  def render robjects, opts={}, &block
    RenderAction.new(robjects.to_a, &block).perform
  end
end
