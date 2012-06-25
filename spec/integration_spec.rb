require 'hobber'

describe "hobber renders a blog" do
  before { extend Hobber }
  before { chdir 'spec/miniblog' }
  after  { chdir '../..' }

  let(:shell) { stub(:shell) }

  before do
    Hobber.stub(:shell => shell)
    shell.stub(:yes?).and_return(true)

    remove_output_dir 'output'

    blog_posts   = scan 'source/posts/**/*'
    index_page   = file 'source/index.haml'
    main_layout  = file 'source/layout/main.haml'
    index_layout = file 'source/layout/index.haml'
    post_layout  = file 'source/layout/post.haml'

    rendered_blog_posts = render blog_posts do
      layout        main_layout
      layout        post_layout
      rewrite_path  %r|^source|, 'output'
      target_extention :html
    end

    rendered_home_page = render index_page do
      layout        main_layout
      layout        index_layout
      rewrite_path  %r|^source|, 'output'
      tmpl_vars     :blog_posts => rendered_blog_posts
      target_extention :html
    end

    @rendered_blog_posts = rendered_blog_posts
    @rendered_home_page  = rendered_home_page

    save [rendered_home_page, rendered_blog_posts], :logger => stub(:logger).as_null_object
  end

  it "renders 4 blog posts" do
    @rendered_blog_posts.should be_an(Array)
    @rendered_blog_posts.count.should == 4
  end

  it "first blogpost has correct content" do
    first_blog_post = @rendered_blog_posts.first
    first_blog_post.data.should include('html')
    first_blog_post.data.should include('body')
    first_blog_post.data.should include('Title post 001')
    first_blog_post.data.should include('Post layout')
    first_blog_post.data.should include('Post footer')
  end

  it "returns rendered_home_page as a rendered object" do
    @rendered_home_page.should be_an(RenderedObject)
    @rendered_home_page.data.should include('html')
    @rendered_home_page.data.should include('body')
    @rendered_home_page.data.should include('This is the index of a blog')
    @rendered_home_page.data.should include('Content index haml')
    @rendered_home_page.data.should include('post001.html')
    @rendered_home_page.data.should include('post002.html')
    @rendered_home_page.data.should include('post003.html')
    @rendered_home_page.data.should include('post004.html')
  end

  it "rendered all files" do
    Dir['output/**/*.html'].count.should == 5
  end
end
