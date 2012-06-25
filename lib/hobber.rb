require "hobber/version"

require 'hobber/renderable_object'

module Hobber
  def chdir path
    Dir.chdir(path)
  end
  
  def scan glob
    Dir[glob].map { |p| RenderableObject.new(p) }
  end

  def file path
  end

  def render robject, opts={}
  end
end
