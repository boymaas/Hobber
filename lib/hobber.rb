require 'fileutils'
require 'thor'
require 'logger'
require 'active_support/core_ext/hash/indifferent_access'

require "hobber/version"
require 'hobber/renderable_object'
require 'hobber/rendered_object_saver'
require 'hobber/render_action'

require 'yaml'
require 'sprockets'

module Hobber
  include Thor::Shell
  include FileUtils

  def assets
    @assets ||= Sprockets::Environment.new
  end

  def load_yaml_config path
    HashWithIndifferentAccess.new(YAML.load_file(path))
  end

  def default_tmpl_vars vars
    @default_tmpl_vars ||= {}
    @default_tmpl_vars.merge!(vars)
  end

  def default_rewrite_path *args
    @default_rewrite_paths ||= []
    @default_rewrite_paths << args
  end

  def default_rewrite_url *args
    @default_rewrite_urls ||= []
    @default_rewrite_urls << args
  end

  def remove_output_dir dirname, options={}
    safe_mode = options.fetch(:safe, false)

    dirname = Pathname.new(dirname)
    if safe_mode && no?("Do you want to remove output dir [#{dirname.realpath}]? (y/yes/other=no)")
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
    render_action = RenderAction.new(robjects.to_a, block.binding, &block)
    if render_action.rewrite_paths.empty?
      @default_rewrite_paths && @default_rewrite_paths.map { |args| render_action.rewrite_path *args }
    end
    if render_action.rewrite_urls.empty?
      @default_rewrite_urls && @default_rewrite_urls.map { |args| render_action.rewrite_url *args }
    end
    if @default_tmpl_vars
      render_action.tmpl_vars @default_tmpl_vars.merge(render_action.tmpl_vars)
    end
    rendered_objects = render_action.perform
    robjects.is_a?(Array) ? rendered_objects : rendered_objects.first
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
