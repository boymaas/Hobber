require 'fileutils'
require 'thor'
require 'logger'

require "hobber/version"
require 'hobber/renderable_object'
require 'hobber/rendered_object_saver'
require 'hobber/render_action'

module Hobber
  class Shell
    include Thor::Shell
  end

  def shell
    @shell ||= Shell.new
  end

  def remove_output_dir dirname, options={}
    safe_mode = options.fetch(:safe, false)

    dirname = Pathname.new(dirname)
    if safe_mode && shell.no?("Do you want to remove output dir [#{dirname.realpath}]? (y/yes/other=no)")
      return
    end
    FileUtils.rm_r dirname.realpath
  rescue Errno::ENOENT
    # directory does not resolve
  end

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
    options = args.last.is_a?(Hash) ? args.pop : {}
    logger  = options.fetch(:logger, Logger.new(STDOUT))
    safe_mode = options.fetch(:safe, false)
    args.flatten.map { |rendered_object|
      RenderedObjectSaver.new(rendered_object, safe_mode, logger).save
    }
  end
end
