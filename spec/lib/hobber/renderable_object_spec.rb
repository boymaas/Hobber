require 'hobber/renderable_object'

module Hobber
  describe RenderableObject do
    context "plain html" do
      subject { described_class.new('spec/source/posts/2012-01-01-post002.html') }
      it "renders" do
        subject.render.should include('<h1>Post002</h1>')
      end
    end

    context "markdown" do
      subject { described_class.new('spec/source/posts/2012-01-01-post001.mkd') }

      it "renders" do
        subject.render.should include('<h1>Title</h1>')
      end
    end

    context "erb markdown" do
      subject { described_class.new('spec/source/posts/2012-01-01-post001.mkd.erb') }
      it "renders" do
        subject.render(:a_var=>:for_example).should include('<h1>Title for_example</h1>')
      end
    end
  end
end
