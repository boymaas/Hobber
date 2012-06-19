# Hobber

A minimalistic static blogging engine

## Installation

Add this line to your application's Gemfile:

    gem 'hobber'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hobber

## Philosophy

Files are objects, objects can be composed and accessed.
Files can be scanned, inside, directories and can be filtered.

## Usage

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
