require 'hobber/rendered_object'

module Hobber
  describe RenderedObject do
    context "#initialize" do
      it "works" do
        described_class.new(
          :data=>:data,
          :renderable_object=>:renderable_object,
          :path=>:path)
      end
    end
  end
end
