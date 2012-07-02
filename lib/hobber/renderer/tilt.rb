require 'tilt'

module Hobber
  module Renderer
    class Tilt
      def render(path, data, context, vars, &block)
        # termination condition, if tilt template class
        # is  
        tilt_template_class = ::Tilt[path]
        unless tilt_template_class
          return data
        end

        template = tilt_template_class.new(path) { |t| data }

        # remove extention
        path = path.gsub(/\.\w+$/,'')
        data = template.render(context, vars, &block)

        # iterate again to next available template 
        # engine
        render(path, data, context, vars, &block)
      rescue => e
        render_error = RenderError.new("#{self.class}: While rendering #{path} with #{tilt_template_class}: #{e.message}")
        render_error.set_backtrace(e.backtrace)
        raise render_error 
      end
    end
  end
end
