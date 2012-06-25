require 'hobber/render_action'

module Hobber
  describe RenderAction do 
    subject {described_class.new([])}
    let(:robject) { stub(:robject) }
    context "#layout" do
      it "adds a layout" do
        subject.layout robject
      end
      it "raises when adding something other than RenderableObject" do
        expect {
          subject.layout Object.new
        }.to raise_error(ArgumentError)
      end
    end
  end
end
