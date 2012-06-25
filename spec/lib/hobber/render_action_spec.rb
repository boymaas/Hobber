require 'hobber/renderable_object'
require 'hobber/render_action'

module Hobber
  describe RenderAction do 
    subject {described_class.new([])}
    context "#layout" do
      it "adds a layout" do
        robject = RenderableObject.new('a_path')
        subject.layout robject
      end
      it "raises when adding something other than RenderableObject" do
        expect {
          subject.layout Object.new
        }.to raise_error(ArgumentError)
      end
    end

    context "#perform" do
      let(:layout) do RenderableObject.new('source_path/to/layout.mkd.erb') do
        <<-EOS.gsub(/^\s{10}/, '')
          ---
          title: a title
          ---
          # Title: <%= title %>

          <%= yield %>
        EOS
      end
      end
      let(:content) do RenderableObject.new('source_path/to/content.txt') do
        <<-EOS.gsub(/^\s{10}/, '')
          ---
          title: a overridden title
          ---
          just some content
        EOS
      end
      end

      it "overrides and renders layout and content templates" do
        render_action = RenderAction.new([content])
        render_action.layout(layout)

        render_action.rewrite_path(/^source_path/, 'inter_path')
        render_action.rewrite_path(/^inter_path/, 'target_path')
        render_action.target_extention(:html)

        array_of_rendered_objects = render_action.perform
        array_of_rendered_objects.should be_an(Array)

        rendered_object = array_of_rendered_objects.first
        rendered_object.should be_an(RenderedObject)
        rendered_object.data.should == <<-EOS.gsub(/^\s{10}/, '')
          <h1>Title: a overridden title</h1>
          
          <p>just some content</p>
        EOS
        rendered_object.path.should == 'target_path/to/content.html'
      end
    end
  end
end
