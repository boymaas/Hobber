require 'hobber'

describe Hobber do
  before { extend Hobber }

  context "#scan" do
    let(:robjects) { scan "spec/source/posts/*"  }
    context "when dir is full" do
      specify { robjects.should be_an(Array) }
      specify { robjects.first.should be_an(RenderableObject) }
      specify { robjects.first.path.should == 'spec/source/posts/2012-01-01-post001.mkd' }
    end
  end
end
