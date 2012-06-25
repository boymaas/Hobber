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

    context "#tmpl_vars" do
      context "whithout tmpl_vars specified" do
        subject { described_class.new('spec/source/posts/2012-01-01-post001.mkd') }
        it "now just returns an empty hash" do
          subject.tmpl_vars.should == {}
        end
      end
      context "with one tmpl_vars specified" do
        subject do
          described_class.new('path_to_template.mkd') {
            <<-EOS.gsub(/^\s{12}/, '')
              ---
              title: a title
              ---

              # Title
            EOS
          } 
        end
        it "returns the template vars" do
          subject.tmpl_vars.should == {
            'title' => 'a title',
          }
        end
      end
      context "with tmpl_vars specified" do
        subject do
          described_class.new('path_to_template.mkd') {
            <<-EOS.gsub(/^\s{12}/, '')
              ---
              title: a title
              author: a author
              tags: 
                - tag1 
                - tag2 
                - tag3
              ---

              # Title

            EOS
          } 
        end
        it "returns the template vars" do
          subject.tmpl_vars.should == {
            'title' => 'a title',
            'author' => 'a author',
            'tags' => ['tag1', 'tag2', 'tag3']
          }
        end
      end
      context "with incorrect yaml specified" do
        subject do
          described_class.new('path_to_template.mkd') {
            <<-EOS.gsub(/^\s{12}/, '')
              ---
              title: a title
              author: a author
              wong-yaml-stuff-in-here
              tags: 
                - tag1 
                - tag2 
                - tag3
              ---

              # Title

            EOS
          } 
        end
        it "raises an appropiate error" do
          expect {
            subject.tmpl_vars
          }.to raise_error {|e|
            e.should be_an(ProblemParsingYaml)
            e.message.should include("path_to_template.mkd") 
          }
        end
      end
    end
  end
end
