require 'hobber'

describe "hobber renders a blog" do
  before { extend Hobber }
  it "scans and loads files wich are rendered to a target directory" do
    chdir File.dirname(__FILE__) 
    blog_posts  = scan 'source/posts/**/*'
    index_page  = file 'source/index'
    main_layout = file 'source/layout'
    blog_layout = file 'source/posts/layout'

    render blog_posts, :layout => blog_layout, :to => 'output/posts/'

    rendered_blog_posts = render blog_posts do
      layout        blog_layout
      rewrite_path  %r|^source|, 'output'
    end

    rendered_home_page = render index_page do
      layout        main_layout
      rewrite_path  %r|^source|, 'output'
      tmpl_vars :blog_posts => rendered_blog_posts
    end
  end
end
